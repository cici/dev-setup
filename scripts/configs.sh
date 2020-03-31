#!/usr/bin/env bash

# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -Eueo pipefail

# This script copies config files into the proper place for each application

# Set env variables for the script
CONFIGFILES=$HOME/Documents/Projects/dev-setup/config_files

cp -R $CONFIGFILES/.polar $HOME
mkdir -p $HOME/.vim/colors
cp $CONFIGFILES/solarized.vim $HOME/.vim/colors
cp $CONFIGFILES/bat.conf $HOME
cp $CONFIGFILES/ssh.config $HOME/.ssh/config
cp $CONFIGFILES/youtube-dl.config $HOME

# Install the crontab file
crontab $CONFIGFILES/crontab.txt > /dev/null 2>&1

# Favorite servers
# AFP from thomsontown
cp ~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.FavoriteServers.sfl

# Update .zshrc
echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.zshrc
