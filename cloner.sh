#!/bin/bash

# Hummingbot Clint Cloner v1.0
# this script will download the repo and install its own conda environment
# created by: Patrick
#
# Requirements: installed conda

cd $(dirname $0)

# Compatibility logic for older Anaconda versions.
if [ "${CONDA_EXE} " == " " ]; then
    CONDA_EXE=$((find /opt/conda/bin/conda || find ~/anaconda3/bin/conda || \
            find /usr/local/anaconda3/bin/conda || find ~/miniconda3/bin/conda  || \
            find /root/miniconda/bin/conda || find ~/Anaconda3/Scripts/conda) 2>/dev/null)
fi

if [ "${CONDA_EXE}_" == "_" ]; then
    echo "Please install Anaconda w/ Python 3.7+ first"
    echo "See: https://www.anaconda.com/distribution/"
    exit 1
fi

CONDA_BIN=$(dirname ${CONDA_EXE})

echo ""
echo "[i] Hummingbot Client Cloner (branch+custom env) v1.0"
echo ""
read -p "[-] Enter which repo to clone [coinalpha, hummingbot] (default = \"coinalpha\") >>> " REPO
if [ "$REPO" == "" ]
then
  REPO="coinalpha"
fi

read -p "[-] Enter branch name (eg. fix/trade_fee) >>> " BRANCH

DEFAULT_FOLDER="hummingbot"
read -p "[-] Enter a folder name where your Hummingbot files will be saved (default = \"$DEFAULT_FOLDER\") >>> " FOLDER
if [ "$FOLDER" == "" ]
then
          FOLDER=$PWD/$DEFAULT_FOLDER
  elif [[ ${FOLDER::1} != "/" ]]; then
            FOLDER=$PWD/$FOLDER
fi

read -p "[-] Enter name of environment (default = \"hummingbot\") >>> " ENV_NAME
if [ "$ENV_NAME" == "" ]
then
  ENV_NAME="hummingbot"
fi

work_start1=$SECONDS

echo ""
echo "[+] Started working... please wait"
git clone -b $BRANCH https://github.com/$REPO/hummingbot $FOLDER -q
work_end1=$SECONDS
echo "[i] Download took $((work_end1-work_start1)) seconds."
echo ""

echo ""
echo "[+] setting env name..."

 sed -i -e 's/name: hummingbot/name: '"$ENV_NAME"'/g' $FOLDER/setup/environment.yml
 sed -i -e 's/name: hummingbot/name: '"$ENV_NAME"'/g' $FOLDER/setup/environment-linux.yml
 sed -i -e 's/name: hummingbot/name: '"$ENV_NAME"'/g' $FOLDER/setup/environment-linux-aarch64.yml
 sed -i -e 's/name: hummingbot/name: '"$ENV_NAME"'/g' $FOLDER/setup/environment-win64.yml
 sed -i -e 's/hummingbot/'"$ENV_NAME"'/g' $FOLDER/install
 sed -i -e 's/hummingbot/'"$ENV_NAME"'/g' $FOLDER/uninstall

work_start2=$SECONDS
cd $FOLDER
echo ""
echo "[i] Installing dependencies to: $ENV_NAME"
echo "[+] Please wait... it may take awhile (depends on your internet)"
./install &>/dev/null
work_end2=$SECONDS
echo "[i] Installation took $((work_end2-work_start2)) seconds."

echo ""
echo "[i] Successfully created... listing your environment"
conda env list | grep $ENV_NAME

echo ""
echo "[+] Activating your environment!"
source "${CONDA_BIN}/activate" $ENV_NAME
echo ""

work_start3=$SECONDS
echo "[+] Compiling now... please wait 3-5mins (depends on your machine)"
cd $FOLDER
./compile &>/dev/null
work_end3=$SECONDS
echo "[i] Compiling took $((work_end3-work_start3)) seconds."

echo ""
echo "[i] Listing summary setup"
echo ""
echo "    Repo: https://github.com/$REPO/hummingbot"
echo "    Branch: $BRANCH"
echo "    Environment name: $ENV_NAME"
echo "    Working directory: $FOLDER"
echo ""
echo "[i] All work are done... enjoy hunting bugs!!! \m/"
echo ""
echo "[i] Please enter: cd $FOLDER && conda activate $ENV_NAME && bin/hummingbot.py"
echo ""
