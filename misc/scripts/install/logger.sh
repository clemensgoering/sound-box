#!/usr/bin/env bash
DATETIME=$(date +"%Y%m%d_%H%M%S")

CURRENT_USER="${SUDO_USER:-$(whoami)}"
HOME_DIR=$(getent passwd "$CURRENT_USER" | cut -d: -f6)
SOUNDBOX_HOME_DIR="${HOME_DIR}/Sound-Box"

if [ -e ../../logger.txt ]
then
    echo -e "$1\n" >> "${SOUNDBOX_HOME_DIR}/logger.txt"
else
    echo "Logger: Process could not be logged. Logger File missing"
fi