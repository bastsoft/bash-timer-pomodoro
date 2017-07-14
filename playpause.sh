#!/bin/bash

pressPlayMacOS(){
	osascript -e 'tell app "iTunes" to playpause'
    #osascript -e "set volume 0.001"
}

pressPlayForFireFoxRemoteControlYandexMusic(){
	#document.querySelector('.ytp-play-button').click()
	echo "document.querySelector('.player-controls__btn_play').click()" | nc -c localhost 32000;
}

pressPlayForYouTybe(){
	echo "document.querySelector('.ytp-play-button').click()" | nc -c localhost 32000;
}

device="$(networksetup -listallhardwareports | grep -E '(Wi-Fi|AirPort)' -A 1 | grep -o "en.")";

[[ "$(networksetup -getairportpower $device)" == *On ]] && say $(curl -s http://api.forismatic.com/api/1.0/\?method\=getQuote\&format\=text);

pressPlayMacOS;
