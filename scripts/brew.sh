#!/usr/bin/env bash

# Helper functions
function echo_ok { echo -e '\033[1;32m'"$1"'\033[0m'; }
function echo_warn { echo -e '\033[1;33m'"$1"'\033[0m'; }
function echo_error  { echo -e '\033[1;31mERROR: '"$1"'\033[0m'; }

echo_ok "Install starting. You will be asked for your password (for sudo)."

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Check for Homebrew,
# Install if we don't have it
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
if test ! $(which brew); then
  echo_warn "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  echo_ok "Homebrew already installed"
fi

echo_ok "Ensure the latest Homebrew and formula are installed"
# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade && brew cask upgrade

echo_ok "Begin Software Installation"
# Install GNU core utilities (those that come with OS X are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils # https://www.gnu.org/software/coreutils/
sudo ln -s /usr/local/bin/gsha256sum /usr/local/bin/sha256sum

# Install some other useful utilities like `sponge`.
brew install moreutils # https://joeyh.name/code/moreutils/
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils # https://www.gnu.org/software/findutils/


# Install ZSH
echo_warn "Installing zsh and Oh-My-Zsh"
brew install zsh # https://www.zsh.org/
brew install zsh-completions # https://github.com/zsh-users/zsh-completions
brew install zsh-syntax-highlighting # https://github.com/zsh-users/zsh-syntax-highlighting
brew install zsh-autosuggestions # https://github.com/zsh-users/zsh-autosuggestions

# Install Oh-My-Zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended

# We installed the new shell, now we have to activate it
echo_warn "Adding the newly installed shell to the list of allowed shells"
# Prompts for password
sudo -s 'echo /usr/local/bin/zsh >> /etc/shells'
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
# Change to the new shell, prompts for password
chsh -s /usr/local/bin/zsh

# Install `wget`.
brew install wget # https://www.gnu.org/software/wget/

# Install Development Languages
echo_warn "Installing development languages..."
brew install gradle # https://gradle.org/
#brew cask install java
brew cask install adoptopenjdk/openjdk/adoptopenjdk8
brew install node # https://nodejs.org/en/
brew install python3 # https://www.python.org/
grep -q "$LINE" ~/.extra || echo "$LINE" >> ~/.extra

# Install some CTF tools; see https://github.com/ctfs/write-ups.
echo_warn "Installing security tools"
brew install bfg  # https://rtyley.github.io/bfg-repo-cleaner/
brew install nmap # https://nmap.org/
brew install sqlmap # http://sqlmap.org/

# Brew Taps
echo_warn "Tapping some casks..."
brew tap bramstein/webfonttools
brew tap heroku/brew
brew tap homebrew/cask
brew tap homebrew/cask-cask
brew tap homebrew/cask-fonts
brew tap homebrew/cask-versions
brew tap homebrew/core
brew tap homebrew/services
brew tap wtfutil/wtfutil

# Install infrastructure tools
echo_warn "Installing infrastructure tools and database"
brew cask install docker  # https://www.docker.com/
brew install mysql # https://www.mysql.com
brew install docker-compose # https://docs.docker.com/compose/
brew install docker-completion # https://docs.docker.com/compose/completion/
brew install docker-compose-completion # https://docs.docker.com/compose/completion/

# Install other useful binaries.
echo_warn "Installing command line tools"
brew install awscli # https://aws.amazon.com/cli/
brew install bat # https://github.com/sharkdp/bat
brew install bitwarden-cli # https://bitwarden.com/
brew install diff-so-fancy # https://github.com/so-fancy/diff-so-fancy
brew install exa # https://the.exa.website/
brew install ffmpeg # https://ffmpeg.org/
brew install git # https://git-scm.com/book/en/v1/Getting-Started-Installing-Git
brew install git-extras # https://github.com/tj/git-extras
brew install httpie # https://httpie.org/
brew install imagemagick --with-webp # https://imagemagick.org/
brew install jq # https://stedolan.github.io/jq/
brew install less # http://www.greenwoodsoftware.com/less/
brew install denisidoro/tools/navi # https://github.com/denisidoro/navi
brew install openssh # https://www.openssh.com/
brew install openssl # https://www.openssl.org/
brew install pandoc # https://pandoc.org/
brew install speedtest_cli # https://github.com/sivel/speedtest-cli
brew install starship # https://github.com/starship/starship
brew install the_silver_searcher # https://github.com/ggreer/the_silver_searcher
brew install thefuck # https://github.com/nvbn/thefuck
brew install tmux # https://www.iterm2.com/documentation-tmux-integration.html
brew install tree # http://mama.indstate.edu/users/ice/tree/
brew install vim # https://www.vim.org/
brew install watch # https://formulae.brew.sh/formula/watch
brew install wtfutil # https://wtfutil.com/
brew install xpdf # https://www.xpdfreader.com/
brew install youtube-dl # https://ytdl-org.github.io/youtube-dl/

# Install fonts
echo_warn "Installing fonts and font tools..."
brew install sfnt2woff
brew install sfnt2woff-zopfli
brew install woff2

brew tap homebrew/cask-fonts
fonts=(
    font-fira-code
    font-hack-nerd-font
    font-hack-nerd-font-mono
    font-inconsolata-nerd-font
    font-inconsolata-nerd-font-mono
    font-source-code-pro
    font-roboto
)
brew cask install ${fonts[@]}

echo_warn "Installing graphical tools"
brew cask install 1password # https://1password.com/
brew cask install 1password-cli # https://support.1password.com/command-line/
brew cask install alfred # https://www.alfredapp.com/
brew cask install aptanastudio # http://www.aptana.com/
brew cask install atom # https://atom.io/
brew cask install bitwarden # https://bitwarden.com/
brew cask install cyberduck # https://cyberduck.io/
brew cask install dash # https://kapeli.com/dash
brew cask install datagrip # https://www.jetbrains.com/datagrip/
brew cask install diffmerge # https://sourcegear.com/diffmerge/
brew cask install dropbox # https://www.dropbox.com/
brew cask install eddie # https://formulae.brew.sh/cask/eddie
brew cask install evernote # https://evernote.com/
brew cask install firefox # https://www.mozilla.org/en-US/firefox/new/
brew cask install gimp # https://www.gimp.org/
brew cask install gitter # https://gitter.im/explore/tags/homebrew
brew cask install google-chrome # https://www.google.com/chrome/
brew cask install handbrake # https://handbrake.fr/
brew cask install intellij-idea-ce # https://www.jetbrains.com/idea/
brew cask install idrive # https://www.idrive.com/
brew cask install iterm2 # https://www.iterm2.com/
brew cask install macdown # https://macdown.uranusjr.com/
brew cask install mysqlworkbench # https://www.mysql.com/products/workbench/
brew cask install polar-bookshelf # https://getpolarized.io/
brew cask install postbox # https://www.postbox-inc.com/
brew cask install postman # https://www.getpostman.com/
brew cask install shift # https://tryshift.com/
brew cask install skype # https://www.skype.com/en/
brew cask install slack # https://slack.com/
brew cask install sourcetree # https://www.sourcetreeapp.com/
brew cask install spotify # https://www.spotify.com/us/
brew cask install transmission # https://transmissionbt.com/
brew cask install visual-studio-code-insiders # https://code.visualstudio.com/insiders/
brew cask install vlc # https://www.videolan.org/vlc/
brew cask install wine-stable # https://wiki.winehq.org/MacOS
brew cask install zoomus # https://www.zoom.us/

echo_warn "Installing quicklook plugins..."
# Install developer friendly quick look plugins; see https://github.com/sindresorhus/quick-look-plugins
brew cask install qlcolorcode qlstephen qlmarkdown quicklook-json qlimagesize suspicious-package quicklookase qlvideo

# ---------------------------------------------
# Terminal gimmicks xD
# ---------------------------------------------
echo_warn "Installing fun terminal commands..."
# The computer fortune teller
brew install fortune

# The famous cowsay
brew install cowsay

# Multicolored text output
brew install lolcat

echo_warn "Cleaning up the cellar"
# Remove outdated versions from the cellar.
brew cleanup

rm -f -r /Library/Caches/Homebrew/* > /dev/null 2>&1

echo_ok "BREW COMPLETE!"
