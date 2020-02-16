#!/usr/bin/env bash

# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -Eueo pipefail

# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
source ./log_utils.sh

########## Variables
DOTFILES_DIR="../dotfiles"                  # dotfiles directory
DOTFILES_BACKUP="$HOME/dotfiles_backup"  # dotfiles backup directory
##########

# Backup any existing dotfiles, then create symlinks from the homedir to any dotfiles in the ./dotfiles directory
mkdir -p $DOTFILES_BACKUP
pushd $DOTFILES_DIR
for file in .*; do
    if [[ $file == "." || $file == ".." ]]; then
      continue
    fi
    # if it is a directory then copy recursively
    if [[ -d $file ]]; then
	cp -R ~/$file/ $DOTFILES_BACKUP/$file
    # if the file exists:
    elif [[ -f ~/$file ]]; then
        cp ~/$file $DOTFILES_BACKUP/$file
        echo "backup saved as ~/.dotfiles_backup/$file"
    fi
    log_info "Creating symlink to $file in home directory."
    dst=~/$file
    ln -sf $file $dst
done
popd
