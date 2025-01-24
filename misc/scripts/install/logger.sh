#!/usr/bin/env bash
DATETIME=$(date +"%Y%m%d_%H%M%S")
source var.sh
if [ -e ../../logger.txt ]
then
    echo -e "$1\n" >> "${SOUNDBOX_HOME_DIR}/logger.txt"
else
    echo "Logger: Process could not be logged. Logger File missing
fi