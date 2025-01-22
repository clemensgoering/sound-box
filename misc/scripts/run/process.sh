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

################################
# 
# Main
#  
################################
main() {
    cd "${SOUNDBOX_HOME_DIR}/${GIT_REPO}/docker"
    pm2 start npm -- starten
}


main