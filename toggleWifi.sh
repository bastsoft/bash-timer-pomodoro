#!/bin/bash

toggleWifi(){
	device="$(networksetup -listallhardwareports | grep -E '(Wi-Fi|AirPort)' -A 1 | grep -o "en.")";
	[[ "$(networksetup -getairportpower $device)" == *On ]] && val=off || val=on;
	networksetup -setairportpower $device $val;
}

upWifi(){
	device="$(networksetup -listallhardwareports | grep -E '(Wi-Fi|AirPort)' -A 1 | grep -o "en.")";
	networksetup -setairportpower $device on;

	sleep 2;
}

tikTakToogleWifi(){
	device="$(networksetup -listallhardwareports | grep -E '(Wi-Fi|AirPort)' -A 1 | grep -o "en.")";

	if [ ! -e tiktak.ini ]; then
    	echo "0" > tiktak.ini;
	fi

	tiktakstatus=`cat tiktak.ini`;

	if [ "$tiktakstatus" = "0" ];
		then
		echo "1" > tiktak.ini;
		echo "TIK ON";
		networksetup -setairportpower $device on;
	else
		echo "0" > tiktak.ini;
		echo "TAK OFF";
		networksetup -setairportpower $device off;
	fi
}

tikTakToogleWifi;