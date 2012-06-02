# aliases

# normal aliases
alias angband="angband -mgcu -umuflax"
alias avg="noglob average_damage.rb"
alias cal="cal -m -3"
alias cgrep="grep --color=always"
alias diff="colordiff"
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

# emacs
alias e="emacsclient -nw -a vim"
alias se="sudo -e"
alias ee="emacsclient -c -n -a vim"
alias em="emacs-gui"
alias evil="for s in {1..3}; do echo -n 'VI! '; sleep .7; done; echo; e"
alias vi="evil" # brainwashing

# youtube download
function y() {
  echo "Paste links, ^D start to download."
  youtube-dl --ignore-errors --continue --rate-limit 2.5m -o "$HOME/youtube/%(title)s-%(id)s.%(ext)s" -a-
}

# portage
alias cdl="cd /usr/local/portage/local"
alias dew="sudo FEATURES=distcc emerge -auD --changed-use --binpkg-respect-use y --with-bdeps y world"
alias ew="sudo emerge -auD --changed-use --binpkg-respect-use y --with-bdeps y world"
alias ec="sudo eclean -d -t2w distfiles; sudo eclean -d -t2w packages"
alias ecc="sudo eclean -d distfiles; sudo eclean -d packages"
alias wg="watch genlop -nc"
alias us="sudo ~/in/scripts/update_system"

# java
alias burnburnBURN="rm -f *.class; javac *.java"

# c
alias co="./configure"

# python
alias p2="python"
alias p3="python3"
alias p="python3"
alias pe="perl"

# ruby stuff
alias ru="ruby"
alias i="irb -rrange_math"
alias cdg="cd $(gem environment gemdir)/gems"

# bayescraft
alias post="noglob posterior"

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
#alias wake_azathoth="wakeonlan 00:18:E7:16:6F:C5"
alias wake_azathoth="wakeonlan 00:1E:8C:45:D2:90"
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

# torrent
alias tor="sudo mount.cifs //192.168.1.102/torrent /mnt/network/torrent-samba -o guest,uid=1000,gid=1006"
alias nor="sudo umount /mnt/network/torrent-samba"
alias toto="scp ~/*.torrent totenkopf@ming:/home/totenkopf/torrent/.torrents/ && rm ~/*.torrent" 

# lolshell
alias cya='sudo reboot'
alias kthxbai='sudo shutdown -h now'

