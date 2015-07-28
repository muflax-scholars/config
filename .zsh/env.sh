# PATH-y

# ruby
export PATH=$HOME/local/rubies/default/bin:$PATH

# go
# export GOROOT_BOOTSTRAP=$HOME/src/go/golang/go-1.4
# export GOROOT=$HOME/src/go/golang/go
export GOPATH=$HOME/local/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

# haskell / cabal
export PATH=$HOME/local/cabal/bin:$PATH

# rust
if [[ -s ~/.multirust ]]; then
  toolchain=$(cat ~/.multirust/default)
  if [[ -n $toolchain ]]; then
    export MANPATH=$HOME/.multirust/toolchains/$toolchain/share/man:$MANPATH
    fpath=($HOME/.multirust/toolchains/$toolchain/share/zsh/site-functions $fpath)
  fi
  unset toolchain
fi

# ~/local dir (should be last so we can overwrite stuff in PATH)
export PATH=$HOME/local/bin:$PATH
export LD_LIBRARY_PATH=$HOME/local/lib:$LD_LIBRARY_PATH
export MANPATH=$HOME/local/share/man:$MANPATH
export PKG_CONFIG_PATH=$HOME/local/lib/pkgconfig:$PKG_CONFIG_PATH

# local scripts; consider merging with config?
SCRIPTS="$HOME/src/scripts"
# adding scripts and all subdirs to PATH
for dir in $(find $SCRIPTS -type d -not -path "*/.git*"); do
  export PATH="$dir:$PATH"
done

# remove duplicates
typeset -U PATH
typeset -U LD_LIBRARY_PATH
typeset -U MANPATH
typeset -U PKG_CONFIG_PATH

# configs

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

# browser
export BROWSER="firefox -new-tab %s"

# locale
export LANG=en_US.UTF-8

# mpd
export MPD_HOST="localhost"

# maildir
export MAILDIR="$HOME/mail"

# ruby
unset RUBYOPT # gentoo sucks

# python
export PYTHONSTARTUP="$HOME/.pythonrc"

# R
export R_LIBS="$HOME/local/R"

# openoffice stuff
export OOO_FORCE_DESKTOP="gnome"
export SAL_USE_VCLPLUGIN="gen"

# steam audio
export SDL_AUDIODRIVER="alsa"

# chicken scheme
export CHICKEN_REPOSITORY=$HOME/local/chicken-eggs/lib/chicken/7
export CHICKEN_DOC_REPOSITORY=$HOME/local/chicken-eggs/chicken-doc
