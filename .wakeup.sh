#!/bin/zsh
# variables
export DISPLAY=:0.0 

SHOW="ケロロ軍曹"
PATTERN="*#{259..300}.*"

SHOWPATH="/home/amon/テレビ/$SHOW"
EP=$(eval "ls -1 $SHOWPATH/$PATTERN" | head -1)

# play stuff
ossmix -q vmix0-outvol 24
xset dpms force on
sleep 3
mplayer -quiet -really-quiet -ao oss "$EP" &> /dev/null
