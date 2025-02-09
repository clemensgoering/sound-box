#!/usr/bin/env bash
# Installation of the sript can be started by calling
# cd; bash <(wget -qO- https://raw.githubusercontent.com/clemensgoering/sound-box/main/misc/scripts/install/main.sh)
GIT_REPO=${GIT_REPO:-sound-box}
GIT_BRANCH=${GIT_BRANCH:-main}
GIT_URL=${GIT_URL:-https://github.com/clemensgoering/sound-box.git}

CURRENT_USER="${SUDO_USER:-$(whoami)}"
HOME_DIR=$(getent passwd "$CURRENT_USER" | cut -d: -f6)
SOUNDBOX_HOME_DIR="${HOME_DIR}"
#local specific variables
DATETIME=$(date +"%Y%m%d_%H%M%S")
CONFIG_FILE="configuration.conf"
CONTINUE=true

################################
# Helper functions for processing within the installation script
################################
_escape_for_shell() {
	local escaped="${1//\"/\\\"}"
	escaped="${escaped//\`/\\\`}"
    escaped="${escaped//\$/\\\$}"
	echo "$escaped"
}


check_continue(){
    echo ""
    read -rp "Continue next step: '$1'? [Y/n] " response
    case "$response" in
        [nN][oO]|[nN])
            echo "Installation stopped"
            ;;
        *)
            # continue
            ;;
    esac
}


################################
#
# Installation functions
#
################################
welcome() {
    #clear
    echo "
#####################################################
#   _________                        .______.                 
#  /   _____/ ____  __ __  ____    __| _/\_ |__   _______  ___
#  \_____  \ /  _ \|  |  \/    \  / __ |  | __ \ /  _ \  \/  /
#  /        (  <_> )  |  /   |  \/ /_/ |  | \_\ (  <_> >    < 
# /_________/\____/|____/|___|__/\_____|  |_____/\____/__/\__\\
# You are turning your Raspberry Pi into a Soundbox. 
# Continue with the installation.
#------------- Process Variables ----------------
# GIT_BRANCH "$GIT_BRANCH"
# GIT_URL "${GIT_URL}"
# User home dir: "${HOME_DIR}"
#------------------------------------------------
#####################################################"
    read -rp "Continue interactive installation? [Y/n] " response
    case "$response" in
        [nN][oO]|[nN])
            echo "Installation cancelled"
            ;;
        *)
            echo "Installation starting..."
            install
            ;;
    esac
}


create_config_file() {
    # CONFIG FILE
    mkdir "${SOUNDBOX_HOME_DIR}"
    # Create empty config file
    touch "${SOUNDBOX_HOME_DIR}/${GIT_REPO}/${CONFIG_FILE}"
    echo "# Overall config" > "${SOUNDBOX_HOME_DIR}/${GIT_REPO}/${CONFIG_FILE}"
    echo "-- Configuration file created."
}

loading_general_updates(){
    # -qq: Quiet. Produces output suitable for logging, omitting progress indicators. 
    local apt_get="sudo apt-get -qq --yes"
    clear
    echo ""
    echo "-- Updating & Upgrading system. Please be patient..."
    ${apt_get} update
    ${apt_get} upgrade
    echo "-- Update completed."
    echo "-- Remove potential previous installations..."
    # remove all previous existing folders and files
    sudo rm -rf "${SOUNDBOX_HOME_DIR}/${GIT_REPO}"
    check_continue "Loading GIT Data"
}

prepare_autostart() {
    # autostart configuration mandatory
    # no continue check required
    bash "${SOUNDBOX_HOME_DIR}/${GIT_REPO}/misc/scripts/install/autostart.sh"
}

prepare_rfid(){
    # autostart configuration mandatory
    # no continue check required
    bash "${SOUNDBOX_HOME_DIR}/${GIT_REPO}/misc/scripts/install/rfid.sh"
}

loading_nodejs(){        

    if [[ ${CONTINUE} == "true" ]]; then
        bash "${SOUNDBOX_HOME_DIR}/${GIT_REPO}/misc/scripts/install/node.sh"
        check_continue "Preparing Docker container..."
    fi
}

processing_docker(){
    if [[ ${CONTINUE} == "true" ]]; then
        bash "${SOUNDBOX_HOME_DIR}/${GIT_REPO}/misc/scripts/install/docker.sh"
    fi
}

loading_git(){    
    # cant use external bash file
    # since it first needs to be loaded from the git actually
    local apt_get="sudo apt-get -qq --yes"
    if [[ ${CONTINUE} == "true" ]]; then
        clear
        echo "
       _ _     ___           _        _ _ 
  __ _(_) |_  |_ _|_ __  ___| |_ __ _| | |
 / _. | | __|  | || '_ \/ __| __/ _. | | |
| (_| | | |_   | || | | \__ \ || (_| | | |
 \__, |_|\__| |___|_| |_|___/\__\__,_|_|_|
 |___/"
# Get github code. git must be installed before, even if defined in packages.txt!
        echo ""
        echo "-- Checking and preparing git init..."
        ${apt_get} install git
        echo "-- Create folder and config file"
        # load into temp folder
        git clone ${GIT_URL} --branch "${GIT_BRANCH}"
        cd "${SOUNDBOX_HOME_DIR}"/"${GIT_BRANCH}"
        if [ ! -f ${SOUNDBOX_HOME_DIR}/${GIT_REPO}/logger.txt ]; then
            # create logger file
            touch ${SOUNDBOX_HOME_DIR}/${GIT_REPO}/logger.txt    
            sudo chmod 744 ${SOUNDBOX_HOME_DIR}/${GIT_REPO}/logger.txt  
        fi
        echo "-- Fetching git data completed"
        check_continue "Loading NodeJS Data and Dependencies..."
    fi
}

install(){    
    #clear console
    clear
    loading_general_updates
    create_config_file
    # GIT
    loading_git
    # NodeJS and Docker
    loading_nodejs
    processing_docker


}

logger(){
    bash "${SOUNDBOX_HOME_DIR}/${GIT_REPO}/misc/scripts/install/logger.sh" $1
}

################################
# 
# Main
#  
################################
main() {
    #logger "Installation started..."
    welcome
    prepare_rfid
    prepare_autostart
}

start=$(date +%s)

main

end=$(date +%s)
runtime=$((end-start))
((h=${runtime}/3600))
((m=(${runtime}%3600)/60))
((s=${runtime}%60))
echo "Done (in ${h}h ${m}m ${s}s)."
