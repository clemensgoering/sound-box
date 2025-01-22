#!/usr/bin/env bash
#_____________________________________________________________
# _ __  _ __  _ __ ___                                       
#| '_ \| '_ \| '_ ` _ \                                      
#| | | | |_) | | | | | |                                     
#|_| |_| .__/|_|_|_| |_|    _                        _       
#   / \|_|__| |(_)_   _ ___| |_ _ __ ___   ___ _ __ | |_ ___ 
#  / _ \ / _` || | | | / __| __| '_ ` _ \ / _ \ '_ \| __/ __|
# / ___ \ (_| || | |_| \__ \ |_| | | | | |  __/ | | | |_\__ \
#/_/   \_\__,_|/ |\__,_|___/\__|_| |_| |_|\___|_| |_|\__|___/
#____________|__/_____________________________________________                                            

_escape_for_shell() {
	local escaped="${1//\"/\\\"}"
	escaped="${escaped//\`/\\\`}"
    escaped="${escaped//\$/\\\$}"
	echo "$escaped"
}

main(){
        mkdir ~/.npm-global
        npm config set prefix '~/.npm-global'
        source ~/.profile
        echo "export PATH=~/.npm-global/bin:\"$(_escape_for_shell "$PATH")\"" >> "$1/.profile"
        echo "-- Npm adjustments completed."
        
}

main