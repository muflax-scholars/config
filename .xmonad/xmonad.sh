#!/bin/zsh
# Copyright muflax <mail@muflax.com>, 2009
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

# does all the xmonad-related stuff :)

HOSTNAME=$(hostname)
# dzen values

FG="#ffffff"
BG="#000000"
FN="-mplus-gothic-medium-r-*-12-*"
E="sigusr1=raise;sigusr2=lower"
H="13"

#FIXME: stupid, read it out somehow :)
case $HOSTNAME in
    azathoth)
        WIDTH="1680"
        HEIGHT="1050"
        ;;
    nyarlathotep)
        WIDTH="1440"
        HEIGHT="900"
        ;;
    *)
        echo "unknown host: aborting"
        exit 1
        ;;
esac

DZEN="dzen2 -fg '$FG' -bg '$BG' -fn '$FN' -e '$E' -h '$H' -y '$(($HEIGHT - $H))'" 
DZEN_LEFT="$DZEN -x '0' -w '$(($WIDTH / 2))' -ta 'l'"
DZEN_RIGHT="$DZEN -x '$(($WIDTH / 2))' -w '$(($WIDTH / 2))' -ta 'r'"

cowsay "starting xmonad nao!"
(~/.xmonad/status.sh | eval $DZEN_RIGHT) &
xmonad | eval $DZEN_LEFT
