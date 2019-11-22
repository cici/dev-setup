#!/usr/bin/env bash

# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -Eueo pipefail

# This is the main script to setup a new laptop
# or add new configurations

# Set env variables for the script
DOTCONFIG=$HOME/.config
DOTFILES=$HOME/.dotfiles

# Include the log helpers and banner
source ./log_utils.sh

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
    ./osxprep.sh
}

configureOS() {
    log_info "Configuring OSX with preferred system defaults"
    ./osx.sh
}

# Main Program
print_main_banner

if [ $# -eq 0 ]; then
    usage
else
    for i in "$@"
    do
        case $i in
            -pr--prep)
                prepOS
                shift
                ;;
            -s|--sync)
                doSync
                doGitConfig
                shift
                ;;
            -l|--link)
                doSymLink
                shift
                ;;
            -i|--install)
                doInstall
                shift
                ;;
            -f|--fonts)
                installFonts
                shift
                ;;
            -c|--config)
                configureOS
                shift
                ;;
            -a|--all)
                installAll
                shift
                ;;
            *)
                usage
                shift
                ;;
        esac
    done
fi
