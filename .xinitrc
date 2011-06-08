# load zsh settings
export PATH="$($HOME/in/scripts/extend_path.sh):$PATH"
[[ -s "/home/amon/.rvm/scripts/rvm" ]] && source "/home/amon/.rvm/scripts/rvm"

# don't blank monitor
setterm -blank 0 -powersave off -powerdown 0
xset s off

# ibus
export GTK_IM_MODULE="ibus"
export QT_IM_MODULE="ibus"
export XMODIFIERS=@im=ibus

export LANG="ja_JP.UTF8"
#export LANG=C

# openoffice stuff
export OOO_FORCE_DESKTOP="gnome"
export SAL_USE_VCLPLUGIN="gen"

# machine specific configs
source ~/.xinitrc_local

# daemons
ibus-daemon -x -d &
eval "$(gpg-agent --daemon)" &
#emacs --daemon &

# load xdefault data
xrdb $HOME/.Xdefaults &
xsetroot -cursor_name left_ptr &

# keyboard data
skb.sh
xmodmap ~/.Xmodmap

DISPLAY=:0.0 urxvt -name scratchpad -e zsh -c 'screen -DRS scratchpad' &

WM="start_xmonad.sh"
exec dbus-launch --auto-syntax --exit-with-session $WM
