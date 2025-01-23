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
GIT_REPO=${GIT_REPO:-sound-box}
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
    # create profile file
    touch ~/.bashrc
    # copy content from installations raw to actual profile document
    sudo cp "${SOUNDBOX_HOME_DIR}"/"${GIT_REPO}"/misc/scripts/install/files/.bashrc ~/.bashrc
    # fetch and execute installation script
    wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
    # source to overcome reload of the terminal
    source ~/.bashrc
    nvm install node --reinstall-packages-from=node
}

install(){
    echo "-- Starting installation of nvm..."
    nvm install node latest
    node --version
    echo "-- nvm adjustments completed."
}

main(){
    fetch
    install      
}

main