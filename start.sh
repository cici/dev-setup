#!/usr/bin/env bash

# Color Variables
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' 

# Get the administrator password
sudo -v

# ###########################################################
# Installing Xcode command line tools
# ###########################################################
echo "Ensuring build/install tools are available"
if ! xcode-select --print-path &> /dev/null; then

    # Prompt user to install the XCode Command Line Tools
    xcode-select --install &> /dev/null

    # Wait until the XCode Command Line Tools are installed
    until xcode-select --print-path &> /dev/null; do
        sleep 5
    done

    # Prompt user to agree to the terms of the Xcode license
    # https://github.com/alrra/dotfiles/issues/10
    sudo xcodebuild -license

    echo "XCode Command Line Tools Installed"
fi
