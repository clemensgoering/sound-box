#!/usr/bin/env bash
# Remarks:
# To check which services are enabled and running after reboot:
# sudo systemctl --all list-unit-files --type=service

GIT_REPO=${GIT_REPO:-sound-box}
CURRENT_USER="${SUDO_USER:-$(whoami)}"
HOME_DIR=$(getent passwd "$CURRENT_USER" | cut -d: -f6)
SOUNDBOX_HOME_DIR="${HOME_DIR}"

autostart(){
    local systemd_dir="/etc/systemd/system"

    # remove and disable old services
    echo "Remove and disable old services..."
    sudo systemctl disable soundbox-autostart
    # remove potentially existing services from previous installations
    sudo rm "${systemd_dir}"/soundbox-autostart.service
    sudo rm /usr/local/bin/soundbox-autostart.sh

    echo "Copy scripts to system location..."
    sudo cp "${SOUNDBOX_HOME_DIR}"/"${GIT_REPO}"/misc/scripts/install/files/autostart/soundbox-autostart.service "${systemd_dir}"/soundbox-autostart.service
    sudo cp "${SOUNDBOX_HOME_DIR}"/"${GIT_REPO}"/misc/scripts/install/files/autostart/soundbox-autostart.sh /usr/local/bin/soundbox-autostart.sh

    echo "Auth changes required..."
    sudo chmod 744 /usr/local/bin/soundbox-autostart.sh
    sudo chmod 644 "${systemd_dir}"/soundbox-autostart.service
    sudo chown root:root /usr/local/bin/soundbox-autostart.sh


    sudo chown pi:www-data "${SOUNDBOX_HOME_DIR}"/"${GIT_REPO}"/misc/scripts/run/*.sh
    sudo chmod +x "${SOUNDBOX_HOME_DIR}"/"${GIT_REPO}"/misc/scripts/run/*.sh

    # enable the services needed
    echo "Enable services ..."
    sudo systemctl daemon-reload
    sudo systemctl enable soundbox-autostart.service

    echo ""
    echo "Main application installed..."
    # executing start script to prevent delay on
    # reboot which requires to install postgre and other dependencies installations
    echo "System needs to be restarted and will automatically start the services and application."
    read -rp "Do you want to restart now? [Y/n] " response
    case "$response" in
        [nN][oO]|[nN])
            echo "Installation finished."
            ;;
        *)
            sudo reboot
            ;;
    esac
}

autostart