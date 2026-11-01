#!/bin/bash

USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_FILE="$LOGS_FOLDER/$0.log"                 
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
SCRIPT_DIR=$PWD
MONGODB_HOST=mongodb.mohitsai.cloud

mkdir -p "$LOGS_FOLDER"

if [ $USERID -ne 0 ]; then
    echo -e "$R Please run this script with root user access $N" | tee -a $LOGS_FILE
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo -e "$2 ... $R FAILURE $N" | tee -a $LOGS_FILE
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N" | tee -a $LOGS_FILE
    fi
}

dnf module disable nodejs -y &>>$LOGS_FILE
VALIDATE $? "disable default"

dnf module enable nodejs:20 -y &>>$LOGS_FILE
VALIDATE $? "enable 20 version"

dnf install nodejs -y &>>$LOGS_FILE
VALIDATE $? "Installling"

id roboshop
if [$? -ne 0]; then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOGS_FILE
    VALIDATE $? "Creating system user"
else
    echo -e "roboshop user already exists $Y skipping $N"
fi

mkdir -p /app &>>$LOGS_FILE
VALIDATE $? "Creating app folder"

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip  &>>$LOGS_FILE
VALIDATE $? "Downloading code"

cd /app &>>$LOGS_FILE
VALIDATE $? "opening app folder"

rm -rf /app/* 
VALIDATE $? "Removing exsisting code"

unzip /tmp/catalogue.zip &>>$LOGS_FILE
VALIDATE $? "Unziping catalogue"

npm install &>>$LOGS_FILE
VALIDATE $? "Installing dependiecies"

cp $SCRIPT_DIR/catalogue.service /etc/systemd/system/catalogue.service
VALIDATE $? "Copying service"

systemctl daemon-reload
VALIDATE $? "Reloading"

systemctl enable catalogue 
VALIDATE $? "Enabling catalogue"

systemctl start catalogue
VALIDATE $? "Starting catalogue"

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Copying repo"

dnf install mongodb-mongosh -y

mongosh --host $MONGODB_HOST </app/db/master-data.js
