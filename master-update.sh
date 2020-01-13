#!/bin/bash
# for downloading latest release thru source. 
# make sure your not inside `hummingbot/` folder
# usage: wget https://raw.githubusercontent.com/PtrckM/hummingbot-support/master/master-update.sh
#        chmod a+x master-update.sh
#       ./master-update.sh

export CONDAPATH="$(pwd)/miniconda3"
export PYTHON="$(pwd)/miniconda3/envs/hummingbot/bin/python3"
export hummingbotPath="$(pwd)/hummingbot" && cd $hummingbotPath
${CONDAPATH}/bin/deactivate
rm -rf $(pwd)/miniconda3/envs/hummingbot
./uninstall
./clean
git pull origin master
git fetch origin
./install
${CONDAPATH}/bin/activate hummingbot
# compile
./compile
# start hummingbot
${PYTHON} bin/hummingbot.py
