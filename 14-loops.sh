#!/bin/bash

USERID=$(id -u)
logs="/var/log/shell-script/$0.log"

if [ $USERID -ne 0 ]; then
    echo "Please run this script with root user access"
    exit 1
fi

mkdir -p "/var/log/shell-script"

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo "$2 ... FAILURE" | tee -a $logs
        exit 1
    else
        echo "$2 ... SUCCESS" | tee -a $logs
    fi
}

# echo "Installing Nginx"
# dnf install nginx -y &>> $logs
# VALIDATE $? "nginx installation"


# dnf install mysql -y &>> $logs
# VALIDATE $? "mysql installation"

# dnf install nodejs -y &>> $logs
# VALIDATE $? "nodejs installation"

for i in $@
do
    dnf install $i -y &>> $logs
    VALIDATE $? "$i installation"
done