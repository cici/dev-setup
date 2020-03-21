#!/usr/bin/env bash

# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -Eueo pipefail

sudo -v

mkdir -p $HOME/.config
mkdir -p $HOME/.config/youtube-dl
mkdir -p $HOME/.config/bat

# This is the script to put config files for software packages in place

cp ../config_files/vscode_settings.json $HOME/Library/Application\ Support/Code\ -\ Insiders/User/settings.json

cp ../config_files/youtube-dl.conf $HOME/.config/youtube-dl/config

cp ../config_files/bat.conf $HOME/.config/bat/config

cp -r $SETUP_DIR/init/Preferences.sublime-settings ~/Library/Application\ Support/Sublime\ Text*/Packages/User/Preferences.sublime-settings 
