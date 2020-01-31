#!/bin/bash
# for testing current availalable branch thru dev. 
# make sure your not inside `hummingbot/` folder
# usage: wget https://raw.githubusercontent.com/PtrckM/hummingbot-support/master/dev-branch.sh
#        chmod a+x dev-branch.sh
#       ./dev-branch.sh

echo -ne "\n[*] - setting up configurations...\n"
export CONDAPATH="$(pwd)/miniconda3"
export PYTHON="$(pwd)/miniconda3/envs/hummingbot/bin/python3"
export hummingbotPath="$(pwd)/hummingbot"
echo -ne "\n[*] - deactivating conda hummingbot...\n"
${CONDAPATH}/bin/deactivate
${CONDAPATH}/bin/deactivate
${CONDAPATH}/bin/deactivate
${CONDAPATH}/bin/activate
${CONDAPATH}/bin/activate hummingbot
${CONDAPATH}/bin/deactivate
echo -ne "\n[*] - removing old environments...\n"
rm -rf $(pwd)/miniconda3/envs/hummingbot
cd $hummingbotPath
echo -ne "\n[*] - uninstalling...\n"
./uninstall
echo -ne "\n[*] - housekeeping...\n"
./clean
echo -ne "\n[*] - downloading development...\n"
git pull origin development
echo -ne "\n[*] - switching...\n"
git fetch origin
echo -ne "\n[*] - listing dev branches...\n"
git branch -a
# Test branch
echo -ne "[-] - Enter Branch Name >> "
read branch_name
git checkout $branch_name
git pull origin $branch_name
echo -n "[*] - using branch >> $branch_name <<"
read -t 5 -n 1 -s -r -p "Press any key to continue"
./install
${CONDAPATH}/bin/activate hummingbot
./compile
${PYTHON} bin/hummingbot.py


