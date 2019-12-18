#!/usr/bin/env bash

function in_progress () {
  printf "here"
  printf "\\r  [ \\033[00;34m\\u23F0\\033[0m ] %s\\r" "${1}"
  echo -e "\e[31mOutput as is.\e[m"
printf "\e[32mThis is green line.\e[m\n"
printf "\e[33;1m%s\n" 'This is yellow bold line.'
}

in_progress "$1"

ESC_SEQ="\x1b["
COL_RESET=$ESC_SEQ"39;49;00m"
COL_RED=$ESC_SEQ"31;01m"
COL_GREEN=$ESC_SEQ"32;01m"
COL_YELLOW=$ESC_SEQ"33;01m"
COL_BLUE=$ESC_SEQ"34;01m"
COL_MAGENTA=$ESC_SEQ"35;01m"
COL_CYAN=$ESC_SEQ"36;01m"

function ok() {
    echo "$COL_GREEN[ok]$COL_RESET "$1
}

ok hello
ok

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

log "OK" "$GREEN" "This is my message"
