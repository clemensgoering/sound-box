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
    source ../install/var.sh
    cd "${SOUNDBOX_HOME_DIR}/${GIT_REPO}/docker"
    pm2 init
    # executing script command to start the 
    # application in a docker container via pm2
    npm run pm2_exec 
    # start postgresql database
    docker run -it -e "POSTGRES_HOST_AUTH_METHOD=trust" -p 5432:5432 postgres
    # migrate, script from packages file
    npm run migrate
}


main