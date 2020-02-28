#!/bin/bash
# timestamp is in milliseconds (divided by 1000)
# IP banned until: date viewer
# script created by PtrckM
#
# usage: wget https://raw.githubusercontent.com/PtrckM/hummingbot-support/master/ipbanview.sh
#        chmod a+x run
#        ./ipbanview.sh or ./ipbanview.sh 1576671608547
#

if [[ -z "$@" ]]; then
   echo -ne "\n[*] -- IP banned until: date viewer..."
   echo -ne "\n[*] -- Usage: ./ipbanview.sh or ./ipbanview.sh 1576671608547\n\n"
   echo -ne "[-] -- Enter timestamp >> "
   read timestamp
   echo -ne "[*] -- IP banned until ==> "
   date -d @$(($timestamp/1000))
   echo ""
   exit 1
else
   echo -ne "\n[+] -- IP banned until ==> "
   date -d @$(($@/1000))
   echo ""
   exit 1
fi
