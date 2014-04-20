# load relevant zsh settings
source $HOME/.zsh/env.sh
source $HOME/.zsh/path.sh

# don't blank monitor
# setterm -blank 0 -powersave off -powerdown 0
# xset s off

# ibus
export GTK_IM_MODULE="ibus"
export QT_IM_MODULE="ibus"
export XMODIFIERS="@im=ibus"

# export LANG="ja_JP.UTF8"
export LANG="en_US.UTF8"

# openoffice stuff
export OOO_FORCE_DESKTOP="gnome"
export SAL_USE_VCLPLUGIN="gen"

# steam audio
export SDL_AUDIODRIVER="alsa"

# machine specific configs
source ~/.xinitrc_local

# daemons
ibus-daemon -x -d &
eval "$(gpg-agent --daemon)" &

# load xdefault data
xrdb $HOME/.Xdefaults &
xsetroot -cursor_name left_ptr &

# keyboard data
skb.sh
xmodmap ~/.Xmodmap

# wifi
wicd-client --tray & >/dev/null

# clipboard synchronization
klipper >/dev/null 2>/dev/null

# dropbox
dropbox-cli start

# fancy window fading
compton -f -I 0.10 -O 0.10 -D 5 -b

# background
nitrogen --restore &

# reading lists and so on
mount_filterfs.sh

# mount archives
mountavfs &

WM="awesome"
exec dbus-launch --auto-syntax --exit-with-session $WM
