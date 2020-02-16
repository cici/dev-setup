#!/usr/bin/env bash

# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -Eueo pipefail

# This is the main script to setup a new laptop
# or add new configurations

# Set env variables for the script
DOTCONFIG=$HOME/.config
DOTFILES=$HOME/.dotfiles
SCRIPTFILES=$HOME/Documents/Projects/dev-setup/scripts

# Include the log helpers and banner
source ./log_utils.sh

downloadInstallScript() {
    log_info "Getting code from Github"
    curl --remote-name https://raw.githubusercontent.com/cici/dev-setup/master/install.sh && sh install.sh 2>&1 | tee ~/bootstrap.log
}

installFonts() {
    log_info "Installing Fonts"

    # Assume standard OSX fonts directory
    fonts=~/Library/Fonts

    # Copy fonts into place
    find "$DOTFILES/fonts/" -name "*.[o,t]tf" -type f | while read -r file
    do
        cp -v "$file" "$fonts"
    done
}

prepOS() {
    log_info "Updating OSX and installing Xcode command line tools"
    $SCRIPTFILES/osxprep.sh
}

configureOS() {
    log_info "Configuring OSX with preferred system defaults"
    $SCRIPTFILES/osx.sh
}

installSoftware() {
    log_info "Installing software and utilities"
    $SCRIPTFILES/brew.sh
}

doSymLink() {
    log_info "Creating sym links for dotfiles"
    $SCRIPTFILES/makesymlinks.sh
}

configureSoftware() {
    log_info "Installing config files"
    $SCRIPTFILES/installConfigs.sh
}

# Main Program
print_main_banner

if [ $# -eq 0 ]; then
    usage
else
    for i in "$@"
    do
        case $i in
            -p | --prep)
                prepOS
                shift
                ;;
            -s | --sync)
                doGitConfig
                shift
                ;;
            -l | --link)
                doSymLink
                shift
                ;;
            -d | --download)
                downloadInstallScript
                shift
                ;;
            -i | --install)
                installSoftware
                shift
                ;;
            -c | --config)
               configureSoftware
                shift
                ;;
            -a | --all)
                installAll
                shift
                ;;
            -h | --help)
                usage
                exit
                ;;
            *)
                usage
                exit 1
                ;;
        esac
    done
fi
