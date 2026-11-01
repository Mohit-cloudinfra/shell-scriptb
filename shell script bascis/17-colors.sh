#!/bin/bash

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

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo -e "$2 ... $R FAILURE $N" | tee -a $logs
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N" | tee -a $logs
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
    dnf list installed $i &>> $logs
    if [ $? -ne 0 ]; then
        echo "$i not installed installing now"
        dnf install $i -y &>> $logs
        VALIDATE $? "$i installation"
    else
        echo -e "$i already installed $Y skipping $N"
    fi
done