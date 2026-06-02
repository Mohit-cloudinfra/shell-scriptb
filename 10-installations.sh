#!/bin/bash

u=$(id -u)

if [ $u -ne 0 ]; then
    echo "user is not root"
    exit 1
fi
dnf install ngindddx -y

if [ $? -ne 0 ]; then
    echo "there is failure"
    exit 1
fi