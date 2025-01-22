#!/usr/bin/env bash
#_____________________________________________________________
# _ __  _ __  _ __ ___                                       
#| '_ \| '_ \| '_ ` _ \                                      
#| | | | |_) | | | | | |                                     
#|_| |_| .__/|_|_|_| |_|    _                        _       
#   / \|_|__| |(_)_   _ ___| |_ _ __ ___   ___ _ __ | |_ ___ 
#  / _ \ / _` || | | | / __| __| '_ ` _ \ / _ \ '_ \| __/ __|
# / ___ \ (_| || | |_| \__ \ |_| | | | | |  __/ | | | |_\__ \
#/_/   \_\__,_|/ |\__,_|___/\__|_| |_| |_|\___|_| |_|\__|___/
#____________|__/_____________________________________________                                            

CURRENT_USER="${SUDO_USER:-$(whoami)}"
HOME_DIR=$(getent passwd "$CURRENT_USER" | cut -d: -f6)
SOUNDBOX_HOME_DIR="${HOME_DIR}/Sound-Box"

_escape_for_shell() {
	local escaped="${1//\"/\\\"}"
	escaped="${escaped//\`/\\\`}"
    escaped="${escaped//\$/\\\$}"
	echo "$escaped"
}

fetch(){
    # fetch and start nvm installation / nodejs version manager
    echo "-- nvm installation starting..."
    wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
}

adjustments(){
        echo "Starting npm adjustments..."
        # copy data to profile file, to get it properly loaded
        sudo cp "${SOUNDBOX_HOME_DIR}"/"${GIT_REPO}"/misc/scripts/install/replace/.profile.original ~/.bash_profile
        echo "-- Npm adjustments completed."
}

install(){
    echo "-- Starting installation of ."
    nvm install --lts
    node --version
    echo "-- Npm adjustments completed."
}

main(){
    fetch
    adjustments  
    install      
}

main