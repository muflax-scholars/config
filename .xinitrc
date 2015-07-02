# load relevant zsh settings
source $HOME/.zsh/env.sh

# machine specific configs
source ~/.xinitrc_local

# input method
# export GTK_IM_MODULE="uim"
# export QT_IM_MODULE="uim"
# export XMODIFIERS="@im=uim"
# uim-xim &
# uim-toolbar-gtk-systray &

# gpg
killall gpg-agent
eval "$(gpg-agent --daemon)"

# load xdefault data
xrdb $HOME/.Xdefaults &
xsetroot -cursor_name left_ptr &

# keyboard data
skb.sh
xmodmap ~/.Xmodmap

# wifi
wicd-client --tray & >/dev/null

# clipboard synchronization
parcellite &

# dropbox
dropbox start

# background
nitrogen --restore &

# reading lists and so on
mount_filterfs.sh

# mount archives
mountavfs &

WM="awesome"
exec dbus-launch --auto-syntax --exit-with-session $WM
