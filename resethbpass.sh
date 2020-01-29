#!/bin/bash
#
# Reset Password for hummingbot docker build
# created by: PtrckM
#
# usage: wget https://raw.githubusercontent.com/PtrckM/hummingbot-support/master/resethbpass.sh
#        chmod a+x resethbpass.sh
#        ./resethbpass.sh
#

echo -ne "\n[*] -- Reset Password - HB docker build v1\n"
echo "[-] "
echo "[*] -- Warning: This will delete encrypted api+key+secret files and wallet keyfiles."
echo "[*] --          Created wallet thru hummingbot will lose and cannot be used again,"
echo "[*] --          you have been warned..."
echo "[-] "
echo -ne "[*] -- listing docker names...\n\n"
docker ps -a | awk '{print $NF}'
echo -ne "\n[-] -- Enter name of instance >> "
read INSTANCE
INSTANCER="${INSTANCE}_files"
echo -ne "[*] -- locating files for $INSTANCE...\n\n"
ls -lah $INSTANCER/hummingbot_conf/encrypted* $INSTANCER/hummingbot_conf/key_file* | awk '{print $NF}'
echo -ne "\n[-] -- are you sure you want to continue? (y/n) >> "
read ANSWER
if [ "$ANSWER" == "y" ];
then
echo "[*] -- deleting files..."
rm -f $INSTANCER/hummingbot_conf/encrypted* $INSTANCER/hummingbot_conf/key_file*
echo "[*] -- operation success, password has been reset..."
exit
else
echo -ne "[!] -- operation aborted... exiting!\n\n"
fi
exit





