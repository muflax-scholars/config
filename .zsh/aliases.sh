# aliases

# normal aliases
alias angband="angband -mgcu -umuflax"
alias avg="noglob average_damage.rb"
alias cal="cal -m -3"
alias cgrep="grep --color=always"
alias diff="colordiff"
alias grep="grep --color=auto -P"
alias less="less -iF" 
alias mc="mc -x"
alias mkdir="mkdir -p"
alias mmv="noglob zmv -W"
alias po="popd"
alias unc="uncrustify --no-backup -c ~/.uncrustify.cfg"

# shortcuts for common tools
function ok() { okular $* 2>&1 >/dev/null &! }
function li() { libreoffice $* 2>&1 >/dev/null &! }

# ls
alias ls="ls --color=always --group-directories-first -v"
alias l="ls -L"
alias ll="ls -lhL"
alias lh="ls -lh"
alias lss="ls -lhS"
alias lsr="ls -lhSr"

# unison
alias unison="unison -log=false -auto -ui=text -times"
alias uk='unison -fat kindle'
alias ua='unison -fat -prefer /home/amon/spoiler/anki/muflax/ android-anki'
alias un='unison home'
alias unm='unison home-minimal'
alias ur='unison local-repo'
alias uep='sudo unison portage -times -log=false -auto -ui=text'
alias uo='unison ongaku'
alias udipa='sudo unison dipa -times -log=false -auto -ui=text -prefer newer -batch'

# gist
alias gist="jist -t $(git config github.oauth-token)"

# git-annex abbrevs
alias ga="git-annex"
alias gas="git-annex sync"
alias gast="git-annex status"
alias gag="git-annex get"
alias gaga="git-annex get --auto"
alias gad="git-annex drop"
alias gada="git-annex drop --auto"
alias gaw="git-annex whereis"
alias gac="git-annex copy"
alias gam="git-annex move"
alias gaa="git-annex add"
# easier to remember
alias get="git-annex get"
alias geta="git-annex get --auto"
alias drop="git-annex drop"
alias dropa="git-annex drop --auto"
# push new stuff into archive mode
alias gp="git-annex sync; git-annex add . ; git-annex sync"
# update archive
alias gu="git-annex sync ; git-annex get --auto"
# clean up and minimize disk usage
alias gc="git-annex sync ; git-annex dropunused && git-annex drop --auto"

function ga-new() {
  echo "Label?" && read $label
  git init
  git-annex init "$label"
  echo "defaulting to direct mode, semitrust, 2 copies (see .gitattributes) and 100m reserve..."
  git-annex direct
  git config add annex.diskreserve "100m"
  echo "* annex.numcopies=2" > .gitattributes
  git add .gitattributes
  git commit -m "init repo"
}

# beeminder stuff
alias bot="beeminder_org_todo.rb"
alias bota="beeminder_org_todo.rb -a"

# shrink pdfs
function shrink() {
  for pdf in $*; do
    echo "shrinking ${pdf}..."
    pdf2ps $pdf ${pdf:r}.ps && ps2pdf ${pdf:r}.ps ${pdf:r}_shrunk.pdf && rm ${pdf:r}.ps
  done
}

# tmux
alias scratchpad="tm scratchpad"
function tm() {
  if [[ $# -ge 1 ]] then 
    tmux attach -t $1 || tmux new-session -s $1 \; set default-path "$(pwd)" \; set -g -a update-environment ' PWD'
  else
    tmux new-session \; set default-path "$(pwd)" \; set -g -a update-environment ' PWD'
  fi
}
alias tma="tmux attach-session"

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
  youtube-dl --ignore-errors --max-quality 22 --continue --rate-limit 2.5m -o "$HOME/youtube/%(title)s-%(id)s.%(ext)s" -a-
}

# portage
alias cdl="cd /usr/local/portage/local"
alias ew="sudo emerge -au --changed-use --binpkg-respect-use y world"
alias eww="sudo emerge -auD --binpkg-respect-use y --with-bdeps y world"
alias ewn="sudo emerge -auD --changed-use --binpkg-respect-use y --with-bdeps y world"
alias ec="sudo eclean -d -t2w distfiles && sudo eclean -d -t2w packages"
alias ecc="sudo eclean -d distfiles && sudo eclean -d packages"
alias wg="watch genlop -nc"
alias us="sudo ~/in/scripts/update_system"

# java
alias burnburnBURN="rm -f *.class; javac *.java"

# c
alias co="./configure"
alias tagify="ctags -eR ."

# python
alias p2="python"
alias p3="python3"
alias p="python3"
alias pe="perl"

# ruby stuff
alias ru="ruby"
alias i="pry"
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
alias m="mw -l"
alias r="mw -r"

# wake-on-lan
#alias wake_azathoth="wakeonlan 00:18:E7:16:6F:C5"
alias wake_azathoth="wakeonlan 00:1E:8C:45:D2:90"
alias wake_totenkopf="wakeonlan 00:50:04:42:99:6F"
alias wake_typhus="wakeonlan 00:19:d2:c4:45:0d"

# wine
alias ewine="wine explorer /desktop=foo${RANDOM},1024x768"
alias newine="nice wine explorer /desktop=foo${RANDOM},1024x768"

# monitors on/off
alias don="D0 xset dpms force on"
alias doff="D0 xset dpms force off"

# ssh
alias mish="ssh totenkopf@ming"
alias azash="ssh -C amon@azathoth"
alias nyash="ssh -C amon@nyarlathotep"
alias tysh="ssh -C amon@typhus"

# torrent
alias tor="sudo mount.cifs //192.168.1.102/torrent /mnt/network/torrent-samba -o guest,uid=1000,gid=1006"
alias nor="sudo umount /mnt/network/torrent-samba"
alias toto="scp ~/*.torrent totenkopf@ming:/home/totenkopf/torrent/.torrents/ && rm ~/*.torrent" 

# lolshell
alias cya='sudo reboot'
alias kthxbai='sudo shutdown -h now'

