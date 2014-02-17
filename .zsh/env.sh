# default that exists everywhere
local editor="vi"

if [[ -e $(which emacs-gui) ]]; then
  editor="emacs-gui"
  export SUDO_EDITOR="emacs-gui-wait"
elif [[ -e $(which emacs) ]]; then
  editor="emacs"
elif [[ -e $(which vim) ]]; then
  editor="vim"
fi

export EDITOR=$editor
export VISUAL=$editor

export MPD_HOST="localhost"
export BROWSER="firefox -new-tab %s &"

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


# fancy ls_colors
#
# meta:
# 0   = Default Colour
# 1   = Bold
# 4   = Underlined
# 5   = Flashing Text
# 7   = Reverse Field
#
# foreground:
# 30  = Black
# 90  = Dark Grey
# 31  = Red
# 91  = Light Red
# 32  = Green
# 92  = Light Green
# 33  = Orange
# 93  = Yellow
# 34  = Blue
# 94  = Light Blue
# 35  = Purple
# 95  = Light Purple
# 36  = Cyan
# 96  = Turquoise
# 37  = Grey
#
# background:
# 40  = Black
# 100 = Dark Grey
# 41  = Red
# 101 = Light Red
# 42  = Green
# 102 = Light Green
# 43  = Orange
# 103 = Yellow
# 44  = Blue
# 104 = Light Blue
# 45  = Purple
# 105 = Light Purple
# 46  = Cyan
# 106 = Turquoise
# 47  = Grey

export LS_COLORS="*.rb=00;32:$LS_COLORS"
