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
    echo "${DATETIME}: Autostart SoundBox starting..." >> "${SOUNDBOX_HOME_DIR}/${GIT_REPO}/logger.txt"
    # initialize and clear status file
    : > "${SOUNDBOX_HOME_DIR}/${GIT_REPO}/docker/public/files/status.txt"
    echo "AUTOSTART:ON" >> "${SOUNDBOX_HOME_DIR}/${GIT_REPO}/docker/public/files/status.txt"
    bash "${SOUNDBOX_HOME_DIR}/${GIT_REPO}/misc/scripts/run/start.sh" >> "${SOUNDBOX_HOME_DIR}/${GIT_REPO}/logger.txt"
}


main