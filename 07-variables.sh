#!/bin/bash

echo "All args passed to script $@"
echo "Numebr fod varibales passed $#"
echo "script nam e $0"
echo "presend directory $PWD"
echo "who is running the script is  user is $USER"
echo "home directory is $HOME"
echo "pid of the script is $$"
sleep 100 &
#this will go into background
echo "pid of recently exrecuted bcakground process is $!"
echo "alll args passed to script is $*"
