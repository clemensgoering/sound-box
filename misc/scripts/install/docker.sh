#!/usr/bin/env bash

main(){
        source var.sh
        clear
        echo "
 ____             _             
|  _ \  ___   ___| | _____ _ __ 
| | | |/ _ \ / __| |/ / _ \ '__|
| |_| | (_) | (__|   <  __/ |   
|____/ \___/ \___|_|\_\___|_|"
        echo ""
        echo "-- Docker dependencies installation starting..."
        cd "${SOUNDBOX_HOME_DIR}/${GIT_REPO}/docker"
        npm install
        echo "-- Docker installation finished"
}

main