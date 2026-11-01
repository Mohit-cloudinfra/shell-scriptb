#!/bin/bash

set -e #ERR

trap 'echo "this is $LINENO, command : $BASH_COMMAND"' ERR

echo "hellow world"
echo "i am setting trap for error"
echoo "this is should not pront"
echo "has it"