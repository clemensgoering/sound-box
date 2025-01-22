#!/usr/bin/env bash
# Installation of the sript can be started by calling
# cd; bash <(wget -qO- https://raw.githubusercontent.com/clemensgoering/sound-box/main/misc/install_script.sh)

GIT_REPO=${GIT_REPO:-sound-box}
GIT_BRANCH=${GIT_BRANCH:-main}
GIT_URL=${GIT_URL:-https://github.com/clemensgoering/sound-box.git}
DATETIME=$(date +"%Y%m%d_%H%M%S")

CURRENT_USER="${SUDO_USER:-$(whoami)}"
HOME_DIR=$(getent passwd "$CURRENT_USER" | cut -d: -f6)

SOUNDBOX_HOME_DIR="${HOME_DIR}/Sound-Box"


CONTINUE=true

################################
#
# Helper functions for processing within the installation script
#
################################
_escape_for_shell() {
	local escaped="${1//\"/\\\"}"
	escaped="${escaped//\`/\\\`}"
    escaped="${escaped//\$/\\\$}"
	echo "$escaped"
}

call_with_args_from_file () {
    local package_file="$1"
    shift

    sed 's|#.*||g' ${package_file} | xargs "$@"
}

check_continue(){
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
# /_______  /\____/|____/|___|  /\____ |  |___  /\____/__/\_ \
#         \/                  \/      \/      \/            \/
# You are turning your Raspberry Pi into a Soundbox. 
# Continue with the installation.
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

finished() {
    echo "
#####################################################
# INSTALLATION FINISHED
#####################################################
Let the sounds begin."
}

create_config_file() {
    # CONFIG FILE
    # Create empty config file
    touch "${SOUNDBOX_HOME_DIR}/configuration.conf"
    echo "# Overall config" > "${SOUNDBOX_HOME_DIR}/configuration.conf"
    echo "-- Configuration file created."
}

loading_general_updates(){
    local apt_get="sudo apt-get -qq --yes"
    clear
    echo "################################################"
    echo "GIT_BRANCH ${GIT_BRANCH}"
    echo "GIT_URL ${GIT_URL}"
    echo "User home dir: ${HOME_DIR}"
    echo "################################################"

    echo "-- Updating & Upgrading system. Please be patient..."
    # -qq quite mode, active = yes
    ${apt_get} update
    ${apt_get} upgrade
    echo "-- Update completed."
    check_continue "Loading GIT Data"
}

loading_nodejs(){        
    local apt_get="sudo apt-get -qq --yes"
    local allow_downgrades="--allow-downgrades --allow-remove-essential --allow-change-held-packages"
    if [[ ${CONTINUE} == "true" ]]; then
        clear
        echo "
################################################
# Nodejs and Docker related tasks...
################################################"
        echo "-- Loading necessary packages..."
        # Spotify and node server dependencies / packages
        echo "-- // Loading packages from: ${SOUNDBOX_HOME_DIR}/${GIT_REPO}/packages-node.txt"
        call_with_args_from_file "${SOUNDBOX_HOME_DIR}/${GIT_REPO}/packages-node.txt" ${apt_get} ${allow_downgrades} install
        # globally install express for the docker nodejs application
        npm install -g express
        check_continue "Preparing Docker container..."
    fi
}

processing_docker(){
    if [[ ${CONTINUE} == "true" ]]; then
        clear
        echo "
################################################
# Docker installation and preparation
################################################"
        cd "${SOUNDBOX_HOME_DIR}/${GIT_REPO}/docker"
        npm install
        echo "-- NodeJS and Docker installation finished"
    fi
}

loading_git(){    
    local apt_get="sudo apt-get -qq --yes"
    if [[ ${CONTINUE} == "true" ]]; then
        clear
        echo "
################################################
# Installing Git and all dependencies...
################################################"
        # Get github code. git must be installed before, even if defined in packages.txt!
        ${apt_get} install git
        echo "-- Create folder and config file"
        mkdir "${SOUNDBOX_HOME_DIR}"
        create_config_file
        cd "${SOUNDBOX_HOME_DIR}"
        git clone ${GIT_URL} --branch "${GIT_BRANCH}"
        echo "-- Fetching git data completed"
        sudo chmod 775 "${SOUNDBOX_HOME_DIR}/${GIT_REPO}"
        echo "-- Access updated to fetched git folder (775)"
        check_continue "Loading NodeJS Data and Dependencies..."
    fi
}

install(){    
    #clear console
    clear

    loading_general_updates
    ################################
    # GIT
    ################################
    loading_git
    ################################
    # NodeJS and Docker
    ################################
    loading_nodejs
    processing_docker


}


################################
# 
# Main
#  
################################
main() {
    welcome
    finished
}

start=$(date +%s)

main

end=$(date +%s)
runtime=$((end-start))
((h=${runtime}/3600))
((m=(${runtime}%3600)/60))
((s=${runtime}%60))
echo "Done (in ${h}h ${m}m ${s}s)."
