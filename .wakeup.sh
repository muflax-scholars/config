#!/bin/zsh
#amixer -q set Software 85%
ossmix -q vmix0-outvol 22
mplayer -quiet -really-quiet -ao oss /home/amon/.wakeup &> /dev/null
#boodler.py -o alsa computing.MultiComputing
