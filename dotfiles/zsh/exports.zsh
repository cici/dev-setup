# Make vim the default editor.
export EDITOR='vim';

# SSH keypath
export SSH_KEY_PATH=$HOME/.ssh/id_rsa

export PATH="/usr/local/sbin:/usr/local/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
export ZSH=~/.oh-my-zsh
export ZSH_CUSTOM=~/.oh-my-zsh/custom

# Project Directories
export DOTFILES="${HOME}/.dotfiles"
export PROJECTS="${HOME}/Projects"
export WORK="${HOME}/Projects/Slalom"

# Locale
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'
export LANGUAGE='en_US.UTF-8'

# Programming language exports
#export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK/Home
export JAVA_HOME=$(/usr/libexec/java_home)
export PYTHONPATH="/usr/local/Cellar/python/3.7.5/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages"


# Only allow pip to run if inside a virtualenv
export PIP_REQUIRE_VIRTUALENV=true

# Highlight section titles in manual pages.
export LESS_TERMCAP_md="${yellow}";

# Don’t clear the screen after quitting a manual page.
export MANPAGER='less -X';

# Default Pager
export PAGER='less'

# Term
export TERM='xterm-256color'

# Temporary directory for testing out downloads
export MAC_OS_WORK_PATH=~/Working

# Always enable colored `grep` output.
export GREP_OPTIONS='--color=auto';

# Homebrew defaults
export HOMEBREW_PREFIX=${HOMEBREW_PREFIX:-"/usr/local"}
export HOMEBREW_CELLAR=${HOMEBREW_CELLAR:-"/usr/local/Cellar"}
export HOMEBREW_REPOSITORY=${HOMEBREW_REPOSITORY:-"/usr/local/Homebrew"}
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

if [ -n "$JAVA_HOME" ]; then
  export JDK_HOME=$JAVA_HOME
  export JRE_HOME=$JAVA_HOME
  export PATH="$JAVA_HOME/bin:$PATH"
fi

# lazy add M2_HOME
if [ -d "/opt/maven" ]; then
  export M2_HOME="/opt/maven"
fi
if [ -d "/usr/share/maven" ]; then
  export M2_HOME="/usr/share/maven"
fi
if [ -n "$M2_HOME" ]; then
  export PATH="$M2_HOME/bin:$PATH"
fi