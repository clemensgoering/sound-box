#!/usr/bin/env bash


GIT_REPO=${GIT_REPO:-sound-box}

CURRENT_USER="${SUDO_USER:-$(whoami)}"
HOME_DIR=$(getent passwd "$CURRENT_USER" | cut -d: -f6)
SOUNDBOX_HOME_DIR="${HOME_DIR}"

main(){
    echo "Installing Python requirements for RC522...\n"
    sudo python3 -m pip install --upgrade --force-reinstall --no-deps -q -r "${SOUNDBOX_HOME_DIR}"/misc/packages/packages-rfid.txt

    echo "Activating SPI...\n"
    sudo raspi-config nonint do_spi 0

    echo "Configure RFID reader in Phoniebox...\n"
    sudo cp "${SOUNDBOX_HOME_DIR}"/"${GIT_REPO}"/misc/scripts/install/files/rfid/soundbox-rfid.service "${systemd_dir}"/soundbox-rfid.service
    sudo cp "${SOUNDBOX_HOME_DIR}"/"${GIT_REPO}"/misc/scripts/install/files/rfid/soundbox-rfid.sh /usr/local/bin/soundbox-rfid.sh

    echo "Auth changes required..."
    sudo chmod 744 /usr/local/bin/soundbox-rfid.sh
    sudo chmod 664 "${systemd_dir}"/soundbox-rfid.service
    sudo chown root:root /usr/local/bin/soundbox-rfid.sh

    echo "Restarting rfid-reader service...\n"
    sudo systemctl restart soundbox-rfid.service

    echo "Done.\n"
}

main
