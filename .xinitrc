# scim
#export GTK_IM_MODULE="scim"
#export QT_IM_MODULE="scim"
#export XMODIFIERS=@im=SCIM
# ibus
export GTK_IM_MODULE="ibus"
export QT_IM_MODULE="ibus"
export XMODIFIERS=@im=ibus

export LANG="ja_JP.UTF8"
export PATH="$HOME/local/bin:$PATH"
#export LANG=C

export OOO_FORCE_DESKTOP="gnome"

# machine specific configs
source ~/.xinitrc_local

#scim -d &
ibus-daemon -x -d &

eval "$(gpg-agent --daemon)" &

emacs --daemon &

xsetroot -cursor_name left_ptr &

# load xdefault data
xrdb $HOME/.Xdefaults &

# keyboard data
skb.sh

DISPLAY=:0.0 urxvt -name scratchpad -e zsh -c 'screen -DRS scratchpad' &

WM="$HOME/.xmonad/xmonad.sh"
exec dbus-launch --auto-syntax --exit-with-session $WM
