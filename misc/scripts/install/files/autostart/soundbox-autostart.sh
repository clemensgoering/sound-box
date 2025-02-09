#!/usr/bin/env bash
#####################################################
#   _________                        .______.                 
#  /   _____/ ____  __ __  ____    __| _/\_ |__   _______  ___
#  \_____  \ /  _ \|  |  \/    \  / __ |  | __ \ /  _ \  \/  /
#  /        (  <_> )  |  /   |  \/ /_/ |  | \_\ (  <_> >    < 
# /_______  /\____/|____/|___|  /\____ |  |___  /\____/__/\_ \
#         \/                  \/      \/      \/            \/
# Autostart Script
#####################################################"

GIT_REPO=${GIT_REPO:-sound-box}
CURRENT_USER="${SUDO_USER:-$(whoami)}"
HOME_DIR=$(getent passwd "$CURRENT_USER" | cut -d: -f6)
SOUNDBOX_HOME_DIR="${HOME_DIR}"
DATETIME=$(date +"%Y%m%d_%H%M%S")

################################
# 
# Main
#  
################################
main() {
    if [ ! -f ${SOUNDBOX_HOME_DIR}/${GIT_REPO}/logger.txt ]; then
        # create logger file
        touch ${SOUNDBOX_HOME_DIR}/${GIT_REPO}/logger.txt
    fi
    echo "${DATETIME}: Autostart SoundBox starting..." >> "${SOUNDBOX_HOME_DIR}/${GIT_REPO}/logger.txt"
    bash "${SOUNDBOX_HOME_DIR}/${GIT_REPO}/misc/scripts/run/start.sh" >> "${SOUNDBOX_HOME_DIR}/${GIT_REPO}/logger.txt"
}


main