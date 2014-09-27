# ~/local dir
export PATH="$HOME/local/bin:$PATH"
export MANPATH="$HOME/local/share/man:$MANPATH"
export LD_LIBRARY_PATH="$HOME/local/lib:$LD_LIBRARY_PATH"
export PKG_CONFIG_PATH="$HOME/local/lib/pkgconfig:$PKG_CONFIG_PATH"

# local scripts; consider merging with config?
SCRIPTS="$HOME/src/scripts"
# adding scripts and all subdirs to PATH
for dir in $(find $SCRIPTS -type d -not -path "*/.git*"); do
  export PATH="$dir:$PATH"
done

# nix
nix_profile=$HOME/.nix-profile/etc/profile.d/nix.sh
if [[ -e $nix_profile ]]; then
  source $nix_profile
  export MANPATH="$HOME/.nix-profile/share/man:$MANPATH"
  export LD_LIBRARY_PATH="$HOME/.nix-profile/lib:$LD_LIBRARY_PATH"
  export PKG_CONFIG_PATH="$HOME/.nix-profile/lib/pkgconfig:$PKG_CONFIG_PATH"
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
export GOROOT=$HOME/src/go/golang
export PATH=$GOROOT/bin:$GOPATH/bin:$PATH

# haskell / cabal
export PATH=$HOME/local/cabal/bin:$PATH

# racket
export PATH=$HOME/local/racket/bin:$PATH

# gtk themes
export GTK_PATH=$HOME/.nix-profile/lib/gtk-2.0
