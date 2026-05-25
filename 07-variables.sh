#!/bin/bash

echo "All args passed to script $@"
echo "Numebr fod varibales passed $#"
echo "script nam e $0"
echo "presend directory $PWD"
echo "user is $USER"
echo "home directory is $HOME"
echo "pid is $$"
sleep 100 &
echo "pid of recently exrecuted bcakground process is $!"
echo "alll args passed to script is $*"
