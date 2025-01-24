#!/usr/bin/env bash
# Installation of the sript can be started by calling
# cd; bash <(wget -qO- https://raw.githubusercontent.com/clemensgoering/sound-box/main/misc/scripts/install/main.sh)

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
    clear
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
    touch "${SOUNDBOX_HOME_DIR}/${CONFIG_FILE}"
    echo "# Overall config" > "${SOUNDBOX_HOME_DIR}/${CONFIG_FILE}"
    echo "-- Configuration file created."
}

loading_general_updates(){
    local apt_get="sudo apt-get -qq --yes"
    clear
    echo ""
    echo "-- Updating & Upgrading system. Please be patient..."
    # -qq quite mode, active = yes
    ${apt_get} update
    ${apt_get} upgrade
    echo "-- Update completed."
    check_continue "Loading GIT Data"
}

prepare_autostart() {
    # copy files
    bash "${SOUNDBOX_HOME_DIR}/${GIT_REPO}/misc/scripts/install/autostart.sh"
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
    if [[ ${CONTINUE} == "true" ]]; then
        bash "${SOUNDBOX_HOME_DIR}/${GIT_REPO}/misc/scripts/install/git.sh"
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
    source var.sh
    env
    logger "Installation started..."
    welcome
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
