#!/bin/bash

GREETING="Hello World Good morning"
echo "$GREETING"
echo "PID of Script1: $$"

source ./script02.sh

# when you try to execute the script first time, permission denied,we need to provide the permissions for 2nd script, if you add source infront of the line, permissions not required and same PID will be used.

