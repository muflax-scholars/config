#> .xsession-errors
# machine specific configs
source ~/.xinitrc_local

export GTK_IM_MODULE="scim"
export QT_IM_MODULE="scim"
export XMODIFIERS=@im=SCIM

export LANG="ja_JP.UTF8"
#export LANG=C

export OOO_FORCE_DESKTOP="gnome"
 
scim -d
setxkbmap saneo
xmodmap ~/.Xmodmap

xset r rate 300 65
xset m 3 2

DISPLAY=:0.0 urxvt &

WM="xmonad"
#WM="wmii"
#WM="awesome"

exec dbus-launch --auto-syntax --exit-with-session $WM
