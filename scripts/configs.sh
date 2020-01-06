#!/usr/bin/env bash

# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -Eueo pipefail

# This script copies config files into the proper place for each application

# Set env variables for the script
CONFIGFILES=$HOME/Documents/Projects/dev-setup/config_files

cp -R $CONFIGFILES/.polar $HOME
cp $CONFIGFILES/bat.conf $HOME
cp $CONFIGFILES/ssh.config $HOME/.ssh/config
cp $CONFIGFILES/youtube-dl.config $HOME
