#!/bin/bash

CURDIR=$(dirname $0);
DIR="$CURDIR/log";
DATE=`date +%Y-%m-%d`;
DATATime=`date +%H:%M:%S`;
IFS=: read hour min sec <<< "$DATATime"
POMOFOROTIMELOG="$DIR/pomodoro$DATE.log";
COUNT=0;

showTimer(){
	local min=$(($1 / 60));
	local trueSec=$(($1 - ($min * 60)));

	local str1=$(printf  "%02d" $min);
	local str2=$(printf  "%02d" $trueSec);

	echo "$str1:$str2";
}

if [[ ! -d "$DIR" && ! -L "$DIR" ]] ; then
    # Создать папку, только если ее не было и не было символической ссылки
    mkdir $DIR
fi



if [ -e $POMOFOROTIMELOG ]; then
	COUNT=$(cat $POMOFOROTIMELOG | wc -l | tr -d '[:space:]');
	LAST1TIME=$(cat $POMOFOROTIMELOG |  tail -n1);

	IFS=: read old_hour old_min old_sec <<< "$LAST1TIME"

	total_old_minutes=$((10#$old_hour*60*60 + 10#$old_min*60 + 10#$old_sec));
	total_minutes=$((10#$hour*60*60 + 10#$min*60 + 10#$sec));
	div=$(((total_minutes - total_old_minutes)/60));

	echo "1" >> "$DIR/consecutive.log";

	if [ "$div" -lt "5" ];then
			echo "Если будешь отдыхать всего $div минут, быстро выдахнишься!"
	fi

	if [ "$div" -ge "8" ];then
		if [ "$div" -ge "60" ];then
			echo "Тебя не было на работе $(($div/60)) часа, работничек тиюмать";
		else
			echo "А ты не охренел так долго отдыхать? прошло $div минут с последней помидорки. Работай давай!";
		fi
			echo "1" > "$DIR/consecutive.log";
	fi

	echo "-$div" >> "$DIR/countmoney.log";
	echo "Со времени последней помидорки прошло $div минут"
else 
	echo "Сейчас будет первая помидорка";
	if [ "$hour" -lt "8" ];then
		echo "Чето прям рано начал, молодец! но сон должен быть на первом месте";
	fi

	if [ "$hour" -gt "9" ];then
		echo "Так, почему опоздал? выговор тебе, с занесением в личное дело, у нас начало работы в 9 часов утра";
	fi	

	echo "Готов к подвигам?";
	
	echo "1" > "$DIR/consecutive.log";
	echo "60" > "$DIR/countmoney.log"; #у тебя сразу 60 монет, для обеда
	echo "0" > "$DIR/timeDay.log"; #сбрасываем время
fi

summoney=0;
if [ -e "$DIR/countmoney.log" ]; then
	summoney=$(awk '{ sum += $1 } END { print sum }' "$DIR/countmoney.log");
fi

sumTime=0;
if [ -e "$DIR/timeDay.log" ]; then
	sumTime=$(awk '{ sum += $1 } END { print sum }' "$DIR/timeDay.log");
fi

midleTime=0;
timerInHour=$(showTimer $sumTime);

CountTrue=$(($COUNT+1));

if [ "$COUNT" -gt "0" ];then
	midleTime=$(echo "$sumTime / $COUNT" | bc -l | awk '{printf("%d\n",$1 + 0.5)}');
fi

getMoney=$(echo "$midleTime / 1.6" | bc -l | awk '{printf("%d\n",$1 + 0.5)}'); 

consecutiveCOUNT=$(cat  "$DIR/consecutive.log" | wc -l | tr -d '[:space:]');

consec=$((4-$consecutiveCOUNT));

msg="$CountTrue | запас : $summoney | день: $COUNT | время : $timerInHour | срд : $midleTime | прз : $getMoney через $consec" ;
echo $msg;
eval "$CURDIR/telegram.sh \"$msg\"";



