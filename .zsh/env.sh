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

# guile
unset GUILE_LOAD_PATH # gentoo sucks

# openoffice stuff
export OOO_FORCE_DESKTOP="gnome"
export SAL_USE_VCLPLUGIN="gen"

# steam audio
export SDL_AUDIODRIVER="alsa"

# explicitly set ssl certs so Nix and Gentoo interact peacefully
export OPENSSL_X509_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
export GIT_SSL_CAINFO=$OPENSSL_X509_CERT_FILE
