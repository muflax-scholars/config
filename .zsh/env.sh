# default that exists everywhere
export EDITOR="vi"

if [[ -e $(which emacs-gui) ]]; then
  export EDITOR="emacs-gui-wait"
elif [[ -e $(which emacs) ]]; then
  export EDITOR="emacs"
elif [[ -e $(which vim) ]]; then
  export EDITOR="vim"
fi

export EDITOR=$(which $EDITOR)
export VISUAL=$EDITOR

export MPD_HOST="localhost"
export BROWSER="firefox -new-tab %s"

# ruby
unset RUBYOPT # gentoo sucks
RIPPER_TAGS_EMACS=1

# python
export PYTHONSTARTUP="$HOME/.pythonrc"

# don't use complex locales on TTY
case ${TERM} in
  linux)
    export LANG=C
    ;;
  *)
    # export LANG=ja_JP.UTF-8
    export LANG=en_US.UTF-8
    ;;
esac

# go
export GOPATH=$HOME/local/go
export GOROOT=$HOME/src/go/golang
export PATH=$GOROOT/bin:$GOPATH/bin:$PATH

# haskell / cabal
export PATH=$HOME/local/cabal/bin:$PATH
