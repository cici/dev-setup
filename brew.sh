#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade --all

# Install GNU core utilities (those that come with OS X are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils # https://www.gnu.org/software/coreutils/
sudo ln -s /usr/local/bin/gsha256sum /usr/local/bin/sha256sum

# Install some other useful utilities like `sponge`.
brew install moreutils # https://joeyh.name/code/moreutils/
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils # https://www.gnu.org/software/findutils/

# Install ZSH
echo "Installing zsh and Oh-My-Zsh"
brew install zsh # https://www.zsh.org/
brew install zsh-completions # https://github.com/zsh-users/zsh-completions

# Install Oh-My-Zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# We installed the new shell, now we have to activate it
echo "Adding the newly installed shell to the list of allowed shells"
# Prompts for password
sudo -s 'echo /usr/local/bin/zsh >> /etc/shells'
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
# Change to the new shell, prompts for password
chsh -s /usr/local/bin/zsh

# Install `wget` with IRI support.
brew install wget --with-iri # https://www.gnu.org/software/wget/

# Install Development Languages
brew install gradle # https://gradle.org/
brew cask install java
brew install node # https://nodejs.org/en/
brew install python3
brew install ruby
brew install ruby-build
brew install rbenv
LINE='eval "$(rbenv init -)"'
grep -q "$LINE" ~/.extra || echo "$LINE" >> ~/.extra

# Install more recent versions of some OS X tools.
brew install vim --override-system-vi
brew install homebrew/php/php55 --with-gmp

# Install font tools.
brew tap bramstein/webfonttools
brew install sfnt2woff
brew install sfnt2woff-zopfli
brew install woff2

# Install some CTF tools; see https://github.com/ctfs/write-ups.
brew install bfg  # https://rtyley.github.io/bfg-repo-cleaner/
brew install nmap # https://nmap.org/
brew install sqlmap # http://sqlmap.org/
brew install xpdf # https://www.xpdfreader.com/

# Install other useful binaries.
brew install awscli # https://aws.amazon.com/cli/
brew install bitwarden-cli # https://bitwarden.com/
brew install docker # https://www.docker.com/
brew install ffmpeg # https://ffmpeg.org/
brew install git # https://git-scm.com/book/en/v1/Getting-Started-Installing-Git
brew install git-extras # https://github.com/tj/git-extras
brew install httpie # https://httpie.org/
brew install imagemagick --with-webp # https://imagemagick.org/
brew install openssh # https://www.openssh.com/
brew install openssl # https://www.openssl.org/
brew install pandoc # https://pandoc.org/
brew install speedtest_cli # https://github.com/sivel/speedtest-cli
brew install the_silver_searcher # https://github.com/ggreer/the_silver_searcher
brew install tree # http://mama.indstate.edu/users/ice/tree/
brew install wine # https://www.winehq.org/
brew install youtube-dl # https://ytdl-org.github.io/youtube-dl/




# Install Heroku
brew install heroku/brew/heroku
heroku update

# Core casks
brew cask install --appdir="/Applications" alfred # https://www.alfredapp.com/
brew cask install --appdir="~/Applications" iterm2 # https://www.iterm2.com/

# Development tool casks
brew cask install --appdir="/Applications" sublime-text
brew cask install --appdir="/Applications" atom
brew cask install --appdir="/Applications" macdown # https://macdown.uranusjr.com/

# Misc casks
brew cask install --appdir="/Applications" 1password # https://1password.com/
brew cask install --appdir="/Applications" avast-security # https://www.avast.com/en-us/index
brew cask install --appdir="/Applications" bitwarden # https://bitwarden.com/
brew cask install --appdir="/Applications" dash # https://kapeli.com/dash
brew cask install --appdir="/Applications" diffmerge # https://sourcegear.com/diffmerge/
brew cask install --appdir="/Applications" dropbox # https://www.dropbox.com/
brew cask install --appdir="/Applications" evernote # https://evernote.com/
brew cask install --appdir="/Applications" firefox # https://www.mozilla.org/en-US/firefox/new/
brew cask install --appdir="/Applications" gimp # https://www.gimp.org/
brew cask install --appdir="/Applications" gitter # https://gitter.im/explore/tags/homebrew
brew cask install --appdir="/Applications" google-chrome # https://www.google.com/chrome/
brew cask install --appdir="/Applications" handbrake # https://handbrake.fr/
brew cask install --appdir="/Applications" mysqlworkbench # https://www.mysql.com/products/workbench/
brew cask install --appdir="/Applications" postbox # https://www.postbox-inc.com/
brew cask install --appdir="/Applications" postman # https://www.getpostman.com/
brew cask install --appdir="/Applications" skype # https://www.skype.com/en/
brew cask install --appdir="/Applications" slack # https://slack.com/
brew cask install --appdir="/Applications" sourcetree # https://www.sourcetreeapp.com/
brew cask install --appdir="/Applications" spotify # https://www.spotify.com/us/
brew cask install --appdir="/Applications" transmission # https://transmissionbt.com/
brew cask install --appdir="/Applications" visual-studio-code # https://code.visualstudio.com/
brew cask install --appdir="/Applications" vlc # https://www.videolan.org/vlc/

# Install developer friendly quick look plugins; see https://github.com/sindresorhus/quick-look-plugins
brew cask install qlcolorcode qlstephen qlmarkdown quicklook-json qlimagesize suspicious-package quicklookase qlvideo

# Remove outdated versions from the cellar.
brew cleanup
