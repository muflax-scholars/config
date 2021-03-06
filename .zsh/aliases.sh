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
alias wi="watch.rb --changes ."
alias wil="watch.rb --changes . --no-recursive"

function u() {
  echo $* | "normalize"
}

function um() {
  for d in $*; do
    mv $d $(u $d)
  done
}

# background programs
function ok()  { okular             	$* >/dev/null 2>/dev/null &! }
function li()  { libreoffice        	$* >/dev/null 2>/dev/null &! }
function ff()  { firefox            	$* >/dev/null 2>/dev/null &! }
function fft() { firefox -new-tab   	$* >/dev/null 2>/dev/null &! }
function ffw() { firefox -new-window	$* >/dev/null 2>/dev/null &! }
function ge()  { geeqie             	$* >/dev/null 2>/dev/null &! }
function me()  { meld               	$* >/dev/null 2>/dev/null &! }
function z()   { zathura            	$* >/dev/null 2>/dev/null &! }
function com() { mcomix             	$* >/dev/null 2>/dev/null &! }
function no()  { nomacs .           	$* >/dev/null 2>/dev/null &! }

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
  (cd ~/.bundle; bundle install)
}

# unison
alias unison="unison -log=false -auto -ui=text -times"
alias uk='unison -fat kindle'
alias uep="sudo $(which -p unison) -log=false -auto -ui=text -times portage"

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
alias gadu="git-annex unused --unused-refspec '-refs/remotes/*'"
alias gadun="git-annex dropunused"
alias gaduna="git-annex dropunused 1-10000 --force"

# common tasks
alias c="git clone --recursive"
alias cr="git remote add"
alias gacop="git-annex copy --to pleonasty --not --in pleonasty"
alias gamop="git-annex move --to pleonasty"
alias gaco-glacier="git-annex copy --to glacier --not --in glacier"
alias gamo-glacier="git-annex move --to glacier"
alias gdud="gdu -hs *(/)"
alias gdudl="gdu -hsL *(/)"
alias unglaciered='for file in $(ga find --not --in glacier); do echo $file | sed -e "s,/.+,,"; done | sort | uniq -c'
alias ggg="gaco-glacier .; gacop .; gas"

function ginit() {
  if [[ -e .git || -e .gitignore ]]; then
    return
  fi

  git init \
    && touch .gitignore \
    && git add .gitignore \
    && git commit -m "init"
}

function c-org() {
  for org in $*; do
    for repo in $(curl -s "https://api.github.com/orgs/$org/repos?per_page=200" \
                     | ruby -r json -e 'JSON.load(STDIN.read).each { |repo| puts repo["ssh_url"] }' \
                     | sort -u)
    do
      c $repo
    done
  done
}


# shrink pdfs
function shrink() {
  for pdf in $*; do
    echo "shrinking ${pdf}..."
    pdf2ps $pdf ${pdf:r}.ps && ps2pdf ${pdf:r}.ps ${pdf:r}_shrunk.pdf && trash-put ${pdf:r}.ps
  done
}

# tmux
alias scratchpad="tm scratchpad"
function tm() {
  local shell="PWD=$(pwd) zsh"

  if [[ $# -ge 1 ]]; then
    tmux attach -t $1 || tmux new-session -s $1 "$shell" \; \
      bind c   neww "$shell" \; \
      bind C-c neww "$shell"
  else
    tmux new-session "$shell" \; \
      bind c   neww "$shell" \; \
      bind C-c neww "$shell"
  fi
}
alias tma="tmux attach-session"

# emacs
alias e="emacs-cli"
alias ee="emacs-gui"
function em() { emacs $* &! }

# youtube download
function y() {
  local y_path="$HOME/youtube"

  if [[ $1 != "" ]]; then
    y_path=$1
  fi

  echo "Paste links, ^D to start the download. Saving in: ${y_path}"
  youtube-dl -o "${y_path}/%(title)s-%(playlist)s-%(playlist_index)s-%(id)s.%(ext)s" -a-
}

# portage
alias ew="sudo emerge -au --changed-use --binpkg-respect-use y @world"
alias eww="sudo emerge -auD --binpkg-respect-use y --with-bdeps y @world"
alias ewn="sudo emerge -auD --changed-use --binpkg-respect-use y --with-bdeps y @world"
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

# remote connection
alias nyash="mosh	amon@nyarlathotep"
alias tysh="mosh 	amon@typhus"
alias nash="mosh 	amon@pleonasty"
alias scash="mosh	amon@scabeiathrax"
alias plesh="mosh	amon@pleonasty"
alias scab="scash" # more elegant

# executing stuff over ssh
alias nyashc="ssh	-C amon@nyarlathotep	-- zsh -l -c --"
alias tyshc="ssh 	-C amon@typhus      	-- zsh -l -c --"
alias nashc="ssh 	-C amon@pleonasty   	-- zsh -l -c --"
alias scashc="ssh	-C amon@scabeiathrax	-- zsh -l -c --"
alias pleshc="ssh	-C amon@pleonasty   	-- zsh -l -c --"
alias scabc="scashc"

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
  sudo layman -S
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
alias dcs="dropbox status"
alias dc="dropbox"
function dcr() {
  dropbox stop
  pidof dropbox && wait_on_pid $(pidof dropbox)
  dropbox start
}

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
alias be="bundle exec"

# full todo list
alias now="noglob todo.sh -d ~/.todo.cfg"
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
alias d0="du -hs -x"
alias d1="du -h -d1 -x | sort -h"

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
alias scrape="wget --mirror --continue -e robots=off --convert-links --page-requisites --timestamping --no-parent"

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

# racket
alias ra="racket"
alias gra="gracket"

# output
alias big="toilet -f standard -t"

# chicken
alias csi="csi -quiet"

# Local Variables:
# mode: sh
# eval: (sh-set-shell "zsh")
# End:
