# aliases

# default options
alias angband="angband -mgcu -umuflax"
alias avg="noglob average_damage.rb"
alias cal="cal -m -3"
alias less="less -i"
alias mc="mc -x"
alias mkdir="mkdir -p"
alias mmv="noglob zmv -W"
alias sed="sed -r"

# command replacements
alias diff="colordiff"

# shortcuts
alias my="sudo chown amon:amon"
alias x="chmod +x"
alias po="popd"
alias le="less"

# grep
alias bgrep="command grep -P"
alias cgrep="bgrep --color=always"
alias ngrep="bgrep --color=auto"
alias grep="ngrep"
alias g="grep"
alias cg="cgrep"
alias ng="ngrep"

# watch
alias watch="watch -c"
alias w="watch.rb"
function wi() {
  watch.rb --changes . $*
}

function u() {
  echo $* | "normalize"
}

function um() {
  for d in $*; do
    mv $d $(u $d)
  done
}

# background programs
function ok()  { okular              $* >/dev/null 2>/dev/null &! }
function li()  { libreoffice         $* >/dev/null 2>/dev/null &! }
function ff()  { firefox             $* >/dev/null 2>/dev/null &! }
function fft() { firefox -new-tab    $* >/dev/null 2>/dev/null &! }
function ffw() { firefox -new-window $* >/dev/null 2>/dev/null &! }
function ge()  { geeqie              $* >/dev/null 2>/dev/null &! }
function me()  { meld                $* >/dev/null 2>/dev/null &! }
function z()   { zathura             $* >/dev/null 2>/dev/null &! }
function com() { mcomix              $* >/dev/null 2>/dev/null &! }

# ls
alias ls="ls --color=always --group-directories-first -v"
alias l="ls -L"
alias ll="ls -lhL"
alias lh="ls -lh"
alias lss="ls -lhS"
alias lsr="ls -lhSr"

# update local gems
function bu() {
  (cd ~/.bundle; bundle update && bundle clean --force)
}
function bui() {
  (cd ~/.bundle; bundle install --binstubs)
}

# unison
alias unison="unison -log=false -auto -ui=text -times"
alias uk='unison -fat kindle'
alias uep="sudo unison -log=false -auto -ui=text -times portage"

# sync computers
alias un="sync_computers"
alias unm="sync_computers --fast"

# git
function git_branch() {
  local ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
  echo ${ref#refs/heads/}
}

function git_path() {
  local p=$(command git rev-parse --show-toplevel 2> /dev/null) || return
  echo $p
}

# gist
alias gist="jist -t $(git config github.oauth-token)"

# git-annex abbrevs
alias ga="git-annex"
alias gas="git-annex sync"
alias gass="git_annex_sync.sh"
alias gai="git-annex info"
alias gast="git-annex status"
alias gaw="git-annex whereis"
alias gac="git-annex add . && git commit -m 'update'"
alias gaco="git-annex copy"
alias gamo="git-annex move"
alias gaa="git-annex add"
alias gau="git-annex unlock"
alias gal="git-annex lock"
alias get="git-annex get"
alias geta="git-annex get --auto"
alias gets="git_annex_auto.sh"
alias drop="git-annex drop"
alias dropa="git-annex drop --auto"
alias gadu="git-annex unused"
alias gadun="git-annex dropunused"
alias gaduna="git-annex dropunused 1-10000 --force"

# common tasks
alias c="git clone --recursive"
alias cr="git remote add"
alias gam="git merge synced/master"
alias gacop="git-annex copy --to pleonasty --not --in pleonasty"
alias gamop="git-annex move --to pleonasty"
alias gaco-glacier="git-annex copy --to glacier --not --in glacier"
alias gdud="gdu -hs *(/)"
alias gdudl="gdu -hsL *(/)"
alias dropg="git-annex drop --trust-glacier"
alias unglaciered='for file in $(ga find --not --in glacier); do echo $file | sed -e "s,/.+,,"; done | sort | uniq -c'
alias gawd="git-annex find --want-drop --in here"
alias gawg="git-annex find --want-get --not --in here"

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

# shrink pdfs
function shrink() {
  for pdf in $*; do
    echo "shrinking ${pdf}..."
    pdf2ps $pdf ${pdf:r}.ps && ps2pdf ${pdf:r}.ps ${pdf:r}_shrunk.pdf && tp ${pdf:r}.ps
  done
}

# tmux
alias scratchpad="tm scratchpad"
function tm() {
  if [[ $# -ge 1 ]]; then
    tmux attach -t $1 || tmux new-session -s $1 \; bind c neww -c "$(pwd)"
  else
    tmux new-session \; bind c neww -c "$(pwd)"
  fi
}
alias tma="tmux attach-session"

# emacs
alias e="emacs-cli"
alias ee="emacs-gui"
if [[ -e $(which emacs-24) ]]; then
  function em() { emacs-24 $* &! }
else
  function em() { emacs $* &! }
fi

# youtube download
function y() {
  local y_path="$HOME/youtube"

  if [[ $1 != "" ]]; then
    y_path=$1
  fi

  echo "Paste links, ^D to start the download. Saving in: ${y_path}"
  youtube-dl --ignore-errors --max-quality 22 --continue --no-overwrites --rate-limit 2.5m -o "${y_path}/%(title)s-%(id)s.%(ext)s" -a-
}

# portage
alias ew="sudo emerge -au --changed-use --binpkg-respect-use y world"
alias eww="sudo emerge -auD --binpkg-respect-use y --with-bdeps y world"
alias ewn="sudo emerge -auD --changed-use --binpkg-respect-use y --with-bdeps y world"
alias ec="sudo eclean -t 1w packages && sudo eclean -t 1w distfiles"
alias ecc="sudo eclean -d -t 1w packages && sudo eclean -d -t 1w distfiles"
alias wg="watch genlop -c"

# c
alias co="./configure"
alias cop="./configure --prefix=$HOME/local"
alias tagify-c="ctags -eR ."

# python
alias p2="python2"
alias p3="python3"

# ruby stuff
alias ru="ruby"
alias i="pry"
alias tagify-ruby="ripper-tags -R --exclude=vendor --emacs"
alias tags="tagify-ruby"

# universal aliases
alias -g DN='>/dev/null 2>/dev/null'
alias -g D0='DISPLAY=:0.0'
alias -g D1='DISPLAY=:0.1'
alias -g LC='LANG=C'
alias -g LE='LANG=en_US.UTF-8'
alias -g LJ='LANG=ja_JP.UTF-8'
alias -g L='| less'

# suspend-to-ram
function ss() {
  sudo ~/src/scripts/suspend $*
}

# move target to location and create symbolic link
function mvln() {
  mv $1 $2/ && ln -s $2/$1 $1
}

# a bit of security; use /bin/cp etc. to overwrite stuff
alias cp="cp -i"
alias mv="mv -i"

# trash
alias te=trash-empty
alias tp=trash-put
alias tl=trash-list

# mplayer
alias m="mw -l"
alias r="mw -r"

# wine
alias ewine="wine explorer /desktop=foo${RANDOM},1024x768"
alias newine="nice wine explorer /desktop=foo${RANDOM},1024x768"

# monitors on/off
alias don="D0 xset dpms force on"
alias doff="D0 xset dpms force off"
alias dstayon="don; D0 xset s off; D0 xset -dpms"

# ssh
alias nyash="ssh -C amon@nyarlathotep"
alias tysh="ssh  -C amon@typhus"
alias nash="ssh  -C amon@pleonasty"
alias scash="ssh -C amon@scabeiathrax"
alias scab="scash"  # more elegant
alias plesh="ssh -C amon@pleonasty"

# executing stuff over ssh
alias nyashc="ssh -C amon@nyarlathotep -- zsh -l -c --"
alias tyshc="ssh  -C amon@typhus       -- zsh -l -c --"
alias nashc="ssh  -C amon@pleonasty    -- zsh -l -c --"
alias scashc="ssh -C amon@scabeiathrax -- zsh -l -c --"
alias scabc="scashc"
alias pleshc="ssh -C amon@pleonasty    -- zsh -l -c --"

# lolshell
alias cya='sudo reboot'
alias kthxbai='sudo shutdown -h now'
alias aaaaaaaaah="ff 'file:///home/amon/pigs/explosion bird.gif'"

# totally useful sound effects
alias s_holycrap="m --really-quiet ~/local/sounds/holycrap.ogg DN"
alias s_mail="m --really-quiet ~/local/sounds/mail.ogg DN"
alias s_max="m --really-quiet ~/local/sounds/max.ogg DN"
alias s_min="m --really-quiet ~/local/sounds/min.ogg DN"
alias s_oops="m --really-quiet ~/local/sounds/oops.ogg DN"
alias s_quit="m --really-quiet ~/local/sounds/quit.ogg DN"
alias s_startup="m --really-quiet ~/local/sounds/startup.ogg DN"

# play appropriate sound
function s_ok() {
  if [[ $? == 0 ]]; then
    s_max
  else
    s_min
  fi
}

# full version
function up() {
  # sync etc
  uep

  # sync local repo
  (cd ~plocal; git pum && git push)

  # sync external repos
  layman -S
  sudo emerge --sync

  # eix
  eix-update
}

# minimal version
function upm() {
  # sync local repo
  (cd ~plocal; git pum && git push)

  # eix
  eix-update
}

# dropbox
alias dcs="dropbox-cli status"
alias dcfs="dropbox-cli filestatus"
alias dcst="dropbox-cli start"

# pack folder
function pack-7z() {
  for dir in $*; do
    echo "packing $dir..."
    7z -mx9 a $dir.7z $dir && tp $dir
  done
}
function pack-tar() {
  for dir in $*; do
    echo "packing $dir..."
    tar -vczf $dir.tar.gz $dir && tp $dir
  done
}
alias pack="pack-7z"

# treat each new line as an item
alias each_line="perl -lne 'print quotemeta'"
alias EL="each_line"

# bundler
bundler-installed() {
  which bundle > /dev/null 2>&1
}

within-bundled-project() {
  local check_dir=$PWD
  while [ $check_dir != "/" ]; do
    [ -f "$check_dir/Gemfile" ] && return
    check_dir="$(dirname $check_dir)"
  done
  false
}

run-with-bundler() {
  if bundler-installed && within-bundled-project; then
    bundle exec $@
  else
    $@
  fi
}

bundled_commands=(guard nanoc rails rake rspec ruby spec)
for cmd in $bundled_commands; do
  eval "function bundled_$cmd () { run-with-bundler $cmd \$@}"
  alias $cmd=bundled_$cmd

  if which _$cmd > /dev/null 2>&1; then
    compdef _$cmd bundled_$cmd=$cmd
  fi
done

# full todo list
alias t="noglob todo.sh -d ~/.todo.cfg"
alias ta="t add"
alias td="t do"
alias trm="t rm"

# only what is relevant today
alias now="noglob todo.sh -d ~/.todo-today.cfg"
alias n="now"
alias na="now add"
alias nd="now do"
alias nrm="now rm"

# file tagging
alias rr="tag_filename -t read"
alias ur="tag_filename -t !read"
alias ut="tag_filename -t !"

# lock laptop overnight
function nighto() {
  # lock mouse so random disturbances / the cat don't turn on the screen
  toggle_mouse.rb

  # wait a bit before turning off the screen so I can close the lid
  sleep 5; doff

  # lock screen
  slock

  # get mouse back
  toggle_mouse.rb
}

# reload file
alias res="source ~/.zshrc"

# go
[[ -e $(which colorgo) ]] && alias go=colorgo

# du
alias d0="du -hs"
alias d1="du -h -d1 | sort -h"

# df
alias dh="df -h"

# sum a column
alias sum="paste -sd+ | bc"

# iptables toggle
function ipt() {
  local ipt_status=$(sudo /etc/init.d/iptables status | grep -oP --color=never "(start|stop)")
  case $ipt_status in
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

# basic wget scraper
alias scrape="wget --mirror --continue -e robots=off --convert-links --page-requisites --timestamping"

# get random stuff from the internet
function gst() {
  pod
  fetch_repos.sh

  gass
}

# some alternative constructions to make shell scripts less obscure
alias and='[[ $? == 0 ]] && '
alias or='[[ $? == 0 ]] || '
function exists() {
  local t=0
  for f in $*; do [[ -e $f ]] || t=1; done
  return $t
}
