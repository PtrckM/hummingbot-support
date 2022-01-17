#!/bin/bash

# Hummingbot Clint Cloner v2.0
# this script will download the repo and install its own conda environment
# created by: Patrick
#
# Requirements: installed conda
# usage: wget https://raw.githubusercontent.com/PtrckM/hummingbot-support/master/clonerV2.sh
#        chmod +x clonerV2.sh
#        ./clonerV2.sh
#

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

############################################################################################################
# spinner sniff - start

function _spinner() {
    # $1 start/stop
    #
    # on start: $2 display message
    # on stop : $2 process exit status
    #           $3 spinner function pid (supplied from stop_spinner)

    local on_success="DONE"
    local on_fail="FAIL"
    local white="\e[1;37m"
    local green="\e[1;32m"
    local red="\e[1;31m"
    local nc="\e[0m"

    case $1 in
        start)
            echo -ne ${2}
            printf "%3s"

            # start spinner
            i=1
            sp='\|/-'
            delay=${SPINNER_DELAY:-0.15}

            while :
            do
                printf "\b${sp:i++%${#sp}:1}"
                sleep $delay
            done
            ;;
        stop)
            if [[ -z ${3} ]]; then
                echo "spinner is not running.."
                exit 1
            fi

            kill $3 > /dev/null 2>&1

            # inform the user uppon success or failure
            echo -en "\b["
            if [[ $2 -eq 0 ]]; then
                echo -en "${green}${on_success}${nc}"
            else
                echo -en "${red}${on_fail}${nc}"
            fi
            echo -e "]"
            ;;
        *)
            echo "invalid argument, try {start/stop}"
            exit 1
            ;;
    esac
}

function start_spinner {
    # $1 : msg to display
    _spinner "start" "${1}" &
    # set global spinner pid
    _sp_pid=$!
    disown
}

function stop_spinner {
    # $1 : command exit status
    _spinner "stop" $1 $_sp_pid
    unset _sp_pid
}

# spinner sniff - end
############################################################################################################



work_start1=$SECONDS

echo ""
start_spinner '[+] Started working... please wait. '
git clone -b $BRANCH https://github.com/$REPO/hummingbot $FOLDER -q
#tput setaf 2; echo "DONE"; tput sgr0
work_end1=$SECONDS
stop_spinner $?
echo "[i] Download completed, took $((work_end1-work_start1)) seconds."
echo ""

start_spinner '[+] setting up env name... '
sed -i -e 's/name: hummingbot/name: '"$ENV_NAME"'/g' $FOLDER/setup/environment.yml
sed -i -e 's/name: hummingbot/name: '"$ENV_NAME"'/g' $FOLDER/setup/environment-linux.yml
sed -i -e 's/name: hummingbot/name: '"$ENV_NAME"'/g' $FOLDER/setup/environment-linux-aarch64.yml
sed -i -e 's/name: hummingbot/name: '"$ENV_NAME"'/g' $FOLDER/setup/environment-win64.yml
sed -i -e 's/hummingbot/'"$ENV_NAME"'/g' $FOLDER/install
sed -i -e 's/hummingbot/'"$ENV_NAME"'/g' $FOLDER/uninstall
stop_spinner $?
#tput setaf 2; echo "UPDATED"; tput sgr0

work_start2=$SECONDS
cd $FOLDER
echo ""
echo "[i] Installing dependencies to $ENV_NAME"
start_spinner '[+] Please wait... it may take awhile (depends on your internet). '
./install &>/dev/null
#tput setaf 2; echo "DONE"; tput sgr0
work_end2=$SECONDS
stop_spinner $?
echo "[i] Installation completed, took $((work_end2-work_start2)) seconds."

echo ""
echo "[i] Successfully created... listing your environment"
conda env list | grep $ENV_NAME

echo ""
echo -ne "[+] Activating your environment! "
source "${CONDA_BIN}/activate" $ENV_NAME
tput setaf 2; echo "OK"; tput sgr0
echo ""

work_start3=$SECONDS
start_spinner '[+] Compiling now... please wait 3-15mins (depends on your machine). '
cd $FOLDER
./compile &>/dev/null
#tput setaf 2; echo "DONE"; tput sgr0
work_end3=$SECONDS
stop_spinner $?
echo "[i] Compiling completed, took $((work_end3-work_start3)) seconds."

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
