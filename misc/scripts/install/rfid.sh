#!/usr/bin/env bash
GIT_REPO=${GIT_REPO:-sound-box}
CURRENT_USER="${SUDO_USER:-$(whoami)}"
HOME_DIR=$(getent passwd "$CURRENT_USER" | cut -d: -f6)
SOUNDBOX_HOME_DIR="${HOME_DIR}"

rfid(){

    local systemd_dir="/etc/systemd/system"

    echo "Disable old RFID Service Instances..."
    sudo systemctl disable soundbox-rfid
    # remove potentially existing services from previous installations
    sudo rm "${systemd_dir}"/soundbox-rfid.service
    sudo rm /usr/local/bin/soundbox-rfid.sh

    echo "Installing Python requirements for RC522..."
    sudo apt install python3-pip
    sudo python3 -m pip install --upgrade --force-reinstall --no-deps -q -r "${SOUNDBOX_HOME_DIR}"/"${GIT_REPO}"/misc/packages/packages-rfid.txt

    cd "${SOUNDBOX_HOME_DIR}"/"${GIT_REPO}"
    git clone https://github.com/lthiery/SPI-Py.git
    git checkout 8cce26b9ee6e69eb041e9d5665944b88688fca68

    cd SPI-Py
    sudo python3 setup.py install
    cd

    echo "Activating SPI..."
    # 0 = enabled, 1 = disabled
    sudo raspi-config nonint do_spi 0

    echo "Copy RFID reader..."
    sudo cp "${SOUNDBOX_HOME_DIR}"/"${GIT_REPO}"/misc/scripts/install/files/rfid/soundbox-rfid.service "${systemd_dir}"/soundbox-rfid.service
    sudo cp "${SOUNDBOX_HOME_DIR}"/"${GIT_REPO}"/misc/scripts/install/files/rfid/soundbox-rfid.sh /usr/local/bin/soundbox-rfid.sh

    echo "Auth changes required..."
    sudo chmod 744 /usr/local/bin/soundbox-rfid.sh
    sudo chmod 664 "${systemd_dir}"/soundbox-rfid.service
    sudo chown root:root /usr/local/bin/soundbox-rfid.sh

    sudo chown pi:www-data "${SOUNDBOX_HOME_DIR}"/"${GIT_REPO}"/misc/scripts/run/*.sh
    sudo chmod +x "${SOUNDBOX_HOME_DIR}"/"${GIT_REPO}"/misc/scripts/run/*.sh

    echo "Restarting rfid-reader service..."
    sudo systemctl daemon-reload
    sudo systemctl enable soundbox-rfid.service

    echo "Create RFID File..."
    if [ ! -f ${SOUNDBOX_HOME_DIR}/${GIT_REPO}/docker/public/files/rfid_logger.txt ]; then
        # create logger file
        touch "${SOUNDBOX_HOME_DIR}"/"${GIT_REPO}"/docker/public/files/rfid_logger.txt
    fi
    
    sudo chmod 744 "${SOUNDBOX_HOME_DIR}"/"${GIT_REPO}"/docker/public/files/rfid_logger.txt
    echo "Done."
}

rfid
