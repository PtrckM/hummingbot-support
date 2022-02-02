#!/bin/bash
# timestamp in python to readable format
# csv / sqlite hb
#
# script created by PtrckM
#
# usage: wget https://raw.githubusercontent.com/PtrckM/hummingbot-support/master/timestamp.sh
#        chmod a+x run
#        ./timestamp.sh or ./timestamp.sh 1643428161295
#

if [[ -z "$@" ]]; then
   echo -ne "\n[*] -- Timestamp converter to readable format..."
   echo -ne "\n[*] -- Usage: ./timestamp.sh or ./timestamp.sh 1643428161295\n\n"
   echo -ne "[-] -- Enter timestamp >> "
   read timestamp
   date -d @$timestamp
   echo ""
   exit 1
else
   echo -ne "\n[+] -- Readable time ==> "
   date -d @$(($@/1000))
   echo ""
   exit 1
fi
