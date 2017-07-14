#!/bin/bash

CURDIR=$(dirname $0);
DIR="$CURDIR/log";
DATE=`date +%Y-%m-%d`;
DATATime=`date +%H:%M:%S`;

dailyPayment=5;
	
echo "25" >> "$DIR/timeDay.log";
echo "$dailyPayment" >> "$DIR/countmoney.log";
echo $DATATime >> "$DIR/pomodoro$DATE.log";