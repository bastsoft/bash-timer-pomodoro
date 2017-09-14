#!/bin/bash
CURDIR=$(dirname $0);

#считываем данные конфига и делаем глобальные переменные
shopt -s extglob
configfile="$CURDIR/../telegram.ini"; # set the actual path name of your (DOS or Unix) config file

tr -d '\r' < $configfile > $configfile.unix
while IFS='= ' read lhs rhs
do
    if [[ ! $lhs =~ ^\ *# && -n $lhs ]]; then
        rhs="${rhs%%\#*}"    # Del in line right comments
        rhs="${rhs%%*( )}"   # Del trailing spaces
        rhs="${rhs%\"*}"     # Del opening string quotes
        rhs="${rhs#\"*}"     # Del closing string quotes
        declare $lhs="$rhs"
    fi
done < $configfile.unix

sendToTelegram(){
	TelegramLastMessageId=$(curl -s --data "chat_id=$chatId&parse_mode=HTML" \
 	--data-urlencode "text=$1" \
	"https://api.telegram.org/bot$botId/sendMessage" | python -c "import sys, json; print(json.load(sys.stdin)['result']['message_id'])");
}

sendPhotoToTelegram(){
	LastRespons=$(curl -s -X POST "https://api.telegram.org/bot$botId/sendPhoto" -F chat_id="$chatId" -F photo="@$1");
}

sendTraning(){
	sendToTelegram "$(cat $CURDIR/traning.txt | sed -n $1p)";
	sendPhotoToTelegram "$CURDIR/$1.jpg";
}

COUNT=$(cat "$CURDIR/../log/timeDay.log" | wc -l | tr -d '[:space:]');
TRUECount=$(($COUNT - 1));
sendTraning $TRUECount;

