#!/bin/bash

CURDIR=$(dirname $0);

hostsSiteBan(){
	sed '/##--auto-ban--/,$ d' /private/etc/hosts > hosttmp
	echo '##--auto-ban--' >> hosttmp
	cat $CURDIR/ban.hosts.ini >> hosttmp
	sudo cp hosttmp /private/etc/hosts
	rm hosttmp
}

hostsSiteUnBan(){
	sed '/##--auto-ban--/,$ d' /private/etc/hosts > hosttmp
	sudo cp hosttmp /private/etc/hosts
	rm hosttmp
}

 if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

if [ "$1" = "ban" ]; then
    hostsSiteBan;
else
    hostsSiteUnBan;
fi