# zsh options
export HISTFILE=~/.zsh_history
export HISTSIZE=1000000
export SAVEHIST=1000000

autoload -U compinit zmv
compinit

setopt AUTOPUSHD
setopt PUSHDMINUS
setopt PUSHDSILENT
setopt PUSHDTOHOME

setopt NOBANGHIST
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_VERIFY
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY

setopt NOHUP
setopt NO_BG_NICE
setopt EXTENDEDGLOB
setopt INTERACTIVECOMMENTS
setopt PROMPT_SUBST
setopt RE_MATCH_PCRE

setopt NO_CHASE_LINKS
setopt NO_CHASE_DOTS

setopt LIST_PACKED
setopt CORRECT
setopt HASH_LIST_ALL

# with this option set you can't do "ls > foo" if foo already exists, so
# you have to do "rm foo; ls > foo" or in one step "ls >! foo"
setopt NOCLOBBER

# make spaces saner
export IFS=$'\t'$'\n'$'\0'
