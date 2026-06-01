#!/bin/bash

read n
# -gt greter than
# -lt less than 
# -eq equal
# -ne not equal

if [ $n -gt 20 ]; then
    echo "$n is greater"
elif [ $n -lt 20 ]; then
    echo "$n is lesser"
elif [ $n -eq 20 ]; then
    echo "equal"
fi

