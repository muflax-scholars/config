# PATH-y

# nix
nix_profile=$HOME/.nix-profile/etc/profile.d/nix.sh
if [[ -e $nix_profile && -z $NO_NIX ]]; then
  source $nix_profile
  export MANPATH="$HOME/.nix-profile/share/man:$MANPATH"
  export PKG_CONFIG_PATH="$HOME/.nix-profile/lib/pkgconfig:$PKG_CONFIG_PATH"

  # gtk themes
  export GTK_PATH=$HOME/.nix-profile/lib/gtk-2.0

  # uim
  export GTK_IM_MODULE_FILE=$HOME/.nix-profile/lib/gtk-2.0/2.10.0/immodules.cache

  # timezone data for non-NixOS compatibility
  export TZDIR=$HOME/.nix-profile/share/zoneinfo

  # make go compiler work
  export CGO_CFLAGS="-I$HOME/.nix-profile/include"
  export CGO_CXXFLAGS=$CGO_CFLAGS
  export CGO_LDFLAGS="-L$HOME/.nix-profile/lib"

  # guile
  export GUILE_LOAD_PATH="$HOME/.nix-profile/share/guile/site/2.0:$HOME/.nix-profile/share/guile/site:$GUILE_LOAD_PATH"
  export GUILE_LOAD_COMPILED_PATH="$HOME/.nix-profile/share/guile/site/2.0:$HOME/.nix-profile/share/guile/site:$GUILE_LOAD_COMPILED_PATH"
fi
unset nix_profile

# unroll rbenv code for speedup
if [[ -s ~/.rbenv ]]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  export PATH="$HOME/.rbenv/shims:$PATH"
  export RBENV_SHELL=zsh
  source '/home/amon/.rbenv/completions/rbenv.zsh'
  rbenv() {
    local command
    command="$1"
    if [ "$#" -gt 0 ]; then
      shift
    fi

    case "$command" in
      rehash|shell)
        eval "`rbenv "sh-$command" "$@"`";;
      *)
        command rbenv "$command" "$@";;
    esac
  }

  # rbenv loads most gems, but prefer bundler's version if it exists
  export PATH="$HOME/.bundle/bin:$PATH"
fi

# go
export GOPATH=$HOME/local/go
export PATH=$GOPATH/bin:$PATH

# haskell / cabal
export PATH=$HOME/local/cabal/bin:$PATH

# ~/local dir (should be last so we can overwrite stuff in PATH)
export PATH="$HOME/local/bin:$PATH"
export LD_LIBRARY_PATH="$HOME/local/lib:$LD_LIBRARY_PATH"
export MANPATH="$HOME/local/share/man:$MANPATH"
export PKG_CONFIG_PATH="$HOME/local/lib/pkgconfig:$PKG_CONFIG_PATH"

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
RIPPER_TAGS_EMACS=1

# python
export PYTHONSTARTUP="$HOME/.pythonrc"

# R
export R_LIBS="$HOME/local/R"

# openoffice stuff
export OOO_FORCE_DESKTOP="gnome"
export SAL_USE_VCLPLUGIN="gen"

# steam audio
export SDL_AUDIODRIVER="alsa"

# explicitly set ssl certs so Nix and Gentoo interact peacefully
export OPENSSL_X509_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
export GIT_SSL_CAINFO=$OPENSSL_X509_CERT_FILE
