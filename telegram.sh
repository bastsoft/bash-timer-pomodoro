#!/bin/bash

sendToTelegram(){
	curl -s --data chat_id=-245892698 \
 	--data-urlencode "text=$1" \
	"https://api.telegram.org/bot261033542:AAEnqFzTgBTLji09l1JDcxvC4dzmueexieg/sendMessage" > /dev/null
}

sendToTelegram "$1"