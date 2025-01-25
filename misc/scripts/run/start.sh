#!/usr/bin/env bash
# Execution script which is meant to be executed after the installation
# has been completed.
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
GIT_REPO=${GIT_REPO:-sound-box}

CURRENT_USER="${SUDO_USER:-$(whoami)}"
HOME_DIR=$(getent passwd "$CURRENT_USER" | cut -d: -f6)
SOUNDBOX_HOME_DIR="${HOME_DIR}"
TIMESTAMP=$(date +%s)

################################
# 
# Main
#  
################################
main() {
    echo "${TIMESTAMP}: Autostart: SoundBox initialized..." >> "${SOUNDBOX_HOME_DIR}/${GIT_REPO}/logger.txt"
    # postgre
    cd "${SOUNDBOX_HOME_DIR}/${GIT_REPO}/docker"
    # executing script command to start the 
    # start postgresql database
    echo "Build container..."
    # Option 1. using dockerfile 
    # docker build -t soundbox
    echo "Adjusting access level..."
    sudo chmod 666 /var/run/docker.sock
    echo "Run the container..."
    # docker-compose will use the docker-compose.yml to 
    # build the service
    docker-compose up -d --build
    # migrate, script from packages file
    # - docker run -it -e "POSTGRES_HOST_AUTH_METHOD=trust" -p 5432:5432 postgres > /dev/null 2>&1
    # migrate would need to be executed in another
    # - npm run migrate
    echo "${TIMESTAMP}: Autostart: SoundBox completed..." >> "${SOUNDBOX_HOME_DIR}/${GIT_REPO}/logger.txt"
}


main