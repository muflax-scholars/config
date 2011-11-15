###########        
# Options #
###########

# zsh
export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000

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

# PATH
export PATH="$($HOME/in/scripts/extend_path.sh):$PATH"
export MANPATH="$HOME/local/share/man:$MANPATH"
export LD_LIBRARY_PATH="$HOME/local/lib:$LD_LIBRARY_PATH"

# editor is still vim for speed and because it's more compatible in general
export EDITOR="vim"
export VISUAL="vim"
export MPD_HOST="192.168.1.15"

# ruby
export GEM_HOME="$HOME/local/gems"
export GEM_PATH="$GEM_HOME"
export PATH="$GEM_HOME/bin:$PATH"

# python
export PYTHONSTARTUP="$HOME/.pythonrc"

# don't use japanese on TTY
case ${TERM} in
  linux)
    export LANG=C
    ;;
  *)
    export LANG=ja_JP.UTF-8
    ;;
esac

LS_COLORS='no=00:fi=00:di=00;36:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:';
export LS_COLORS

################################
# let's make an awesome prompt #
################################
autoload colors
if [[ ${terminfo[colors]} -ge 8 ]] then
  colors
fi
autoload -Uz vcs_info

# brackets
local op="%{$fg[green]%}[%{$reset_color%}"
local cp="%{$fg[green]%}]%{$reset_color%}"

# vcs config
zstyle ':vcs_info:*' enable git
# changes are slow, so it's on trial
local vcs_action="(%a)" # e.g. (rebase-i)
local vcs_branch="%b%u%c" # e.g. master(*)(s)
zstyle ':vcs_info:*:prompt:*' check-for-changes true
zstyle ':vcs_info:*:prompt:*' unstagedstr '(*)'  # display [u] if there are unstaged changes
zstyle ':vcs_info:*:prompt:*' stagedstr '(s)'    # display [s] if there are staged changes
zstyle ':vcs_info:*:prompt:*' actionformats " ${op}%{$fg[cyan]%}${vcs_branch}${vcs_action}%{$reset_color%}${cp}"
zstyle ':vcs_info:*:prompt:*' formats " ${op}%{$fg[cyan]%}${vcs_branch}%{$reset_color%}${cp}"
zstyle ':vcs_info:*:prompt:*' nvcsformats ""

# every option takes care of their own leading space

# current date
local date="${op}%{$fg[cyan]%}%*%{$reset_color%}${cp}"

# current user, with warning if root
if [ $(whoami) = "root" ]; then
  local user="%{$fg[red]%}%n%{$reset_color%}"
else
  local user="%{$fg[cyan]%}%n%{$reset_color%}"
fi

# current host, with warning if ssh
if [ -z $SSH_CONNECTION ]; then
  local host="%{$fg[cyan]%}%m%{$reset_color%}"
else
  local host="%{$fg[red]%}%m%{$reset_color%}"
fi

local user_host=" ${op}${user}%{$fg[cyan]%}@%{$reset_color%}${host}${cp}"

# warning if not 64bit
if [ $(uname -m) = "i686" ]; then
  local arch=" ${op}(i686)${cp}"
fi

# are we in an mc shell?
if [[ $MC_SID != "" ]]; then
  local mc=" ${op}%{$fg[cyan]%}°_°%{$reset_color%}${cp}"
fi

# alarm after successful command if in scratchpad
if [[ $STY =~ "^\d+\.scratchpad$" ]]; then
  local bell=""
fi

# current path
local path_p=" ${op}%{$fg[cyan]%}%~%{$reset_color%}${cp}"

# current VCS status
local vcs='$vcs_info_msg_0_'
# smiley based on return status
local smiley="${op}%(?,%{$fg[red]%}<3%{$reset_color%},%{$fg_bold[red]%}>3%{$reset_color%})${cp}"
# last command, used in PS2
local cur_cmd="${op}%_${cp}"

PROMPT="${date}${path_p}${vcs}${user_host}${arch}${bell}
${smiley}${mc} # "
PROMPT2="${cur_cmd}> "

##################
# title handling #
##################

function title() {
  # escape '%' chars in $1, make nonprintables visible
  local a=${(V)1//\%/\%\%}

  # Truncate command, and join lines.
  a=$(print -Pn "%40>...>$a" | tr -d "\n")

  case $TERM in
    screen*)
      print -Pn "\e]2;$a @$2\a" # plain xterm title
      print -Pn "\ek$a\e\\"      # screen title (in ^A")
      ;;
    rxvt*|xterm*)
      print -Pn "\e]2;$a @$2\a" # plain xterm title
      ;;
  esac
}

function precmd() {
  vcs_info 'prompt'
  title "zsh" "%m"
}

# set simple screen title just before program is executed
function preexec() {
  case $TERM in
    screen*)
      local CMD=${1[(wr)^(*=*|sudo|-*)]}
      echo -ne "\ek$CMD\e\\"
      ;;
  esac
}    

##############
# Completion #
##############

# allow approximate
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only

# ignore completion for non-existant functions
zstyle ':completion:*:functions' ignored-patterns '_*'

# tab completion for PID :D
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

# cd not select parent dir. 
zstyle ':completion:*:cd:*' ignore-parents parent pwd

# complete ../
zstyle ':completion:*:cd:*' special-dirs ..

# use a cache
zstyle ':completion:*' use-cache on

# Case insensitivity, partial matching, substitution
zstyle ':completion:*' matcher-list 'm:{A-Z}={a-z}' 'm:{a-z}={A-Z}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'

# on processes completion complete all user processes
zstyle ':completion:*:processes' command 'ps -au$USER'

# Expand partial paths
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-slashes 'yes'

# complete manual by their section
zstyle ':completion:*:manuals'    separate-sections true
zstyle ':completion:*:manuals.*'  insert-sections   true

# always rehash not found commands
zstyle ':acceptline:*' rehash true

################
# Key bindings #
################
bindkey -e 
bindkey '^[[3~' delete-char
bindkey '[1~' beginning-of-line
bindkey '^[[4~' end-of-line
bindkey '^[[5~' beginning-of-history
bindkey '^[[6~' end-of-history

###########
# aliases #
###########

# normal aliases
alias angband="angband -mgcu -umuflax"
alias cal="cal -m -3"
alias cgrep="grep --color=always"
alias diff="colordiff"
alias e="emacs -nw"
alias em="emacs-gui"
alias evil="for s in {1..3}; do echo -n 'VI! '; sleep .7; done; echo; vi"
alias grep="grep --color=auto -P"
alias less="less -iF" 
alias ls="ls --color=always --group-directories-first -v"
alias mc="mc -x"
alias mkdir="mkdir -p"
alias mmv="noglob zmv -W"
alias po="popd"
alias sc="screen"
alias scratchpad="screen -DRS scratchpad"
alias sr="screen -RD"
alias unc="uncrustify --no-backup -c ~/.uncrustify.cfg"
alias unison="unison -log=false -auto -ui=text -times"
alias vi="vim"

# youtube download
function y() {
  echo "Paste links, ^D start to download."
  youtube-dl -i -c -o "$HOME/youtube/%(title)s-%(id)s.%(ext)s" -a-
}

# portage
alias cdl="cd /usr/local/portage/local"
alias dew="sudo FEATURES=distcc emerge -auD --changed-use --binpkg-respect-use y --with-bdeps y world"
alias ew="sudo emerge -auD --changed-use --binpkg-respect-use y --with-bdeps y world"
alias ec="sudo eclean -d -t2w distfiles; sudo eclean -d -t2w packages"
alias ecc="sudo eclean -d distfiles; sudo eclean -d packages"
alias wg="watch genlop -nc"
alias us="sudo ~/in/scripts/update_system"

# programming
alias burnburnBURN="rm -f *.class; javac *.java"
alias co="./configure"
alias p2="python"
alias p3="python3"
alias p="python3"
alias pe="perl"
alias ru="ruby"
alias b="irb"

# optimized local compiles
function om() {
  CFLAGS='-O2 -pipe -march=nocona' 
  CXXFLAGS=$CFLAGS 
  LDFLAGS='-Wl,-O1 -Wl,--sort-common -Wl,--hash-style=gnu -Wl,--as-needed'  
  make -j3 $*
}

# universal aliases
alias -g DN='&> /dev/null'
alias -g D0='DISPLAY=:0.0'
alias -g D1='DISPLAY=:0.1'
alias -g LC='LANG=C'
alias -g LE='LANG=en_US.UTF-8'
alias -g LJ='LANG=ja_JP.UTF-8'
alias -g L='| less'
alias -g G='| grep'
alias -g GC='| grep --color=always'

# GTD
  # full todo list
  alias t="noglob todo.sh -d ~/.todo.cfg"
  alias ta="t add"
  alias td="t do"
  alias tl="t ls"
  alias trm="t rm"
  alias tt="t delay"
  alias tdel="t delay"

  # only what is relevant today
  alias now="noglob todo.sh -d ~/.todo-today.cfg"
  alias n="now"
  alias nl="now ls"
  alias na="now add"
  alias nd="now do"
  alias nrm="now rm"
  alias nt="now delay"
  alias ndel="now delay"

  # idea file
  alias idea="noglob todo.sh -d ~/.todo-ideas.cfg"
  alias ideas="idea ls"
  alias i="idea"
  alias ia="idea add"
  alias id="idea do"
  alias il="idea ls"
  alias irm="idea rm"

  # timetrap
  # time intervals
  function tid() {
    if [[ $# -eq 0 ]]; then
      arg="all"
    else
      arg=($*)
    fi
    ti display $arg --start 'today 0:00'
  }
  function tiy() {
    if [[ $# -eq 0 ]]; then
      arg="all"
    else
      arg=($*)
    fi
    ti display $arg --start 'yesterday 0:00' --end 'yesterday 23:59:59'
  }
  function tiw() {
    if [[ $# -eq 0 ]]; then
      arg="all"
    else
      arg=($*)
    fi
    ti week $arg
  }
  function tim() {
    if [[ $# -eq 0 ]]; then
      arg="all"
    else
      arg=($*)
    fi
    ti display $arg --start 'first day this month'
  }
  function tilm() {
    if [[ $# -eq 0 ]]; then
      arg="all"
    else
      arg=($*)
    fi
    ti display $arg --start 'first day last month' --end 'first day this month'
  }

  function ti_past() {
    if [[ $# -lt 1 || $# -gt 4 ]]; then
      echo "usage: ti_past [context] start [end] [task]" 
      return 1
    fi
    
    if [[ $# -gt 1 ]]; then
      ti sheet $1
      ti in -a $2 $4
    else 
      ti in -a  $1 $4
    fi
    
    if [[ $# -gt 2 ]]; then
      ti out -a $3
    fi
  }

  # shortcuts
  alias ti="noglob ti"
  alias til="ti list"
  alias tin="ti in"
  alias tio="ti out"
  alias to="tio"
  alias tis="ti sheet"
  alias tir="ti now"
  

# suspend-to-ram
function ss() {
  sudo ~/in/scripts/suspend $*
}

# move target to location and create symbolic link
function mvln() {
  mv $1 $2/ && ln -s $2/$1 $1
}

# a bit of security
alias cp="cp -i"
alias mv="mv -i"

# mplayer
alias l="mw -l"
alias m="mw -l"
alias r="mw -r"

# wake-on-lan
alias wake_azathoth="wakeonlan 00:18:E7:16:6F:C5"
alias wake_totenkopf="wakeonlan 00:50:04:42:99:6F"

# wine
alias ewine="wine explorer /desktop=foo,1024x768"
alias newine="nice wine explorer /desktop=foo,1024x768"

# monitors on/off
alias don="D0 xset dpms force on"
alias doff="D0 xset dpms force off"

# ssh
alias mish="ssh totenkopf@ming"
alias azash="ssh amon@azathoth"
alias nyash="ssh amon@nyarlathotep"

function ipt() {
  S=$(/etc/init.d/iptables status | grep -oP "(start|stop)")
  case $S in
    stop)
      echo "shields up! go to red alert!"
      sudo /etc/init.d/iptables start
    ;;
    start)
      echo "lower your shields and surrender your ships!"
      sudo /etc/init.d/iptables stop
    ;;
  esac
}

function nap() {
  mpc --no-status pause
  echo "お休みなさい。。。"
  if [[ $# -ge 1 ]] then 
    TIME=$(( ($(date -d "$*" +%s) - $(date +%s)) / 60 ))
    echo "going down for $TIME minutes..."
    read
    doff
    sleep ${TIME}m
  else 
    doff
    sleep 25m
  fi && {
    echo "b(・ｏ・)dおw(・0・)wはぁで(・＜＞・)まよｃ(^・^)っちゅ"
    wakeup.sh
  }
}  

function take_hostage() {
  # encrypts each argument individually, writes names and password in the
  # hostage file for further use
  for i in $(seq $#); do
    pw=$(pwgen -1 -B 16)
    target=$*[$i]
    7z -mx0 -p"$pw" a "$target.7z" "$target"
    7z -p"$pw" t "$target.7z"
    if [ $? -eq 0 ]; then
      cowsay "everything seems alright, killing $target..."
      echo "$target - $pw" >> ~/hostages.txt
      rm -rf "$target"
    fi
  done
}

# torrent
alias tor="sudo mount.cifs //192.168.1.102/torrent /mnt/network/torrent-samba -o guest,uid=1000,gid=1006"
alias nor="sudo umount.cifs /mnt/network/torrent-samba"
alias toto="scp ~/*.torrent totenkopf@ming:/home/totenkopf/torrent/.torrents/ && rm ~/*.torrent" 

# lol!!k!
alias cya='sudo reboot'
alias kthxbai='sudo shutdown -h now'

################################
# syntax highlighting (srsly!) #
################################
source ~/.zsh_syntax/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_STYLES[globbing]='fg=red'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=cyan'

# disable flow control to free up ^s and ^q
stty -ixon -ixoff

# local .zshrc aliases
source ~/.zshrc_local
