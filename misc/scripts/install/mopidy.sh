#!/usr/bin/env bash
GIT_REPO=${GIT_REPO:-sound-box}
CURRENT_USER="${SUDO_USER:-$(whoami)}"
HOME_DIR=$(getent passwd "$CURRENT_USER" | cut -d: -f6)
SOUNDBOX_HOME_DIR="${HOME_DIR}"

# local function as it is needed before the repo is checked out!
_escape_for_shell() {
	local escaped="${1//\"/\\\"}"
	escaped="${escaped//\`/\\\`}"
    escaped="${escaped//\$/\\\$}"
	echo "$escaped"
}

main(){
        clear
        echo "
                      .__    .___      
  _____   ____ ______ |__| __| _/__.__.
 /     \ /  _ \\____ \|  |/ __ <   |  |
|  Y Y  (  <_> )  |_> >  / /_/ |\___  |
|__|_|  /\____/|   __/|__\____ |/ ____|
      \/       |__|           \/\/ "
        echo ""
        # Add Docker's official GPG key:
        # ca-certificates and curl already loaded via package-node.txt
        echo "Loading Mopidy..."
        wget -q -O – https://apt.mopidy.com/mopidy.gpg | sudo apt-key add –
        sudo wget -q -O /etc/apt/sources.list.d/mopidy.list https://apt.mopidy.com/jessie.list
        sudo apt-get install mopidy

        echo "Create Mopidy File..."
        if [ ! -f ${SOUNDBOX_HOME_DIR}/${GIT_REPO}/docker/public/files/mopidy.txt ]; then
            # create logger file
            touch "${SOUNDBOX_HOME_DIR}"/"${GIT_REPO}"/docker/public/files/mopidy.txt
        fi    

        chmod 744 "${SOUNDBOX_HOME_DIR}/${GIT_REPO}/docker/public/files/mopidy.txt"
        echo "#####################################################"

        read -rp "Type your client_id: " clientID
        read -rp "Type your client_secret: " clientSECRET

        {
            echo "SPOTIclientid=\"$(_escape_for_shell "$clientID")\"";
            echo "SPOTIclientsecret=\"$(_escape_for_shell "$clientSECRET")\""
        } >> "${SOUNDBOX_HOME_DIR}/${GIT_REPO}/docker/public/files/mopidy.txt"

        echo "Configuring Spotify support..."
        local mopidy_conf="/etc/mopidy/mopidy.conf"
        # Install Config Files
        sudo cp "${SOUNDBOX_HOME_DIR}/${GIT_REPO}/misc/scripts/install/files/mopidy.conf.sample" "${mopidy_conf}"
        # Change vars to match install config
        sudo sed -i 's|%spotify_client_id%|'"$(escape_for_sed "$clientID")"'|' "${mopidy_conf}"
        sudo sed -i 's|%spotify_client_secret%|'"$(escape_for_sed "$clientSECRET")"'|' "${mopidy_conf}"

        echo "-- Mopidy installation finished"
}

main