#!/bin/bash
CURDIR=$(dirname $0);

eval "$CURDIR/readLog.sh && $CURDIR/playpause.sh && $CURDIR/timer.sh 25 && $CURDIR/writeLog.sh && $CURDIR/playpause.sh && $CURDIR/restTimer.sh";