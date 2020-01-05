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
git pull origin master
git fetch origin
./install
${CONDAPATH}/bin/activate hummingbot
# compile
./compile
# start hummingbot
${PYTHON} bin/hummingbot.py
