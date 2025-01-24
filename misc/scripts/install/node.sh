#!/usr/bin/env bash
source var.sh

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

packages(){
    
    local apt_get="sudo apt-get -qq --yes"
    local npm_install="sudo npm install -g"
    local allow_downgrades="--allow-downgrades --allow-remove-essential --allow-change-held-packages"

    echo "Inst
    alling additional packackes for npm..."
    cd ${SOUNDBOX_HOME_DIR}/${GIT_REPO}
    call_with_args_from_file "${SOUNDBOX_HOME_DIR}/${GIT_REPO}/misc/packages/packages-node.txt" ${apt_get} ${allow_downgrades} install
    # globally install express for the docker nodejs application
    # as well as pm2 to potentially run the server as background process
    echo "Loading additional packages like npm..."
    # npm, postgre, sequelize and others like pm2
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
    install      
    packages
}

main