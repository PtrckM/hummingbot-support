#!/bin/bash
#
# for downloading latest development thru source. 
# make sure your not inside `hummingbot/` folder
# this will delete existing hummingbot clone
# hummingbot/conf will be backup and reload.
#
# usage: wget https://raw.githubusercontent.com/PtrckM/hummingbot-support/master/dev-renew.sh
#        chmod a+x dev-renew.sh
#       ./dev-renew.sh

export CONDAPATH="$(pwd)/miniconda3"
export PYTHON="$(pwd)/miniconda3/envs/hummingbot/bin/python3"
export hummingbotPath="$(pwd)/hummingbot"
${CONDAPATH}/bin/deactivate
rm -rf $(pwd)/miniconda3/envs/hummingbot
mv $hummingbotPath/conf /tmp/conf
rm -rf $(pwd)/hummingbot
git clone https://github.com/CoinAlpha/hummingbot.git
git pull origin development
git fetch origin
cd $hummingbotPath
./install
${CONDAPATH}/bin/activate hummingbot
./compile
mv /tmp/conf conf
${PYTHON} bin/hummingbot.py
