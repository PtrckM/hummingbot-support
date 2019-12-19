#!/bin/bash
# timestamp is in milliseconds (divided by 1000)
# IP banned until: date viewer
# script created by PtrckM

echo "Enter timestamp: "
read value
if [ "$value" == ""]
then
 echo "e.g. 1576671608547"
else
 echo "IP banned until:" | date -d @$(($value/1000))
fi
