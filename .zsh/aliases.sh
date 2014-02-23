# aliases

# default options
alias agrep="command grep -P --color=auto"
alias angband="angband -mgcu -umuflax"
alias avg="noglob average_damage.rb"
alias cal="cal -m -3"
alias grep="command grep -P --color=always"
alias less="less -iF"
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
alias g="grep"
alias ag="agrep"
alias cg="\ag"
alias le="less"

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
function d()   { dolphin             $* >/dev/null 2>/dev/null &! }

# ls
alias ls="ls --color=always --group-directories-first -v"
alias l="ls -L"
alias ll="ls -lhL"
alias lh="ls -lh"
alias lss="ls -lhS"
alias lsr="ls -lhSr"

# repo update
alias mrr="mr register"
alias mup="mr -j5 update"

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

# only sync files
function unm() {
  # because unison doesn't accept two remote hosts, we just figure out the partner this way
  case $(hostname) in
    typhus)
      host=scabeiathrax
      ;;
    scabeiathrax)
      host=typhus
      ;;
  esac

  unison home -root ssh://$host//home/amon
}

# also sync configs etc.
function un() {
  (cd ~; git pum && git push)
  ~/spoiler/sync.sh
  unm
  git_annex_sync.sh
  git_annex_auto.sh
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
alias gam="git merge synced/master"
alias gacop="git-annex copy --to pleonasty --not --in pleonasty"
alias gamop="git-annex move --to pleonasty"
alias gaco-glacier="git-annex copy --to glacier --not --in glacier"
alias gdud="gdu -hs *(/)"
alias gdudl="gdu -hsL *(/)"

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
alias e="emacs"
alias ee="emacs-gui"
if [[ -e $(which emacs-24) ]]; then
  function em() { emacs-24 $* &! }
else
  function em() { emacs $* &! }
fi
alias evil="for s in {1..3}; do echo -n 'VI! '; sleep .7; done; echo; vi"

# youtube download
function y() {
  echo "Paste links, ^D to start the download."
  youtube-dl --ignore-errors --max-quality 22 --continue --rate-limit 2.5m -o "$HOME/youtube/%(title)s-%(id)s.%(ext)s" -a-
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
alias p2="python"
alias p3="python3"
alias p="python3"
alias pe="perl"

# ruby stuff
alias ru="ruby"
alias i="pry"
alias tagify-ruby="ripper-tags -R --exclude=vendor --emacs"
alias tags="tagify-ruby"

# bayescraft
alias post="noglob posterior"

# universal aliases
alias -g DN='>/dev/null 2>/dev/null'
alias -g D0='DISPLAY=:0.0'
alias -g D1='DISPLAY=:0.1'
alias -g LC='LANG=C'
alias -g LE='LANG=en_US.UTF-8'
alias -g LJ='LANG=ja_JP.UTF-8'
alias -g L='| less'
alias -g G='| grep'
alias -g CG='| grep --color=always'

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

# mplayer
alias m="mw -l"
alias r="mw -r"

# wine
alias ewine="wine explorer /desktop=foo${RANDOM},1024x768"
alias newine="nice wine explorer /desktop=foo${RANDOM},1024x768"

# monitors on/off
alias don="D0 xset dpms force on"
alias doff="D0 xset dpms force off"

# ssh
alias nyash="ssh -C amon@nyarlathotep"
alias tysh="ssh  -C amon@typhus"
alias nash="ssh  -C amon@pleonasty"
alias scash="ssh -C amon@scabeiathrax"
alias scab="scash"  # more elegant
alias plesh="ssh -C amon@pleonasty"

# lolshell
alias cya='sudo reboot'
alias kthxbai='sudo shutdown -h now'
alias aaaaaaaaah="ff 'file:///home/amon/pigs/explosion bird.gif'"

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
    7z -mx9 a $dir.7z $dir && rm -rf $dir
  done
}
function pack-tar() {
  for dir in $*; do
    echo "packing $dir..."
    tar -vczf $dir.tar.gz $dir && rm -rf $dir
  done
}
alias pack="pack-7z"

# treat each new line as an item
alias each_line="perl -lne 'print quotemeta'"
alias EL="each_line"

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
    echo "b(・o・)dおw(・0・)wはぁで(・<>・)まよc(^・^)っちゅ"
    wakeup.sh
  }
}

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

# dictionaries
alias di="~/src/linguistics/german_dictionaries/our_dict/lookup.rb"

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

# trash instead of rm
alias te=trash-empty
alias tp=trash-put
alias tl=trash-list
alias rm=trash-put
