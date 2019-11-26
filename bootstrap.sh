#!/usr/bin/env bash

DOTCONFIG=$HOME/.config
DOTFILES=$HOME/.dotfiles

cd "$(dirname "${BASH_SOURCE}")";


info() {
    printf "\033[00;34m$@\033[0m\n"
}


function doIt() {
    rsync --exclude ".git/" --exclude ".DS_Store" --exclude "bootstrap.sh" \
        --exclude "README.md" --exclude "LICENSE" -avh --no-perms . ~;
    source ~/.bash_profile;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
    doIt;
else
    read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
    echo "";
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        doIt;
    fi;
fi;
unset doIt;
'

# Installs application code from a Git repository.
# Parameters: $1 (required) - Repository URL, $2 (required) - Install path, $3 (optional) - Git clone options.
install_git_app() {
  local repository_url="$1"
  local app_name=$(get_file_name "$2")
  local install_path="$2"
  local options="--quiet"

  if [[ -n "$3" ]]; then
    local options="$options $3"
  fi

  if [[ ! -e "$install_path" ]]; then
    printf "Installing: $install_path/$app_name...\n"
    git clone $options "$repository_url" "$install_path"
    printf "Installed: $app_name.\n"
    verify_path "$install_path"
  fi
}
export -f install_git_app
