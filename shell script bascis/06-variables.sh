#!/bin/bash

#(...) this is how you take command output inot variables
start=$(date +%s)
#+%s gives number from 1970 jan one how many secs have passed
echo "started at $start"

sleep 5
endf=$(date +%s)
total=$(($endf-$start))
#one brace to perform maths operation and other brace to take command output into variables
echo "ended at $endf"

echo "total is $total"