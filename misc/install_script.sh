#!/usr/bin/env bash
# The absolute path to the folder which contains this script
PATHDATA="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
GIT_BRANCH=${GIT_BRANCH:-main}
GIT_URL=${GIT_URL:-https://github.com/clemensgoering/sound-box.git}

DATETIME=$(date +"%Y%m%d_%H%M%S")

SCRIPTNAME="$(basename $0)"
JOB="${SCRIPTNAME}"

CURRENT_USER="${SUDO_USER:-$(whoami)}"
HOME_DIR=$(getent passwd "$CURRENT_USER" | cut -d: -f6)


SOUNDBOX_HOME_DIR="${HOME_DIR}/SoundBox"
LOGDIR="${HOME_DIR}"/soundbox_logs
SOUNDBOX_BACKUP_DIR="${HOME_DIR}/BACKUP"

# Get the Raspberry Pi OS codename (e.g. buster, bullseye, ...)
OS_CODENAME="$( . /etc/os-release; printf '%s\n' "$VERSION_CODENAME"; )"
# Get the Raspberry Pi OS version id (e.g. 11, 12, ...)
OS_VERSION_ID="$( . /etc/os-release; printf '%s\n' "$VERSION_ID"; )"


WIFI_INTERFACE="wlan0"

INTERACTIVE=true

usage() {
    printf "Usage: ${SCRIPTNAME} [-a] [-h]\n"
    printf " -a\tautomatic/non-interactive mode\n"
    printf " -h\thelp\n"
    exit 0
}

while getopts ":ah" opt;
do
  case ${opt} in
    a ) INTERACTIVE=false
      ;;
    h ) usage
      ;;
    \? ) usage
      ;;
  esac
done


checkPrerequisite() {
    if [ ! -d "${HOME_DIR}" ]; then
        echo
        echo "Warning: HomeDir ${HOME_DIR} does not exist."
        echo "         Please create it and start again."
        exit 2
    fi
}

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

Let the sounds begin.
Find more information and documentation on the github account:
https://github.com/MiczFlor/RPi-Jukebox-RFID/wiki/

"
}

cleanup_and_reboot() {

    echo ""
    echo "-----------------------------------------------------"
    echo "A reboot is required to activate all settings!"
    local do_shutdown=false
    if [[ ${INTERACTIVE} == "true" ]]; then
        # Use -e to display response of user in the logfile
        read -e -r -p "Would you like to reboot now? [Y/n] " response
        case "$response" in
            [nN][oO]|[nN])
                ;;
            *)
                do_shutdown=true
                ;;
        esac
    fi

    # Close logging
    log_close
    if [[ ${do_shutdown} == "true" ]]; then
        sudo shutdown -r now
    fi
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