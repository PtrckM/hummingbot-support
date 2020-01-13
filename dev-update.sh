#!/bin/bash
# for testing current availalable branch thru dev. 
# make sure your not inside `hummingbot/` folder
# usage: wget https://raw.githubusercontent.com/PtrckM/hummingbot-support/master/dev-update.sh
#        chmod a+x dev-update.sh
#       ./dev-update.sh

echo -ne "\n[] - setting up configurations...\n"
export CONDAPATH="$(pwd)/miniconda3"
export PYTHON="$(pwd)/miniconda3/envs/hummingbot/bin/python3"
export hummingbotPath="$(pwd)/hummingbot" && cd $hummingbotPath
echo -ne "\n[] - deactivating conda hummingbot...\n"
${CONDAPATH}/bin/deactivate
echo -ne "\n[] - removing old environments...\n"
rm -rf $(pwd)/miniconda3/envs/hummingbot
echo -ne "\n[] - uninstalling...\n"
./uninstall
echo -ne "\n[] - housekeeping...\n"
./clean
echo -ne "\n[] - downloading development...\n"
git pull origin development
echo -ne "\n[] - switching...\n"
git fetch origin
echo -ne "\n[] - installing...\n"
./install
${CONDAPATH}/bin/activate hummingbot
echo -ne "\n[] - compiling...\n"
./compile
echo -ne "\n[] - starting...\n"
${PYTHON} bin/hummingbot.py


