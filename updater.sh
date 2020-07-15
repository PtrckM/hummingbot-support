#!/bin/bash
# 
# modded by: PtrckM
# docker build create or update script
# usage: wget https://raw.githubusercontent.com/PtrckM/hummingbot-support/master/updater.sh
#        chmod a+x updater.sh
#        ./updater.sh
#
# init
function pause() {
  read -p "$*"
}

echo
echo "[*] -- creator or updater docker build hummingbot "
echo "[*] -- modded by: PtrckM v1"
echo 
echo "[*] -- press enter for default"
echo
echo -ne "[*] -- Hummingbot version: [latest|dev] (default = \"latest\") >> "
read TAG
if [ "$TAG" == "" ]
 then
  TAG="latest"
 else 
  TAG="development"
fi
echo
echo "[*] -- listing docker instances..."
docker ps -a | awk '{print $NF}'
echo
echo
echo -ne "[*] -- enter instance name: (default = \"hummingbot-instance\") >> "
read INSTANCE_NAME
if [ "$INSTANCE_NAME" == "" ];
then
  INSTANCE_NAME="hummingbot-instance"
  DEFAULT_FOLDER="hummingbot_files"
else
  DEFAULT_FOLDER="${INSTANCE_NAME}_files"
fi
echo
echo "=> Instance name: $INSTANCE_NAME"
echo
echo -ne "[*] -- Enter a folder name: (default = \"$DEFAULT_FOLDER\") >> "
read FOLDER
if [ "$FOLDER" == "" ]
then
  FOLDER=$DEFAULT_FOLDER
fi
echo
echo "Creating your hummingbot instance: \"$INSTANCE_NAME\" (coinalpha/hummingbot:$TAG)"
echo
echo "Your files will be saved to:"
echo "=> instance folder:    $PWD/$FOLDER"
echo "=> config files:       ├── $PWD/$FOLDER/hummingbot_conf"
echo "=> log files:          ├── $PWD/$FOLDER/hummingbot_logs"
echo "=> data file:          └── $PWD/$FOLDER/hummingbot_data"
echo "=> scripts files:      └── $PWD/$FOLDER/hummingbot_scripts"
echo
pause Press [Enter] to continue
echo
echo "[*] -- creating folders and files..."
echo
mkdir $FOLDER
mkdir $FOLDER/hummingbot_conf
mkdir $FOLDER/hummingbot_logs
mkdir $FOLDER/hummingbot_data
mkdir $FOLDER/hummingbot_scripts
echo
echo "[*] -- listing docker instances..."
echo
#docker ps -a | awk '{print $NF}'
docker ps -a --filter ancestor=coinalpha/hummingbot:$TAG
echo
echo "[*] -- removing old instance/s on background..."
echo
docker ps -a | grep "$TAG" | awk '{print $1}' | xargs docker rm
echo
echo "[*] -- if updating image choose y if just recreating new instance choose n..."
echo -ne "[*] -- delete old images (y/n) >> "
read THE_ANSWER
echo
if [ "$THE_ANSWER" == "y" ];
then
docker rmi coinalpha/hummingbot:$TAG
echo
echo "[*] -- downloading and installing image.."
echo
else
echo
echo "[*] -- running the image.."
echo
fi
docker run -it --log-opt max-size=10m --log-opt max-file=5 \
--network host \
--name $INSTANCE_NAME \
--mount "type=bind,source=$(pwd)/$FOLDER/hummingbot_conf,destination=/conf/" \
--mount "type=bind,source=$(pwd)/$FOLDER/hummingbot_logs,destination=/logs/" \
--mount "type=bind,source=$(pwd)/$FOLDER/hummingbot_data,destination=/data/" \
--mount "type=bind,source=$(pwd)/$FOLDER/hummingbot_scripts,destination=/scripts/" \
coinalpha/hummingbot:$TAG
