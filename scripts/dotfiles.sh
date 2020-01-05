#!/usr/bin/env bash

# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -Eueo pipefail

# This script copies config files into the proper place for each application

# Set env variables for the script
DOTFILES=$HOME/Documents/Projects/dev-setup/dotfiles

cp