#!/bin/bash

CURDIR=$(dirname $0);
DIR="$CURDIR/log";
CountConsecutive=$(cat "$DIR/consecutive.log" | wc -l | tr -d '[:space:]');


if [ "$CountConsecutive" -eq "3" ]; then
	sumTime=$(awk '{ sum += $1 } END { print sum }' "$DIR/timeDay.log");
	DATE=`date +%Y-%m-%d`;
	COUNT=$(cat "$DIR/pomodoro$DATE.log" | wc -l | tr -d '[:space:]');
	midleTime=$(echo "$sumTime / $COUNT" | bc -l | awk '{printf("%d\n",$1 + 0.5)}');
	#Монет в больших перерывах по средниму времени
	getMoney=$(echo "$midleTime / 1.6" | bc -l | awk '{printf("%d\n",$1 + 0.5)}'); 
	echo "$getMoney" >> "$DIR/countmoney.log";
	echo "Ваши войны в битве добыли $getMoney монет"
	echo "1" > "$DIR/consecutive.log";
	#Больший перерыв по канонам это 15 минут
	#но в игровой механики решил что это будет кол-во монет если их больше 0 если нет то перерыв 15
	longBreakSumMoney=$(awk '{ sum += $1 } END { print sum }' "$DIR/countmoney.log");

	if [ "$longBreakSumMoney" -ge "0" ];then
		longBreakTime=$longBreakSumMoney;
	else
		longBreakTime=15
	fi	
	
	eval "$CURDIR/timer.sh $longBreakTime";
else
	eval "$CURDIR/timer.sh 5";
fi