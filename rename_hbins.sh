#!/bin/bash
#
# Renamer HB instance docker build - rename instance and folder mounts.
# created by: PtrckM
#
# usage: wget https://raw.githubusercontent.com/PtrckM/hummingbot-support/master/rename_hbins.sh
#  chmod a+x rename_hbins.sh
#  ./rename_hbins.sh
#

echo -ne "\n[*] -- Renamer HB instance - docker build\n"
echo -ne "[*] -- listing instance names...\n\n"
docker ps -a | awk '{print $NF, $2}'
echo -ne "\n[-] -- Enter instance name to be renamed >> "
read INST1
echo -ne "[-] -- Enter new instance name >> "
read INST2
echo -ne "[-] -- Enter release version (development | latest) >> "
read TAG
echo -ne "[+] -- renaming instance from $INST1 to $INST2 ...\n"
docker rename $INST1 $INST2
echo -ne "[*] -- stopping new instance ... "
docker rm $INST2
echo -ne "[*] -- moving folders and mounts ...\n"
FOLD1=${INST1}_files
FOLD2=${INST2}_files
mv $FOLD1 $FOLD2
echo -ne "[+] -- launching the new instance...\n"
docker run -it \
--name $INST2 \
--mount "type=bind,source=$(pwd)/$FOLD2/hummingbot_conf,destination=/conf/" \
--mount "type=bind,source=$(pwd)/$FOLD2/hummingbot_logs,destination=/logs/" \
--mount "type=bind,source=$(pwd)/$FOLD2/hummingbot_data,destination=/data/" \
coinalpha/hummingbot:$TAG
