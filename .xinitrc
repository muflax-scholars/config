# machine specific configs
source ~/.xinitrc_local

export GTK_IM_MODULE="scim"
export QT_IM_MODULE="scim"
export XMODIFIERS=@im=SCIM

export LANG="ja_JP.UTF8"
export PATH="$HOME/local/bin:$PATH"
#export LANG=C

export OOO_FORCE_DESKTOP="gnome"

scim -d

DISPLAY=:0.0 xcompmgr -C -I 0.08 -O 0.08 -f &

eval "$(gpg-agent --daemon)"

skb.sh

xsetroot -cursor_name left_ptr

DISPLAY=:0.0 urxvt &

WM="$HOME/.xmonad/xmonad.sh"
#WM="wmii"

exec dbus-launch --auto-syntax --exit-with-session $WM
