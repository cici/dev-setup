#!/usr/bin/env bash

# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -Eueo pipefail

sudo -v

# This is the script to put config files for software packages in place

cp ../config_files/vscode_settings.json $HOME/Library/Application Support/Code/User/settings.json

cp ../config_files/youtube-dl.conf $HOME/.config/youtube-dl/config

cp ../config_files/bat.conf $HOME/.config/bat/config
