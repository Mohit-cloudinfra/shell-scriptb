#!/bin/bash

u=$(id -u)

if [ $u -ne 0 ]; then
    echo "user is not root"
    exit 1

dnf install nginx -y

if [ $? -ne 0 ]
    echo "there is failure"
    exit 1
