#!/usr/bin/env bash
GIT_BRANCH=${GIT_BRANCH:-main}
GIT_URL=${GIT_URL:-https://github.com/clemensgoering/sound-box.git}

CURRENT_USER="${SUDO_USER:-$(whoami)}"
HOME_DIR=$(getent passwd "$CURRENT_USER" | cut -d: -f6)
SOUNDBOX_HOME_DIR="${HOME_DIR}"

git(){
    local apt_get="sudo apt-get -qq --yes"

    clear
    echo "
       _ _     ___           _        _ _ 
  __ _(_) |_  |_ _|_ __  ___| |_ __ _| | |
 / _. | | __|  | || '_ \/ __| __/ _. | | |
| (_| | | |_   | || | | \__ \ || (_| | | |
 \__, |_|\__| |___|_| |_|___/\__\__,_|_|_|
 |___/"
# Get github code. git must be installed before, even if defined in packages.txt!
    echo ""
    echo "-- Checking and preparing git init..."
    ${apt_get} install git
    echo "-- Create folder and config file"
    cd "${SOUNDBOX_HOME_DIR}"
    git clone ${GIT_URL} --branch "${GIT_BRANCH}"
    echo "-- Fetching git data completed"
}

git