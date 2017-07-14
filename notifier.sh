#!/bin/bash
TelegramLastMessageId=0;
TelegramChatId=0;
TelegramBotId="0";

notifier(){
	terminal-notifier -message "$1" -titlle "Pomodoro" --subtitle "$2"
}

# addToCalendar(){
#	node pomodoro2/eventAdd.js "$1" "$mainTime";
# }

sendToTelegram(){
	TelegramLastMessageId=$(curl -s --data "chat_id=$TelegramChatId&parse_mode=HTML" \
 	--data-urlencode "text=$1" \
	"https://api.telegram.org/bot$TelegramBotId/sendMessage" | python -c "import sys, json; print(json.load(sys.stdin)['result']['message_id'])");
}

editMessageText(){
	curl -s --data "chat_id=$TelegramChatId&message_id=$TelegramLastMessageId&parse_mode=HTML" \
 	--data-urlencode "text=$1" \
	"https://api.telegram.org/bot$TelegramBotId/editMessageText" > /dev/null
}