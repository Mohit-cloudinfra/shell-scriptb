

source ./common.sh

check_root

install_certain "redis" "7"

#i refered the mongodb,sh for this sed command i didnt remember it
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf &>>$LOGS_FILE
check $? "Allowing remote connections"

sed -i 's/"protected mode yes"/"protected mode no/g' /etc/redis/redis.conf &>>$LOGS_FILE
check $? "Disabled protected mode"

enable_start "redis"