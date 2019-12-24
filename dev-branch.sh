#!/bin/bash

export CONDAPATH="$(pwd)/miniconda3"
export PYTHON="$(pwd)/miniconda3/envs/hummingbot/bin/python3"
export hummingbotPath="$(pwd)/hummingbot" && cd $hummingbotPath
# REMOVE OLD INSTALLATION
${CONDAPATH}/bin/deactivate
rm -rf ../miniconda3/envs/hummingbot
./uninstall
./clean
# UPDATE HUMMINGBOT
# Download latest code
git pull origin development
git fetch origin
git branch -a
# Test branch
echo -ne "Enter Branch Name: "
read branch_name
git checkout $branch_name
git pull origin $branch_name
./install
${CONDAPATH}/bin/activate hummingbot
# compile
./compile
# start hummingbot
${PYTHON} bin/hummingbot.py


