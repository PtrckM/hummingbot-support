#!/bin/bash
# timestamp is in milliseconds (divided by 1000)
# IP banned until: date viewer
# script created by PtrckM
#
# how to use:
# wget https://github.com/PtrckM/hummingbot-support/raw/master/ipbanview.sh
# chmod a+x ipbanview.sh
# ./ipbanview.sh

echo -en "\nEnter timestamp (e.g. 1576671608547) ==> "
read timestamp
echo -ne "IP banned until ==> "
date -d @$(($timestamp/1000))
echo ""
exit

