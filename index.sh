#!/bin/bash
CURDIR=$(dirname $0);

preNotify="$CURDIR/playpause.sh";
postNotify="$CURDIR/playpause.sh";
toSleep="osascript -e 'tell app \"System Events\" to sleep'";
postNotify="$postNotify && $CURDIR/traning/traning.sh";
timerCmd="$CURDIR/timer.sh 20 && $CURDIR/notifier.sh \"20 минут\" && $CURDIR/timer.sh 5 && $CURDIR/writeLog.sh ";
# Check the script is being run by root
if [[ $EUID -ne 0 ]]; then
   eval "$CURDIR/readLog.sh && $preNotify && $timerCmd && $postNotify && $CURDIR/restTimer.sh";
else
   eval "$CURDIR/readLog.sh && $preNotify && $CURDIR/banhosts.sh ban && $timerCmd && $CURDIR/banhosts.sh && $postNotify && $CURDIR/restTimer.sh";	
fi
