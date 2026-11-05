#!/bin/bash

count=1
touch a.txt
cat a.txt
# while [ $count -le 5 ]
# do
#     echo "count is $count" >> a.txt
#     sleep 1
#     ((count++))
# done
# cat a.txt

while IFS= read -r line ;
do
    echo "$line"
done < a.txt

rm -f a.txt
