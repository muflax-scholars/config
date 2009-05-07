###################        
# Options for zsh #
###################

export HISTFILE=~/.zsh_history
export HISTSIZE=3000
export SAVEHIST=3000

autoload -U compinit zmv 
compinit

setopt autopushd pushdminus pushdsilent pushdtohome
#setopt cdablevars
#setopt ignoreeof
setopt interactivecomments
#setopt noclobber

setopt NOBANGHIST
setopt HIST_REDUCE_BLANKS
#setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
#setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY

setopt SH_WORD_SPLIT
setopt NOHUP
setopt EXTENDEDGLOB
setopt NEO

setopt NO_CHASE_LINKS
setopt NO_CHASE_DOTS

# PS1 and PS2
export PS1="$(print '%{\e[0;32m%}%n@%m%{\e[0m%}') $(print '%{\e[0;36m%}%~%{\e[0m%}') # "
export PS2="$(print '%{\e[0;32m%}>%{\e[0m%}')"

# Vars used later on by zsh
export EDITOR="vim"
export VISUIAL="vim"

# universal options

export MPD_HOST="192.168.1.15"
export MOZ_DISABLE_PANGO="1"
export MBOX="/dev/null"
export PYTHONDOCS="/usr/share/doc/python/html/"

case "${TERM}" in
    linux)
        export LANG=C
        ;;
    *)
        export LANG=ja_JP.UTF-8
        ;;
esac

#really necessary?
LS_COLORS='no=00:fi=00:di=00;36:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:';
export LS_COLORS

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
}

# preexec is called just before any command line is executed
function preexec() {
  title "$1" "$USER@%m"
}

##############
# Completion #
##############

# allow approximate
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

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
zstyle ':completion:*' cache-path ~/.zsh/cache

################
# Key bindings #
################
bindkey -e 
bindkey '^[[3~' delete-char
bindkey '[1~' beginning-of-line
bindkey '^[[4~' end-of-line
bindkey '^[[5~' beginning-of-history
bindkey '^[[6~' end-of-history
# completion in the middle of a line
bindkey '^i' expand-or-complete-prefix

###########
# aliases #
###########

# Normal aliases
alias ls="ls --color=always --group-directories-first"
alias grep="grep --color=always"
alias vi="vim -p"
alias md="mkdir -p"
alias po="popd"
alias s="screen"
alias less="less -iF" 
alias mc="mc -x"
alias weechat="weechat-curses"

alias -g DN='&> /dev/null'
alias -g D0='DISPLAY=:0.0'
alias -g D1='DISPLAY=:0.1'
alias -g LC='LANG=C'
alias -g LJ='LANG=ja_JP.UTF-8'
alias -g L='| less'
alias -g G='| grep'
alias -g GP='| grep --color=auto'
 
alias wake_totenkopf="wakeonlan 00:18:E7:16:6F:C5"
alias wake_mummra="wakeonlan 00:12:79:DE:C7:2C"

alias mish="ssh totenkopf@ming"
alias mush="ssh amon@mumm-ra"

function ss() {purple-remote 'setstatus?status=offline' DN; sudo /usr/local/sbin/suspend $*; purple-remote 'setstatus?status=available' DN}

alias lock="D0 xlock -mode mandelbrot -dpmsoff 3600 -echokeys DN"

alias xclip="xclip -selection clipboard"

alias cal="cal -m -3"

alias t="noglob todo.sh -d ~/.todo.cfg"
alias weight="~/src/in/status/status.py -w"

alias vr='mencoder "mf://*.jpg" -mf fps=5 -o $(date +%Y-%m-%d).mp4 -ovc lavc -lavcopts vcodec=mpeg4 -vf scale=500 && ln -fs $(date +%Y-%m-%d).mp4 latest.mp4 && rm *.jpg'

alias p="/usr/bin/python3"
alias p2="/usr/bin/python"
alias p3="/usr/bin/python3"

function maim() { for x in $*; do gcc -O2 -g -Wall -Werror "${x}" -o "$(basename "$x" .c)"; done; }
alias burnburnBURN="rm -f *.class; javac *.java"

alias tor="curlftpfs -o uid=`id -u` -o gid=`id -g`  192.168.1.102/torrent /mnt/network/torrent-ftp/"
alias nor="fusermount -u /mnt/network/torrent-ftp"

alias toto="scp ~/*.torrent totenkopf@ming:/home/totenkopf/torrent/torrents/ && rm ~/*.torrent" 

alias ewine="wine explorer /desktop=foo,1024x768"
alias newine="nice wine explorer /desktop=foo,1024x768"

function nap() {
    ssh amon@mumm-ra 'DISPLAY=:0.0 xset dpms force off' DN
    mpc --no-status pause
    echo "お休みなさい。。。"
    DISPLAY=:0.0 xset dpms force off
    sleep 22m && {
        echo "(^オ^)(^ハ^)(^ヨ^)(^ウ^)(^ー^)"
        amixer -q set Software 85%
        boodler.py -o alsa com.eblong.zarf.computing/MultiComputing DN
    }
}

function tb() {
    for t in $(seq $1 -1 1)
    do
        echo "残り${t}分。。。"
        sleep 1m
    done
    echo "＼(^o^)／やった〓！！！"
    mplayer ~/.timeboxing > /dev/null
}

function watch() {
    if [[ $# -ge 2 && $1 == [[:digit:]] ]] then 
        while (clear); do $*[2,$#]; sleep $1; done;
    else 
        while (clear); do $*; sleep 1; done;
    fi
}

alias mmv="noglob zmv -W"

alias don="D0 xset dpms force on"
alias doff="D0 xset dpms force off"

alias up="abs && sudo pacman -Sy && ~/src/in/randomstuff/lrp.py && \
          echo 'press any key to continue or press no key to wait forever' && read && \
          ~/src/in/randomstuff/lrp.py --build && yaourt -Syu --aur && sudo pacman --noconfirm -Sc"
alias cdl="cd /usr/local/src/abs/local"

# LOL!!k!
alias wtf='dmesg'
alias ohnoes='cat /var/log/errors.log'
alias rtfm='man'

alias visible='echo'
alias invisible='cat'
alias moar='less'

alias icanhas='mkdir'
alias donotwant='rm'
alias dowant='cp'
alias gtfo='mv'
alias hai='cd'

alias nomnom='killall'
alias cya='sudo reboot'
alias kthxbai='sudo shutdown -h now'

########################
# local .zshrc aliases #
########################
source ~/.zshrc_local

#if [ ! $TERM = "screen" ]; then 
#    exec screen
#fi
