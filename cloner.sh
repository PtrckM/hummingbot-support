#!/bin/bash

# this script will download the repo and install its own conda environment
#


read -p "Enter which repo to clone [coinalpha, foundation] (default = \"coinalpha\") >>> " REPO
if [ "$REPO" == "" ]
then
  REPO="coinalpha"
fi

read -p "Enter branch name (eg. fix/trade_fee) >>> " BRANCH

foldername=$($BRANCH | tr / _)
git clone -b $BRANCH https://github.com/$REPO/hummingbot $foldername

read -p "Enter name of envinronment (default = \"hummingbot\") >>> " ENV_NAME
if [ "$ENV_NAME" == "" ]
then
  ENV_NAME="hummingbot"
else
        sed -i 's/name: hummingbot/name: $ENV_NAME/g' $foldername/setup/environment.yml
        sed -i 's/name: hummingbot/name: $ENV_NAME/g' $foldername/setup/environment-linux.yml
        sed -i 's/name: hummingbot/name: $ENV_NAME/g' $foldername/setup/environment-linux-aarch64.yml
        sed -i 's/name: hummingbot/name: $ENV_NAME/g' $foldername/setup/environment-win64.yml
fi

sed -i 's/hummingbot/$ENV_NAME/g' $foldername/uninstall

cd $foldername
./install
conda activate $ENV_NAME
./compile
conda env list
