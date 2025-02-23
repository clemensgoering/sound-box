#!/usr/bin/env bash
GIT_REPO=${GIT_REPO:-sound-box}

CURRENT_USER="${SUDO_USER:-$(whoami)}"
HOME_DIR=$(getent passwd "$CURRENT_USER" | cut -d: -f6)
SOUNDBOX_HOME_DIR="${HOME_DIR}"

main(){
        clear
        echo "
 ____             _             
|  _ \  ___   ___| | _____ _ __ 
| | | |/ _ \ / __| |/ / _ \ '__|
| |_| | (_) | (__|   <  __/ |   
|____/ \___/ \___|_|\_\___|_|"
        echo ""
        # Add Docker's official GPG key:
        # ca-certificates and curl already loaded via package-node.txt
        echo "Loading Docker..."
        sudo install -m 0755 -d /etc/apt/keyrings
        sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
        sudo chmod a+r /etc/apt/keyrings/docker.asc

        # Add the repository to Apt sources:
        echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt-get update
        # installing the latest verion..
        echo "Installing latest version ..."
        sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose
        echo ""
        echo "-- Installing dependencies from Nodejs application at docker folder ..."
        cd "${SOUNDBOX_HOME_DIR}/${GIT_REPO}/docker"
        npm install
        # No postgres setup required
        # npm migrate for database and table generation
        # is part of the dockerfile and comands
        echo "-- Docker installation finished"
}

main