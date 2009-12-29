#!/bin/bash
#amixer -q set Software 85%
ossmix -q vmix0-outvol 22
mplayer -quiet -really-quiet -ao oss -endpos 10 /home/amon/.wakeup &> /dev/null
