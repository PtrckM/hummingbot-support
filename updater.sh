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
echo "[] -- create or update "
echo
echo
echo "[] -- Hummingbot version: [latest|development] (default = \"latest\")"
read TAG
if [ "$TAG" == "" ]
then
  TAG="latest"
fi
echo
echo "[] -- enter instance name: (default = \"hummingbot-instance\")"
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
echo "[] -- Enter a folder name: (default = \"$DEFAULT_FOLDER\")"
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
echo
pause Press [Enter] to continue
echo "[] -- creating folders and files"
mkdir $FOLDER
mkdir $FOLDER/hummingbot_conf
mkdir $FOLDER/hummingbot_logs
mkdir $FOLDER/hummingbot_data
echo "[] -- removing old instance on background"
docker rm $INSTANCE_NAME
echo "[] -- delete old images (y/n)"
read THE_ANSWER
if [ "$THE_ANSWER" == "y" ];
then
docker rmi coinalpha/hummingbot:$TAG
echo "[] -- downloading and installing image.."
else
echo "[] -- running the image.."
fi
docker run -it \
--name $INSTANCE_NAME \
--mount "type=bind,source=$(pwd)/$FOLDER/hummingbot_conf,destination=/conf/" \
--mount "type=bind,source=$(pwd)/$FOLDER/hummingbot_logs,destination=/logs/" \
--mount "type=bind,source=$(pwd)/$FOLDER/hummingbot_data,destination=/data/" \
coinalpha/hummingbot:$TAG
