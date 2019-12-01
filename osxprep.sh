#!/usr/bin/env bash

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `osxprep.sh` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Step 1: Update the OS and Install Xcode Tools
log_info "------------------------------"
log_info "Updating OSX.  If this requires a restart, run the script again."
# Install all available updates
sudo softwareupdate -ia --verbose


# ###########################################################
# /etc/hosts -- spyware/ad blocking
# ###########################################################
read -r -p "Overwrite /etc/hosts with the ad-blocking hosts file from someonewhocares.org? (from ../config_files/hosts file) [y|N] " response
if [[ $response =~ (yes|y|Y) ]];then
    log_warn "cp /etc/hosts /etc/hosts.backup"
    sudo cp /etc/hosts /etc/hosts.backup
    log_warn "cp ../config_files/hosts /etc/hosts"
    sudo cp ./configs/hosts /etc/hosts
    log_info "Your /etc/hosts file has been updated. Last version is saved in /etc/hosts.backup"
else
    log_info "skipped";
fi

log_info "------------------------------"
log_info "Installing Xcode Command Line Tools."
# Install Xcode command line tools
xcode-select --install

# Install SDKMan
#curl -s "https://get.sdkman.io" | bash
#source "$HOME/.sdkman/bin/sdkman-init.sh"

log_info "------------------------------"
log_info "Create an SSH key for Github, Gitlab and whatever else"
# Create SSH key
ssh-keygen -t rsa -b 4096 -C "public.thomson@gmail.com"
log_warn "Please copy the ssh key into Github and Gitlab"

log_info "OSX prep completed!"
