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
    echo "System needs to be restarted to enable all services."
    echo "Soundbox has been added to the boot process and will automatically started on reboot."
    read -rp "Ready to restart your device [Y/n] " response
    case "$response" in
        [nN][oO]|[nN])
            sudo reboot
            ;;
        *)
            sudo reboot
            ;;
    esac
}

autostart