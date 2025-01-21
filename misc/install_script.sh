#!/usr/bin/env bash
# Installation of the sript can be started by calling
# cd; bash <(wget -qO- https://raw.githubusercontent.com/clemensgoering/sound-box/main/misc/install_script.sh)

GIT_BRANCH=${GIT_BRANCH:-main}
GIT_URL=${GIT_URL:-https://github.com/clemensgoering/sound-box.git}
DATETIME=$(date +"%Y%m%d_%H%M%S")


welcome() {
    clear
    echo "#####################################################
# You are turning your Raspberry Pi into a Soundbox. Continue with the installation.
# "
    read -rp "Continue interactive installation? [Y/n] " response
    case "$response" in
        [nN][oO]|[nN])
            exit
            ;;
        *)
            echo "Installation continues..."
            ;;
    esac
}

finished() {
    echo "
#
# INSTALLATION FINISHED
#
#####################################################

Let the sounds begin."
}


########
# Main #
########
main() {
    checkPrerequisite

    if [[ ${INTERACTIVE} == "true" ]]; then
        welcome
    else
        echo "Non-interactive installation!"
    fi
    finished
}

start=$(date +%s)

main

end=$(date +%s)
runtime=$((end-start))
((h=${runtime}/3600))
((m=(${runtime}%3600)/60))
((s=${runtime}%60))
echo "Done (in ${h}h ${m}m ${s}s)."

#####################################################
# notes for things to do

# CLEANUP
## remove dir BACKUP (possibly not, because we do this at the beginning after user confirms for latest config)
#####################################################