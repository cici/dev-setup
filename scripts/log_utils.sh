#!/usr/bin/env bash

# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -Eueo pipefail

SETUP_DIR="$HOME/Documents/Projects/dev-setup"

tput sgr0
RED=$(tput setaf 1)
ORANGE=$(tput setaf 3)
GREEN=$(tput setaf 2)
PURPLE=$(tput setaf 5)
BLUE=$(tput setaf 4)
WHITE=$(tput setaf 7)
BOLD=$(tput bold)
RESET=$(tput sgr0)

log() {
  local LABEL="[$1]"
  local COLOR="$2"
  shift
  shift
  local MSG=("$@")
  printf "${COLOR}${LABEL}%*s${RESET}" $(($(tput cols) - ${#LABEL})) | tr ' ' '='
  for M in "${MSG[@]}"; do
    let COL=$(tput cols)-2-${#M}
    printf "%s%${COL}s${RESET}" "$COLOR* $M"
  done
  printf "${COLOR}%*s${RESET}\n\n\n" $(tput cols) | tr ' ' '='
}

log_error() {
  log "FAIL" "$RED" "$@"
  exit 1
}

log_info() {
  log "INFO" "$ORANGE" "$@"
}

log_success() {
  log "OK" "$GREEN" "$@"
}

print_main_banner() {
  cd "$HOME"
  command cat <<EOF
$BLUE

______             _____      _               
|  _  \           /  ___|    | |              
| | | |_____   __ \ `--.  ___| |_ _   _ _ __  
| | | / _ \ \ / /  `--. \/ _ \ __| | | | '_ \ 
| |/ /  __/\ V /  /\__/ /  __/ |_| |_| | |_) |
|___/ \___| \_/   \____/ \___|\__|\__,_| .__/ 
                                       | |    
                                       |_|    
$RESET
EOF

if [ -d "$SETUP_DIR/.git" ]; then
    command cat <<EOF
$BLUE
                      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                      $(git --git-dir "$SETUP_DIR/.git" --work-tree "$SETUP_DIR" log -n 1 --pretty=format:'%C(yellow)commit:  %h') 
                      $(git --git-dir "$SETUP_DIR/.git" --work-tree "$SETUP_DIR" log -n 1 --pretty=format:'%C(red)date:    %ad' --date=short) 
                      $(git --git-dir "$SETUP_DIR/.git" --work-tree "$SETUP_DIR" log -n 1 --pretty=format:'%C(cyan)author:  %an') 
                      $(git --git-dir "$SETUP_DIR/.git" --work-tree "$SETUP_DIR" log -n 1 --pretty=format:'%C(green)message: %s') 
                      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$RESET
EOF
  fi
}

usage() {
    echo "Usage: $(basename "$0") [options]" >&2
    echo
    echo "   -s, --sync            Synchronizes dotfiles to home directory"
    echo "   -l, --link            Create symbolic links for dotfiles"
    echo "   -i, --install         Install Homebrew and applications"
    echo "   -p, --program         Install Programming resources"
    echo "   -f, --fonts           Installs font files"
    echo "   -c, --config          Configures OSX"
    echo "   -a, --all             Does all of the above"
    echo
    exit 1
}