
ZSH_THEME="avit" # or use agnoster or pygmalion

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

plugins=(aws git git-flow docker docker-compose pip python brew osx npm virtualenv virtualenvwrapper)

PATH=/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
PATH=/usr/local/Cellar/python/3.7.5/Frameworks/Python.framework/Versions/3.7/bin:$PATH
export PATH

# Additional scripts
source $DOTFILES/zsh/plugins.zsh
source $DOTFILES/zsh/aliases.zsh
source $DOTFILES/zsh/exports.zsh
source $DOTFILES/zsh/functions.zsh

# Make sure navi is loaded for zsh
source "$(navi widget zsh)"


# source $ZSH/oh-my-zsh.sh
[ -s "$ZSH/oh-my-zsh.sh" ] && . "$ZSH/oh-my-zsh.sh"

#[ -f ~/.secrets ] && source ~/.secrets
#[ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
#[ -f ~/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh ] && source ~/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=121'

# Shell options
setopt NO_CASE_GLOB # Case Insensitive Globbing
setopt AUTO_CD # If command can't be executed, and command is name of a directory, cd to directory
HISTFILE="$HOME/.zsh_history"
SAVEHIST=10000
HISTSIZE=10000
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt SHARE_HISTORY # share history across multiple zsh sessions
setopt APPEND_HISTORY # append to history
setopt EXTENDED_HISTORY # larger history size
setopt INC_APPEND_HISTORY # adds commands as they are typed, not at shell exit
setopt HIST_IGNORE_DUPS # do not store duplications
setopt HIST_VERIFY # show the substituted command in the prompt
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt AUTO_MENU
setopt ALWAYS_TO_END
setopt COMPLETE_IN_WORD
unsetopt FLOW_CONTROL
unsetopt MENU_COMPLETE

PROMPT='%(?.%F{green}√.%F{red}?%?)%f %B%F{240}%1~%f%b %# '

#source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/usr/local/share/zsh-syntax-highlighting/highlighters

#source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZSH/oh-my-zsh.sh

eval "$(starship init zsh)"