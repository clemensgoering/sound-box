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
    echo "${DATETIME}: RFID SoundBox starting..." >> "${SOUNDBOX_HOME_DIR}/${GIT_REPO}/logger.txt"
    echo "RFID:ON" >> "${SOUNDBOX_HOME_DIR}/${GIT_REPO}/docker/public/files/status.txt"
    sudo python "${SOUNDBOX_HOME_DIR}"/"${GIT_REPO}"/misc/scripts/install/files/rfid/Read.py >> "${SOUNDBOX_HOME_DIR}/${GIT_REPO}/logger.txt"
} 


main