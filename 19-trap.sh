#!/bin/bash

set -e
trap 'echo "hello world this is $LINENO command is $BASH_COMMAND"' ERR
USERID=$(id -u)
logs="/var/log/shell-script/$0.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

mkdir -p "/var/log/shell-script"

if [ $USERID -ne 0 ]; then
    echo -e "$R Please run this script with root user access $N" | tee -a $logs
    exit 1
fi


for i in $@
do
    dnf list installed $i &>> $logs
    if [ $? -ne 0 ]; then
        echo "$i not installed installing now"
        dnf install $i -y &>> $logs
    else
        echo -e "$i already installed $Y skipping $N"
    fi
done