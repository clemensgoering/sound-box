#!/usr/bin/env bash


GIT_REPO=${GIT_REPO:-sound-box}

CURRENT_USER="${SUDO_USER:-$(whoami)}"
HOME_DIR=$(getent passwd "$CURRENT_USER" | cut -d: -f6)
SOUNDBOX_HOME_DIR="${HOME_DIR}"

main(){
    echo "Installing Python requirements for RC522...\n"
    sudo apt-get install git python-dev --yes
    git clone https://github.com/lthiery/SPI-Py.git
    cd SPI-Py
    sudo python setup.py install
    cd
    git clone https://github.com/mxgxw/MFRC522-python.git && cd MFRC522-python

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
