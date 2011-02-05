export GTK_IM_MODULE="scim"
export QT_IM_MODULE="scim"
export XMODIFIERS=@im=SCIM

export LANG="ja_JP.UTF8"
export PATH="$HOME/local/bin:$PATH"
#export LANG=C

export OOO_FORCE_DESKTOP="gnome"

# machine specific configs
source ~/.xinitrc_local

scim -d

eval "$(gpg-agent --daemon)"

skb.sh

xsetroot -cursor_name left_ptr

# load xdefault data
xrdb $HOME/.Xdefaults

DISPLAY=:0.0 urxvt -name scratchpad -e zsh -c 'screen -DRS scratchpad' &

WM="$HOME/.xmonad/xmonad.sh"
exec dbus-launch --auto-syntax --exit-with-session $WM
