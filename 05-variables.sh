#!/bin/bash

#read is like scan and read -s means youdont see what you are typing

echo "enter username"
read user

echo "user name is $user"

echo "enter password"
read -s password

echo "your password is $password"