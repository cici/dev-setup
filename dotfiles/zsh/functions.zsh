# File search functions
function f() { find . -iname "*$1*" ${@:2} }
function r() { grep "$1" ${@:2} -R . }

# Create a folder and move into it in one command
function mkcd() { mkdir -p "$@" && cd "$_"; }

# Change working directory to the top-most Finder window location
function cdf() { # short for `cdfinder`
    cd "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')";
}

function extract () {
    if [ -f $1 ] ; then
      case $1 in
        *.tar.bz2)   tar xjf $1     ;;
        *.tar.gz)    tar xzf $1     ;;
        *.bz2)       bunzip2 $1     ;;
        *.rar)       unrar e $1     ;;
        *.gz)        gunzip $1      ;;
        *.tar)       tar xf $1      ;;
        *.tbz2)      tar xjf $1     ;;
        *.tgz)       tar xzf $1     ;;
        *.zip)       unzip $1       ;;
        *.Z)         uncompress $1  ;;
        *.7z)        7z x $1        ;;
        *)     echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

function symlink() {
  src="$1"
  dest="$2"

  if [ -e "$dest" ]; then
    if [ -L "$dest" ]; then
      if [ ! -e "$dest" ]; then
        echo "Removing broken symlink at $dest"
        rm "$dest"
      else
        # Already symlinked -- I'll assume correctly.
        return 0
      fi
    else
      # Rename files with a ".old" extension.
      echo "$dest already exists, renaming to $dest.old"
      backup="$dest.old"
      if [ -e "$backup" ]; then
        echo "Error: "$backup" already exists. Please delete or rename it."
        exit 1
      fi
      mv -v "$dest" "$backup"
    fi
  fi
  ln -sf "$src" "$dest"
}

# Create a .tar.gz archive, using `zopfli`, `pigz` or `gzip` for compression
function targz() {
    local tmpFile="${@%/}.tar";
    tar -cvf "${tmpFile}" --exclude=".DS_Store" "${@}" || return 1;

    size=$(
        stat -f"%z" "${tmpFile}" 2> /dev/null; # OS X `stat`
        stat -c"%s" "${tmpFile}" 2> /dev/null # GNU `stat`
    );

    local cmd="";
    if (( size < 52428800 )) && hash zopfli 2> /dev/null; then
        # the .tar file is smaller than 50 MB and Zopfli is available; use it
        cmd="zopfli";
    else
        if hash pigz 2> /dev/null; then
            cmd="pigz";
        else
            cmd="gzip";
        fi;
    fi;

    echo "Compressing .tar using \`${cmd}\`…";
    "${cmd}" -v "${tmpFile}" || return 1;
    [ -f "${tmpFile}" ] && rm "${tmpFile}";
    echo "${tmpFile}.gz created successfully.";
}

# Determine size of a file or total size of a directory
function fs() {
    if du -b /dev/null > /dev/null 2>&1; then
        local arg=-sbh;
    else
        local arg=-sh;
    fi
    if [[ -n "$@" ]]; then
        du $arg -- "$@";
    else
        du $arg .[^.]* *;
    fi;
}

# Use Git’s colored diff when available
hash git &>/dev/null;
if [ $? -eq 0 ]; then
    function diff() {
        git diff --no-index --color-words "$@";
    }
fi;

# Create a data URL from a file
function dataurl() {
    local mimeType=$(file -b --mime-type "$1");
    if [[ $mimeType == text/* ]]; then
        mimeType="${mimeType};charset=utf-8";
    fi
    echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')";
}

# Create a git.io short URL
function gitio() {
    if [ -z "${1}" -o -z "${2}" ]; then
        echo "Usage: \`gitio slug url\`";
        return 1;
    fi;
    curl -i http://git.io/ -F "url=${2}" -F "code=${1}";
}

# Start an HTTP server from a directory, optionally specifying the port
function server() {
    local port="${1:-8000}";
    sleep 1 && open "http://localhost:${port}/" &
    # Set the default Content-Type to `text/plain` instead of `application/octet-stream`
    # And serve everything as UTF-8 (although not technically correct, this doesn’t break anything for binary files)
    python -c $'import SimpleHTTPServer;\nmap = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map;\nmap[""] = "text/plain";\nfor key, value in map.items():\n\tmap[key] = value + ";charset=UTF-8";\nSimpleHTTPServer.test();' "$port";
}

# Compare original and gzipped file size
function gz() {
    local origsize=$(wc -c < "$1");
    local gzipsize=$(gzip -c "$1" | wc -c);
    local ratio=$(echo "$gzipsize * 100 / $origsize" | bc -l);
    printf "orig: %d bytes\n" "$origsize";
    printf "gzip: %d bytes (%2.2f%%)\n" "$gzipsize" "$ratio";
}

# Syntax-highlight JSON strings or files
# Usage: `json '{"foo":42}'` or `echo '{"foo":42}' | json`
function json() {
    if [ -t 0 ]; then # argument
        python -mjson.tool <<< "$*" | pygmentize -l javascript;
    else # pipe
        python -mjson.tool | pygmentize -l javascript;
    fi;
}

# Run `dig` and display the most useful info
function digga() {
    dig +nocmd "$1" any +multiline +noall +answer;
}

# UTF-8-encode a string of Unicode symbols
function escape() {
    printf "\\\x%s" $(printf "$@" | xxd -p -c1 -u);
    # print a newline unless we’re piping the output to another program
    if [ -t 1 ]; then
        echo ""; # newline
    fi;
}

# Show all the names (CNs and SANs) listed in the SSL certificate
# for a given domain
function getcertnames() {
    if [ -z "${1}" ]; then
        echo "ERROR: No domain specified.";
        return 1;
    fi;

    local domain="${1}";
    echo "Testing ${domain}…";
    echo ""; # newline

    local tmp=$(echo -e "GET / HTTP/1.0\nEOT" \
        | openssl s_client -connect "${domain}:443" -servername "${domain}" 2>&1);

    if [[ "${tmp}" = *"-----BEGIN CERTIFICATE-----"* ]]; then
        local certText=$(echo "${tmp}" \
            | openssl x509 -text -certopt "no_aux, no_header, no_issuer, no_pubkey, \
            no_serial, no_sigdump, no_signame, no_validity, no_version");
        echo "Common Name:";
        echo ""; # newline
        echo "${certText}" | grep "Subject:" | sed -e "s/^.*CN=//" | sed -e "s/\/emailAddress=.*//";
        echo ""; # newline
        echo "Subject Alternative Name(s):";
        echo ""; # newline
        echo "${certText}" | grep -A 1 "Subject Alternative Name:" \
            | sed -e "2s/DNS://g" -e "s/ //g" | tr "," "\n" | tail -n +2;
        return 0;
    else
        echo "ERROR: Certificate not found.";
        return 1;
    fi;
}

# `tre` is a shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
function tre() {
    tree -aC -I '.git|node_modules|bower_components' --dirsfirst "$@" | less -FRNX;
}

# find shorthand
function f() {
	find . -name "$1" 2>&1 | grep -v 'Permission denied'
}

# List all files, long format, colorized, permissions in octal
function la(){
 	ls -l  "$@" | awk '
    {
      k=0;
      for (i=0;i<=8;i++)
        k+=((substr($1,i+2,1)~/[rwx]/) *2^(8-i));
      if (k)
        printf("%0o ",k);
      printf(" %9s  %3s %2s %5s  %6s  %s %s %s\n", $3, $6, $7, $8, $5, $9,$10, $11);
    }'
}

# git commit browser. needs fzf
function log() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --toggle-sort=\` \
      --bind "ctrl-m:execute:
                echo '{}' | grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R'"
}

# Copy w/ progress
function cp_p () {
  rsync -WavP --human-readable --progress $1 $2
}

function localip(){
	function _localip(){ echo "📶  "$(ipconfig getifaddr "$1"); }
	export -f _localip
	local purple="\x1B\[35m" reset="\x1B\[m"
	networksetup -listallhardwareports | \
		sed -r "s/Hardware Port: (.*)/${purple}\1${reset}/g" | \
		sed -r "s/Device: (en.*)$/_localip \1/e" | \
		sed -r "s/Ethernet Address:/📘 /g" | \
		sed -r "s/(VLAN Configurations)|==*//g"
}

function please() {
  local CMD=$(history -1 | cut -d" " -f4-)
  sudo "$CMD"
}

# Create a new project and cd into it, does NOT check if project already exists
function project () {
	# TODO : redirect io to /dev/null and write custom messages
        if [ $# -lt 1 ] ; then
                cd "$PATH_TO_PROJECTS" && log_info 'In Projects'
        fi

        mkdir -p "$PATH_TO_PROJECTS/$1" && cd "$PATH_TO_PROJECTS/$1"
        log_info "In project $1"
}

# Get weather report for specified location
# if second argument (optional) is "-f", get 3-day forecast for morning, nnon, evening, night
# else if first argument is only location, get current weather only
function weather() {
	if [[ "$2" == "-f" ]]; then
		curl "http://wttr.in/${1}?M"
	else
		curl "http://wttr.in/${1}?0&M"
	fi
}

# Find all files in dirs/subdirs containing search query
function find_string_in_file() {
	grep \
		--exclude-dir=node_modules \
		--exclude-dir=.fusebox \
		--exclude-dir=dist \
		--exclude-dir=.git \
		-wroni "${1}" . | sort -u | grep -iv "^${1}" | sed "/^$/d" | grep -i --color=always "${1}"
}

# duh: Sort the "du"-command output and use human-readable units.
duh()
{
  local unit=""
  local size=""

  du -k "$@" | sort -n | while read size fname; do
    for unit in KiB MiB GiB TiB PiB EiB ZiB YiB; do
      if [ "$size" -lt 1024 ]; then
        echo -e "${size} ${unit}\t${fname}"
        break
      fi
      size=$((size/1024))
    done
  done
}

# -------------------------------------------------------------------
# fs: Determine size of a file or total size of a directory
fs()
{
  if du -b /dev/null > /dev/null 2>&1; then
    local arg=-sbh
  else
    local arg=-sh
  fi

  if [[ -n "$@" ]]; then
    du $arg -- "$@"
  else
    du $arg .[^.]* ./*
  fi
}

# -------------------------------------------------------------------
# ff: displays all files in the current directory (recursively)
ff()
{
  find . -type f -iname '*'$*'*' -ls
}

# -------------------------------------------------------------------
# fstr: find text in files
fstr()
{
  OPTIND=1
  local case=""
  local usage="fstr: find string in files.
  Usage: fstr [-i] \"pattern\" [\"filename pattern\"] "

  while getopts :it opt
  do
        case "$opt" in
        i) case="-i " ;;
        *) echo "$usage"; return;;
        esac
  done

  shift $(( $OPTIND - 1 ))
  if [ "$#" -lt 1 ]; then
    echo "$usage"
    return 1
  fi

  find . -type f -name "${2:-*}" -print0 \
    | xargs -0 egrep --color=auto -Hsn ${case} "$1" 2>&- \
    | more
}

# Download a song from YouTube
function youtube_song () {
    youtube-dl --audio-format m4a -x "$@"
}

# Enter a running Docker container.
function denter() {
 if [[ ! "$1" ]] ; then
     echo "You must supply a container ID or name."
     return 0
 fi

 docker exec -it $1 bash
 return 0
}

# -------------------------------------------------------------------
# wtfis: Show what a given command really is. It is a combination of "type", "file"
# and "ls". Unlike "which", it does not only take $PATH into account. This
# means it works for aliases and hashes, too. (The name "whatis" was taken,
# and I did not want to overwrite "which", hence "wtfis".)
# The return value is the result of "type" for the last command specified.
#
# usage:
#
#   wtfis man
#   wtfis vi
#
# source: https://raw.githubusercontent.com/janmoesen/tilde/master/.bash/commands
wtfis()
{
  local cmd=""
  local type_tmp=""
  local type_command=""
  local i=1
  local ret=0

  if [ -n "$BASH_VERSION" ]; then
    type_command="type -p"
  else
    type_command=( whence -p ) # changes variable type as well
  fi

  if [ $# -eq 0 ]; then
    # Use "fc" to get the last command, and use that when no command
    # was given as a parameter to "wtfis".
    set -- $(fc -nl -1)

    while [ $# -gt 0 -a '(' "sudo" = "$1" -o "-" = "${1:0:1}" ')' ]; do
      # Ignore "sudo" and options ("-x" or "--bla").
      shift
    done

    # Replace the positional parameter array with the last command name.
    set -- "$1"
  fi

  for cmd; do
    type_tmp="$(type "$cmd")"
    ret=$?

    if [ $ret -eq 0 ]; then
      # Try to get the physical path. This works for hashes and
      # "normal" binaries.
      local path_tmp=$(${type_command} "$cmd" 2>/dev/null)

      if [ $? -ne 0 ] || ! test -x "$path_tmp"; then
        # Show the output from "type" without ANSI escapes.
        echo "${type_tmp//$'\e'/\\033}"

        case "$(command -v "$cmd")" in
          'alias')
            local alias_="$(alias "$cmd")"

            # The output looks like "alias foo='bar'" so
            # strip everything except the body.
            alias_="${alias_#*\'}"
            alias_="${alias_%\'}"

            # Use "read" to process escapes. E.g. 'test\ it'
            # will # be read as 'test it'. This allows for
            # spaces inside command names.
            read -d ' ' alias_ <<< "$alias_"

            # Recurse and indent the output.
            # TODO: prevent infinite recursion
            wtfis "$alias_" 2>&2 | sed 's/^/  /'

            ;;
          'keyword' | 'builtin')

            # Get the one-line description from the built-in
            # help, if available. Note that this does not
            # guarantee anything useful, though. Look at the
            # output for "help set", for instance.
            help "$cmd" 2>/dev/null | {
              local buf line
              read -r line
              while read -r line; do
                buf="$buf${line/.  */.} "
                if [[ "$buf" =~ \.\ $ ]]; then
                  echo "$buf"
                  break
                fi
              done
            }

            ;;
        esac
      else
        # For physical paths, get some more info.
        # First, get the one-line description from the man page.
        # ("col -b" gets rid of the backspaces used by OS X's man
        # to get a "bold" font.)
        (COLUMNS=10000 man "$(basename "$path_tmp")" 2>/dev/null) | col -b | \
        awk '/^NAME$/,/^$/' | {
          local buf=""
          local line=""

          read -r line
          while read -r line; do
            buf="$buf${line/.  */.} "
            if [[ "$buf" =~ \.\ $ ]]; then
              echo "$buf"
              buf=''
              break
            fi
          done

          [ -n "$buf" ] && echo "$buf"
        }

        # Get the absolute path for the binary.
        local full_path_tmp="$(
          cd "$(dirname "$path_tmp")" \
            && echo "$PWD/$(basename "$path_tmp")" \
            || echo "$path_tmp"
        )"

        # Then, combine the output of "type" and "file".
        local fileinfo="$(file "$full_path_tmp")"
        echo "${type_tmp%$path_tmp}${fileinfo}"

        # Finally, show it using "ls" and highlight the path.
        # If the path is a symlink, keep going until we find the
        # final destination. (This assumes there are no circular
        # references.)
        local paths_tmp=("$path_tmp")
        local target_path_tmp="$path_tmp"

        while [ -L "$target_path_tmp" ]; do
          target_path_tmp="$(readlink "$target_path_tmp")"
          paths_tmp+=("$(
            # Do some relative path resolving for systems
            # without readlink --canonicalize.
            cd "$(dirname "$path_tmp")"
            cd "$(dirname "$target_path_tmp")"
            echo "$PWD/$(basename "$target_path_tmp")"
          )")
        done

        local ls="$(command ls -fdalF "${paths_tmp[@]}")"
        echo "${ls/$path_tmp/$'\e[7m'${path_tmp}$'\e[27m'}"
      fi
    fi

    # Separate the output for all but the last command with blank lines.
    [ $i -lt $# ] && echo
    let i++
  done

  return $ret
}

# Commit what's been staged, use args as message.
gc() {
  git commit -m "$*" && \
  git log --oneline --decorate -n 10
}

# Returns whether the given command is executable or aliased.
_has() {
  return $( whence $1 &>/dev/null )
}

function send-sms() {
  curl -X POST https://textbelt.com/text \
       --data-urlencode phone="$1" \
       --data-urlencode message="$2" \
       -d key=textbelt
}

function psgrep() {
  ps auxf | grep -v grep | grep "$@" -i
}

# Cleans work path for temporary processing of installs.
function clean_work_path() {
  rm -rf "$MAC_OS_WORK_PATH"
}

export -f clean_work_path

# Create a new git repo with one README commit and CD into it
function gitnr() { mkdir $1; cd $1; git init; touch README.md; git add README.md; git commit -mFirst-commit;}

# Git add all files, commit with comment and push to remote repo
function acp() {
  git add .
  git commit -m "$1"
  git push
}
