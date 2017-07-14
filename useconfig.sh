#!/bin/bash

while :
do
	# show menu
	clear

	#данные из календаря
	node pomodoro2/index.js;

	#считываем данные конфига и делаем глобальные переменные
	shopt -s extglob
	configfile="useconfig.ini" # set the actual path name of your (DOS or Unix) config file
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

	sumwarriors=$(awk '{ sum += $1 } END { print sum }' countwarriors.log);
	mainTime=$(echo "$sumwarriors * 5" | bc -l | awk '{printf("%d\n",$1 + 0.5)}'); #10 * 2,5 = 25
	mainBreakTime=$sumwarriors;
	Board=$(scoreboard);
	echo "$Board";

	echo "---------------------------------"
	echo "1. Exit"
	echo "2. pomodoro ${mainTime} ${mainBreakTime}"
	# echo "3. longBreak ${longBreakTime}"
	# echo "4. lunchBreakTime ${lunchBreakTime}"
	echo "5. + man"
	echo "6. - man"
	echo "7. 5 man"
	echo "8. add hour rest"
	read -r -p "Что будем делать? : " c
	# take action
	case $c in
		1) break;;
		2) Loop $((60 * $mainTime)) "main";;
		# 3) Loop $((60 *  $longBreakTime)) "longBreak";;
		# 4) Loop $((60 * $lunchBreakTime)) "lunchBreakTime";;
		5) echo "1" >> countwarriors.log;; #шаг изменения войнов 2
		6) echo "-1" >> countwarriors.log;;
		7) echo "5" > countwarriors.log;;
		8) echo "60" >> countmoney.log;;
		*) Pause "Обновили значение, а теперь выбирите то что нужно"
	esac
done