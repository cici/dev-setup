#!/usr/bin/env bash

echo "This is a script to test the issues\n"

dotfiles_dir="../dotfiles"

source ./log_utils.sh
source ./echos.sh

log_info "From log info"


pushd $dotfiles_dir
for file in .*; do
    echo "FILE: " $file
    if [[ $file == "." || $file == ".." ]]; then
      continue
    fi
    log_info "Creating symlink to $file in home directory."
    #dst="$HOME/.$(basename "${file%.*}")"
    dst=~/$file
    echo "DEST" $dst
done
echo "This is the end of the test script\n"
