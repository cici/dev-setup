#!/usr/bin/env bash

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `osxprep.sh` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Step 1: Update the OS and Install Xcode Tools
echo "------------------------------"
echo "Updating OSX.  If this requires a restart, run the script again."
# Install all available updates
sudo softwareupdate -ia --verbose
# Install only recommended available updates
#sudo softwareupdate -ir --verbose

echo "------------------------------"
echo "Installing Xcode Command Line Tools."
# Install Xcode command line tools
xcode-select --install

# Install SDKMan
#curl -s "https://get.sdkman.io" | bash
#source "$HOME/.sdkman/bin/sdkman-init.sh"

echo "------------------------------"
echo "Installing Oh My Bash"
# Install Oh My Bash
echo "Install oh-my-bash with the Pure theme"
if [ ! -d "$BASH" ]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmybash/oh-my-bash/master/tools/install.sh)"
else
    echo "oh-my-bash is already installed. Skipping"
fi
sh -c "$(curl -fsSL https://raw.github.com/ohmybash/oh-my-bash/master/tools/install.sh)"

# change to bash 4 (installed by homebrew)
#BASHPATH=$(brew --prefix)/bin/bash
#sudo echo $BASHPATH >> /etc/shells
#sudo bash -c 'echo $(brew --prefix)/bin/bash >> /etc/shells'
#chsh -s $BASHPATH # will set for current user only.
#echo $BASH_VERSION # should be 4.x not the old 3.2.X

echo "------------------------------"
echo "Create an SSH key for Github, Gitlab and whatever else"
# Create SSH key
ssh-keygen -t rsa -b 4096 -C "public.thomson@gmail.com"
