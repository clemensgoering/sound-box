#!/usr/bin/env bash
GIT_REPO=${GIT_REPO:-sound-box}

CURRENT_USER="${SUDO_USER:-$(whoami)}"
HOME_DIR=$(getent passwd "$CURRENT_USER" | cut -d: -f6)
SOUNDBOX_HOME_DIR="${HOME_DIR}"

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

fetch(){
    # fetch and start nvm installation / nodejs version manager
    echo "-- nvm installation starting..."
    # create profile file
    touch ~/.bashrc
    # copy content from installations raw to actual profile document
    # contains common bashrc content including the necessary export for nvm
    sudo cp "${SOUNDBOX_HOME_DIR}"/"${GIT_REPO}"/misc/scripts/install/files/.bashrc.sample ~/.bashrc
    # fetch and execute installation script
    wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
    # source to overcome reload of the terminal
    source ~/.bashrc
    #-
    # nvm not installed
    # nvm install node --reinstall-packages-from=node
}

packages(){
    
    local apt_get="sudo apt-get -qq --yes"
    local npm_install="sudo npm install -g"
    local allow_downgrades="--allow-downgrades --allow-remove-essential --allow-change-held-packages"

    echo "Installing additional packackes for npm..."
    cd ${SOUNDBOX_HOME_DIR}/${GIT_REPO}
    call_with_args_from_file "${SOUNDBOX_HOME_DIR}/${GIT_REPO}/misc/packages/packages-node.txt" ${apt_get} ${allow_downgrades} install
    # globally install express for the docker nodejs application
    echo "Loading additional packages like npm..."
    # npm, postgre, sequelize
    call_with_args_from_file "${SOUNDBOX_HOME_DIR}/${GIT_REPO}/misc/packages/packages-npm-node.txt" ${npm_install} install
    echo "Additional packages loaded..."
}

main(){
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
    fetch   
    packages
}

main