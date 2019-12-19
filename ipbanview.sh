#!/bin/bash
# timestamp is in milliseconds (divided by 1000)
# IP banned until: date viewer
# script created by PtrckM

echo -n "Enter timestamp (e.g. 1576671608547): "
read $VALUE
echo -n "IP banned until: "
date -d @$(($VALUE/1000))
