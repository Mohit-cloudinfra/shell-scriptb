#!/bin/bash

# Undoes everything mongodb.sh does, so it can be practiced again.
# Deletes all MongoDB data - only for a practice machine. Safe to run more than once.

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ $USERID -ne 0 ]; then
    echo -e "$R Please run this script with root user access $N"
    exit 1
fi

if ! command -v dnf &> /dev/null; then
    echo -e "$R dnf not found. This script is for RHEL family systems $N"
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo -e "$2 ... $R FAILURE $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}

if systemctl list-unit-files mongod.service | grep -q mongod; then
    systemctl stop mongod
    VALIDATE $? "Stopping mongod"

    systemctl disable mongod
    VALIDATE $? "Disabling mongod"
else
    echo -e "mongod service not found ... $Y SKIPPING $N"
fi

if rpm -qa | grep -q '^mongodb-'; then
    dnf remove 'mongodb-*' -y
    VALIDATE $? "Removing mongo packages"
else
    echo -e "mongo packages not found ... $Y SKIPPING $N"
fi

rm -f /etc/yum.repos.d/mongo.repo
VALIDATE $? "Removing mongo repo"

rm -rf /var/cache/dnf/mongodb-org-*
VALIDATE $? "Removing mongo repo cache"

rm -f /etc/mongod.conf /etc/mongod.conf.rpmsave
VALIDATE $? "Removing mongo config"

rm -rf /var/lib/mongo /var/log/mongodb
VALIDATE $? "Removing mongo data and logs"

rm -f /tmp/mongodb-*.sock
VALIDATE $? "Removing mongo socket"

rm -rf /var/log/shell-roboshop
VALIDATE $? "Removing roboshop logs"

if id mongod &> /dev/null; then
    userdel mongod
    VALIDATE $? "Removing mongod user"
fi

if getent group mongod &> /dev/null; then
    groupdel mongod
    VALIDATE $? "Removing mongod group"
fi

systemctl daemon-reload
VALIDATE $? "Reloading systemd"

echo -e "$G Cleanup done. You can run mongodb.sh again $N"
