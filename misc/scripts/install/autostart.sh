#!/usr/bin/env bash
GIT_REPO=${GIT_REPO:-sound-box}

CURRENT_USER="${SUDO_USER:-$(whoami)}"
HOME_DIR=$(getent passwd "$CURRENT_USER" | cut -d: -f6)
SOUNDBOX_HOME_DIR="${HOME_DIR}/Sound-Box"

autostart(){
    sudo cp "${SOUNDBOX_HOME_DIR}"/"${GIT_REPO}"/misc/scripts/install/files/soundbox-autostart.service /etc/systemd/system/soundbox-autostart.service
    sudo cp "${SOUNDBOX_HOME_DIR}"/"${GIT_REPO}"/misc/scripts/install/files/soundbox-autostart.sh /usr/local/bin/soundbox-autostart.sh
    sudo chmod 744 /usr/local/bin/soundbox-autostart.sh
    sudo chmod 664 /etc/systemd/system/soundbox-autostart.service
    sudo systemctl daemon-reload
    sudo systemctl /etc/systemd/system/soundbox-autostart.service
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