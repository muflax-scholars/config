#> .xsession-errors
# machine specific configs
source ~/.xinitrc_local

#export XIM="uim-xim"
export GTK_IM_MODULE="scim"
export QT_IM_MODULE="scim"
export XMODIFIERS=@im=SCIM

export LANG="ja_JP.UTF-8"

export OOO_FORCE_DESKTOP="gnome"
 
scim -d &
setxkbmap neo2 neo &
xmodmap ~/.Xmodmap &
#numlockx on

#syndaemon -i 1 &
xset r rate 300 65 &
xset m 3 2 &

#xbindkeys

nitrogen --restore &
#xautolock -locker "xlock -mode mandelbrot -dpmsoff 1800 -echokeys" -time 15 &
~/src/in/randomstuff/cycle &

#xcompmgr &
#noteo &
#sudo /sbin/bootchartd stop
exec dbus-launch --auto-syntax --exit-with-session awesome
#exec startfluxbox
