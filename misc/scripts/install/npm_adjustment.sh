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

main(){
        mkdir ~/.npm-global
        npm config set prefix '~/.npm-global'
        source ~/.profile
        # testing by installing a global package
        echo "Testing: Loading npm package for access checks..."
        npm install -g jshint
        echo "Testing completed."
        npm uninstall jshint
}

main