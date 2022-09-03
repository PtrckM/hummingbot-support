#!/bin/bash
# timestamp in mysql to readable format (using UTC)
#
# script created by PtrckM
#
# usage: wget https://raw.githubusercontent.com/PtrckM/hummingbot-support/master/timestampsql.sh
#        chmod a+x run
#        ./timestampsql.sh or ./timestampsql.sh 1661818525000
#

 if [[ -z "$@" ]]; then
   echo -ne "\n[*] -- TimestampSQL converter to readable format..."
   echo -ne "\n[*] -- Usage: ./timestampsql.sh or ./timestampsql.sh 1661818525000\n\n"
   echo -ne "[-] -- Enter timestamp >> "
   read timestamp
   echo -ne "\n[i] -- Converting datetime ==> "
   D=$(date -u -j -f %s  $(($timestamp/1000)) '+%m/%d/%Y:%H:%M:%S').$(($timestamp%1000));  echo "[$timestamp] ==> [$D]"
   echo ""
   exit 1
else
    echo -ne "\n[i] -- Converting datetime ==> "
        D=$(date -u -j -f %s  $(($@/1000)) '+%m/%d/%Y:%H:%M:%S').$(($@%1000));  echo "[$@] ==> [$D]"
    echo ""
   exit 1
fi
