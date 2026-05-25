#!/bin/bash

start=$(date +%s)

echo "started at $start"

sleep 5
endf=$(date +%s)
total=$(($endf-$start))

echo "ended at $endf"

echo "total is $total"