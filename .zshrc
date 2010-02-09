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
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY

setopt SH_WORD_SPLIT
setopt NOHUP
setopt EXTENDEDGLOB
setopt INTERACTIVECOMMENTS
setopt PROMPT_SUBST

setopt NO_CHASE_LINKS
setopt NO_CHASE_DOTS

setopt LIST_PACKED
setopt CORRECT
setopt HASH_LIST_ALL

# non-zsh
export EDITOR="vim"
export VISUIAL="vim"
export MPD_HOST="192.168.1.15"

case "${TERM}" in
    linux)
        export LANG=C
        ;;
    *)
        export LANG=ja_JP.UTF-8
        ;;
esac

export PATH="$HOME/local/bin:$PATH"

LS_COLORS='no=00:fi=00:di=00;36:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:';
export LS_COLORS

################################
# let's make an awesome prompt #
################################
autoload colors
if [[ "${terminfo[colors]}" -ge 8 ]] then
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
if [ -z "$SSH_CONNECTION" ]; then
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
if [[ $MC_SID != "" ]] then
    local mc=" ${op}%{$fg[cyan]%}°_°%{$reset_color%}${cp}"
fi

# current path
local path_p=" ${op}%{$fg[cyan]%}%~%{$reset_color%}${cp}"

# current VCS status
local vcs='$vcs_info_msg_0_'
# smiley based on return status
local smiley="${op}%(?,%{$fg[red]%}<3%{$reset_color%},%{$fg_bold[red]%}>3 ($?%)%{$reset_color%})${cp}"
# last command, used in PS2
local cur_cmd="${op}%_${cp}"

PROMPT="${date}${path_p}${vcs}${user_host}${arch}
${smiley}${mc} # "
PROMPT2="${cur_cmd}> "


##########################################################################
#                             title handling                             #
# (by _why, with path removed because SCREEN IS STILL NOT UNICODE AWARE) #
##########################################################################

# format titles for screen and rxvt
function title() {
  # escape '%' chars in $1, make nonprintables visible
  a=${(V)1//\%/\%\%}

  # Truncate command, and join lines.
  a=$(print -Pn "%40>...>$a" | tr -d "\n")

  case $TERM in
  screen*)
    print -Pn "\ek$a$3\e\\"      # screen title (in ^A")
    ;;
  xterm*|rxvt*)
    print -Pn "\e]2;$2 | $a$3\a" # plain xterm title
    ;;
  esac
}

# precmd is called just before the prompt is printed
function precmd() {
  title "zsh" "$USER@%m"
  vcs_info 'prompt'
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

# automagically escape urls
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

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
alias a="ashuku add"
alias angband="TERM=rxvt-unicode256 angband -mgcu -umuflax -- -a -m"
alias aria2c="aria2c -c --summary-interval=0 --check-certificate=false"
alias burnburnBURN="rm -f *.class; javac *.java"
alias cal="cal -m -3"
alias cdl="cd /usr/local/portage/local"
alias diff="colordiff"
alias evil="vi"
alias ew="sudo emerge -auD --reinstall changed-use world"
alias grep="grep --color=always"
alias less="less -iF" 
alias ls="ls --color=always --group-directories-first"
alias mc=". /usr/libexec/mc/mc-wrapper.sh -x -d"
alias mkdir="mkdir -p"
alias mmv="noglob zmv -W"
alias ngrep="grep --color=none"
alias p2="/usr/bin/python"
alias p3="/usr/bin/python3"
alias p="/usr/bin/python3"
alias po="popd"
alias rename="/usr/bin/perlbin/vendor/rename"
alias s="ashuku show"
alias ss="sudo ~/local/bin/suspend"
alias t="noglob todo.sh -d ~/.todo.cfg"
alias vi="vim -p"
alias weechat="weechat-curses"

# wake-on-lan
alias wake_azathoth="wakeonlan 00:12:79:DE:C7:2C"
alias wake_totenkopf="wakeonlan 00:18:E7:16:6F:C5"

# wine
alias ewine="wine explorer /desktop=foo,1024x768"
alias newine="nice wine explorer /desktop=foo,1024x768"

# monitors on/off
alias don="D0 xset dpms force on"
alias doff="D0 xset dpms force off"

# mplayer
for i in $(seq 5) 
do
    a=""
    for j in $(seq $i) 
    do
        a="${a}a"
    done
    alias "m${a}f"="D0 mplayer -af volume=$(( 5 * $i ))"
done

# ssh
alias mish="ssh totenkopf@ming"
alias azash="ssh amon@azathoth"
alias nyash="ssh amon@nyarlathotep"

# universal aliases
alias -g DN='&> /dev/null'
alias -g D0='DISPLAY=:0.0'
alias -g D1='DISPLAY=:0.1'
alias -g LC='LANG=C'
alias -g LJ='LANG=ja_JP.UTF-8'
alias -g L='| less'
alias -g G='| grep'
alias -g GP='| grep --color=auto'

# functions
function go() {
    TIC=$(date "+%s")
    echo "真っ直ぐゴー!!"
    read -s
    TOC=$(date "+%s")
    TIME=$(( ($TOC - $TIC) / 60 ))
    if [[ $TIME -gt 0 ]] then
        if [[ $# -ge 1 ]] then
            ashuku add "$1" "${TIME}m"
        else
            echo "時間：${TIME}分"
        fi
    fi
}

function ipt() {
    S=$(/etc/init.d/iptables status | ngrep -oP "(start|stop)")
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
    # check last nap time and make sure it is at least 3 hours ago
    if [[ -e /tmp/last_nap ]] then
        LAST_NAP=$(cat /tmp/last_nap)
        if [[ $(( $(date "+%s") - $LAST_NAP )) -lt $(( 3*60*60 )) ]] then
            echo "Anti-Snooze warning! Nap forbidden."
            ossmix -q vmix0-outvol 22
            ~/.wakeup.sh
            slock
            return
        fi
    fi
    ssh amon@mumm-ra 'DISPLAY=:0.0 xset dpms force off' DN
    mpc --no-status pause
    echo "お休みなさい。。。"
    doff
    
    # remember last nap time
    date "+%s" > /tmp/last_nap
    
    if [[ $# -ge 1 && $1 == [[:digit:]]## ]] then 
        sleep ${1}m
    else 
        sleep 25m
    fi && {
        echo "b(・ｏ・)dおw(・0・)wはぁで(・＜＞・)まよｃ(^・^)っちゅ"
        ossmix -q vmix0-outvol 22
        ~/.wakeup.sh
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
alias tor="sudo mount.cifs //192.168.1.102/torrent /mnt/network/torrent-samba -o guest,uid=1000"
alias nor="sudo umount.cifs /mnt/network/torrent-samba"
alias toto="scp ~/*.torrent totenkopf@ming:/home/totenkopf/torrent/torrents/ && rm ~/*.torrent" 
function tomo() {
    I=0
    LIST=($(transmission-remote ming -l | ngrep -P '^\s*\d+\s*100%' | ngrep -o -P '^\s*\d+'))
    for x in $LIST
    do 
        transmission-remote ming -t $x --move /home/totenkopf/torrent/done/ > /dev/null
        if [ $? -eq 0 ]; then
            I=$(( $I + 1 ))
        fi
    done
    echo "${I}/${#LIST} moved."
}

# LOL!!k!
alias cya='sudo reboot'
alias donotwant='rm'
alias dowant='cp'
alias gtfo='mv'
alias hai='cd'
alias icanhas='mkdir'
alias invisible='cat'
alias kthxbai='sudo shutdown -h now'
alias moar='less'
alias nomnomnom='killall'
alias ohnoes='sudo cat /var/log/errors.log'
alias rtfm='man'
alias visible='echo'
alias wtf='dmesg'

# local .zshrc aliases
source ~/.zshrc_local
