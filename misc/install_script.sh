#!/usr/bin/env bash
# Installation of the sript can be started by calling
# cd; bash <(wget -qO- https://raw.githubusercontent.com/clemensgoering/sound-box/main/misc/install_script.sh)

GIT_BRANCH=${GIT_BRANCH:-main}
GIT_URL=${GIT_URL:-https://github.com/clemensgoering/sound-box.git}
DATETIME=$(date +"%Y%m%d_%H%M%S")

CURRENT_USER="${SUDO_USER:-$(whoami)}"
HOME_DIR=$(getent passwd "$CURRENT_USER" | cut -d: -f6)

SOUNDBOX_HOME_DIR="${HOME_DIR}/Sound-Box"

# local function as it is needed before the repo is checked out!
_escape_for_shell() {
	local escaped="${1//\"/\\\"}"
	escaped="${escaped//\`/\\\`}"
    escaped="${escaped//\$/\\\$}"
	echo "$escaped"
}


welcome() {
    clear
    echo "#####################################################
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
    echo "#####################################################
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

loading_nodejs(){
    echo "-- Loading NodeJS related packages..."
    # Spotify and node server dependencies / packages
    call_with_args_from_file /packages-node.txt ${apt_get} ${allow_downgrades} install
}


install(){
    local apt_get="sudo apt-get -qq --yes"
    local allow_downgrades="--allow-downgrades --allow-remove-essential --allow-change-held-packages"
    local pip_install="sudo python3 -m pip install --upgrade --force-reinstall -q"
    local pip_uninstall="sudo python3 -m pip uninstall -y -q"
    
    #clear console
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
    # Get github code. git must be installed before, even if defined in packages.txt!
    ${apt_get} install git
    
    echo "-- Create folder and load git"
    mkdir "${SOUNDBOX_HOME_DIR}"
    create_config_file
    cd "${SOUNDBOX_HOME_DIR}"
    git clone ${GIT_URL} --branch "${GIT_BRANCH}"
    
    echo "-- Fetching data completed"

    ################################
    # NodeJS , Docker
    ################################
    loading_nodejs
    cd "sound-box/docker"
    npm install
    echo "-- NodeJS and Docker installation finished"
}


########
# Main #
########
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

#####################################################
# notes for things to do

# CLEANUP
## remove dir BACKUP (possibly not, because we do this at the beginning after user confirms for latest config)
#####################################################