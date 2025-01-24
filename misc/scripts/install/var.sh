#!/usr/bin/env bash 
export GIT_REPO=${GIT_REPO:-sound-box}
export GIT_BRANCH=${GIT_BRANCH:-main}
export GIT_URL=${GIT_URL:-https://github.com/clemensgoering/sound-box.git}

export CURRENT_USER="${SUDO_USER:-$(whoami)}"
export HOME_DIR=$(getent passwd "$CURRENT_USER" | cut -d: -f6)
export SOUNDBOX_HOME_DIR="${HOME_DIR}/Sound-Box"