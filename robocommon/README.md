# Roboshop on EC2, with shell scripts

Lab project. These scripts deploy Roboshop, a microservices shop, onto 10 EC2 servers:
one script per component, with the repeated steps in one shared `common.sh`.

## What is here

| File | What it does |
|---|---|
| `roboshop.sh` | Creates the EC2 servers and their Route 53 records with the AWS CLI |
| `common.sh` | Shared functions: root check, logging, install, app setup, Node, Java, Python |
| `mongodb.sh`, `redis.sh`, `mysql.sh`, `rabbitmq.sh` | The data stores |
| `catalogue.sh`, `user.sh`, `cart.sh`, `shipping.sh`, `payment.sh` | The backend services |
| `frontend.sh` | Nginx, the site files and the reverse proxy |

## How to run

From a machine with the AWS CLI configured:

```bash
bash roboshop.sh mongodb redis mysql rabbitmq catalogue user cart shipping payment frontend
```

Then on each server, data stores first and frontend last:

```bash
git clone https://github.com/Mohit-cloudinfra/shell-scriptb.git
cd shell-scriptb/robocommon
sudo sh mongodb.sh     # the script for that server
```

## What broke and how I fixed it

**Symptom.** On the first full run (2 Nov 2026) all 10 scripts printed SUCCESS and the site
loaded, but add to cart hung. `/api/cart/health` returned `"redis":false`.

**How I found it.**

1. `journalctl -u cart` on the cart server showed `Redis ERROR ... "code":"DENIED"`.
2. `nslookup redis.mohitsai.cloud` returned the right private IP, so DNS was fine.
3. `telnet redis.mohitsai.cloud 6379` connected, so the network and security group were
   fine, and Redis answered `-DENIED Redis is running in protected mode`.
4. On the Redis server, `netstat -lntp` showed 6379 on `0.0.0.0`, but
   `grep protected-mode /etc/redis/redis.conf` still showed `yes`.

**Cause.** My `sed` pattern matched nothing. `sed` still exits 0 when nothing matches, so
`check $?` printed SUCCESS and the script carried on.

**Fix.** I set `protected-mode no` and restarted Redis. Telnet stopped returning DENIED,
health showed `"redis":true`, and an order went through from cart to payment.

**What I changed.** `redis.sh` now uses a `sed` that matches, then checks the result with
`grep`, because an exit code of 0 only proves the command ran.

The repeat-run issues below are not fixed yet:

- `rabbitmq.sh` fails on a second run because the user already exists.
- `catalogue.sh` and `shipping.sh` reload their data on every run.

The final `redis.sh` has not been run on a fresh server yet.
