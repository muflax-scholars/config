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
setxkbmap neo2 neo
xmodmap ~/.Xmodmap

xset r rate 300 65
xset m 3 2

#nitrogen --restore &
#xcompmgr &

until {
    DISPLAY=:0.1 exec dbus-launch --auto-syntax --exit-with-session wmii &
    DISPLAY=:0.0 exec dbus-launch --auto-syntax --exit-with-session wmii &
    DISPLAY=:0.0 exec urxvtcd &
    wait
} do
    true
done

#exec dbus-launch --auto-syntax --exit-with-session awesome
#exec openbox-session
