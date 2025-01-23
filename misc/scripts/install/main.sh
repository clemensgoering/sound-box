#!/usr/bin/env bash
# Installation of the sript can be started by calling
# cd; bash <(wget -qO- https://raw.githubusercontent.com/clemensgoering/sound-box/main/misc/scripts/install/main.sh)

GIT_REPO=${GIT_REPO:-sound-box}
GIT_BRANCH=${GIT_BRANCH:-main}
GIT_URL=${GIT_URL:-https://github.com/clemensgoering/sound-box.git}
DATETIME=$(date +"%Y%m%d_%H%M%S")

CURRENT_USER="${SUDO_USER:-$(whoami)}"
HOME_DIR=$(getent passwd "$CURRENT_USER" | cut -d: -f6)

SOUNDBOX_HOME_DIR="${HOME_DIR}/Sound-Box"
CONFIG_FILE="configuration.conf"

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

run_execute() {
    read -rp "Do you want to start your SoundBox and all Services [Y/n] " response
    case "$response" in
        [nN][oO]|[nN])
            echo "
-- Service execution can always be done via
-- running the following script: ${SOUNDBOX_HOME_DIR}/${GIT_REPO}/misc/scripts/run/process.sh"
            finished
            ;;
        *)
            bash "${SOUNDBOX_HOME_DIR}/${GIT_REPO}/misc/scripts/run/process.sh"
            finished
            ;;
    esac
}

finished() {
    echo "
#####################################################
# Installation processed finished
#####################################################"
}

create_config_file() {
    # CONFIG FILE
    # Create empty config file
    touch "${SOUNDBOX_HOME_DIR}/${CONFIG_FILE}"
    echo "# Overall config" > "${SOUNDBOX_HOME_DIR}/${CONFIG_FILE}"
    echo "-- Configuration file created."
}

loading_general_updates(){
    local apt_get="sudo apt-get -qq --yes"
    clear
    echo "------------- Process Variables ----------------"
    echo " GIT_BRANCH ${GIT_BRANCH}"
    echo " GIT_URL ${GIT_URL}"
    echo " User home dir: ${HOME_DIR}"
    echo "------------------------------------------------"
    echo ""
    echo "-- Updating & Upgrading system. Please be patient..."
    # -qq quite mode, active = yes
    ${apt_get} update
    ${apt_get} upgrade
    echo "-- Update completed."
    check_continue "Loading GIT Data"
}

loading_nodejs(){        
    local apt_get="sudo apt-get -qq --yes"
    local npm_install="sudo npm install -g"
    local allow_downgrades="--allow-downgrades --allow-remove-essential --allow-change-held-packages"
    if [[ ${CONTINUE} == "true" ]]; then
        clear
        echo "
______________________________    
                | |    (_)    
 _ __   ___   __| | ___ _ ___ 
| '_ \ / _ \ / _. |/ _ \ / __|
| | | | (_) | (_| |  __/ \__ \\
|_| |_|\___/ \__,_|\___| |___/
_______________________/_|____"
        # adjusting the node_modules auth
        # so package installation can be done in that folder 
        echo ""
        echo "-- Loading necessary packages..."
        # NVM and nodejs installation
        bash "${SOUNDBOX_HOME_DIR}/${GIT_REPO}/misc/scripts/install/node.sh"
        # npm specific adjustments
        echo "Installing additional packackes for npm..."
        cd ${SOUNDBOX_HOME_DIR}/${GIT_REPO}
        call_with_args_from_file "${SOUNDBOX_HOME_DIR}/${GIT_REPO}/packages-node.txt" ${apt_get} ${allow_downgrades} install
        # globally install express for the docker nodejs application
        # as well as pm2 to potentially run the server as background process
        echo "Loading additional packages like npm..."
        call_with_args_from_file "${SOUNDBOX_HOME_DIR}/${GIT_REPO}/packages-npm-node.txt" ${npm_install} install
        echo "Additional packages loaded..."
        check_continue "Preparing Docker container..."
    fi
}

processing_docker(){
    if [[ ${CONTINUE} == "true" ]]; then
        clear
        echo "
 ____             _             
|  _ \  ___   ___| | _____ _ __ 
| | | |/ _ \ / __| |/ / _ \ '__|
| |_| | (_) | (__|   <  __/ |   
|____/ \___/ \___|_|\_\___|_|"
        echo ""
        echo "-- Docker dependencies installation starting..."
        cd "${SOUNDBOX_HOME_DIR}/${GIT_REPO}/docker"
        npm install
        echo "-- Docker installation finished"
    fi
}

loading_git(){    
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
        mkdir "${SOUNDBOX_HOME_DIR}"
        create_config_file
        cd "${SOUNDBOX_HOME_DIR}"
        git clone ${GIT_URL} --branch "${GIT_BRANCH}"
        echo "-- Fetching git data completed"
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
    run_execute
}

start=$(date +%s)

main

end=$(date +%s)
runtime=$((end-start))
((h=${runtime}/3600))
((m=(${runtime}%3600)/60))
((s=${runtime}%60))
echo "Done (in ${h}h ${m}m ${s}s)."
