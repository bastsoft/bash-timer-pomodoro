#!/bin/bash

countPause=0;

Loop(){
	local counter=0;
	local START=$(date +%s);
	while [ $(($counter + 1)) -le $1 ]; do 
		local END=$(date +%s);
		counter=$((END-START));
		sleep 1 && inLoop $counter $1;
		isDone
		local done=$?

		if [ "$done" -eq 1 ]; then
			counter=1;
      		break
  		fi

  		if [ "$done" -gt 1 ]; then
  			START=$((START+done));
  		fi
	done

	printf "\n";
}

inLoop() {
	local sec=$1;
	local end=$2;
	local prog=$(ProgressBar ${sec} ${end});
	local timer1=$(showTimer $sec);
	local timer2=$(showTimer $(($end - $sec)));
	local show="";
	local showStr="$timer2 $prog $timer1";

	show="$showStr";

	if [ "$countPause" -ge "1" ];then
		local _fillCountPause=$(printf "%${countPause}s")
		local showPause=$(printf "${_fillCountPause// /*}");
		show="$show $showPause";
	fi

    printf "\r%s" "$show";
}


ProgressBar(){
    let _progress=(${1}*100/${2}*100)/100
    let _done=(${_progress}*4)/10
    let _left=40-$_done

    _fill=$(printf "%${_done}s")
    _empty=$(printf "%${_left}s")
	j=$(printf "${_progress}%% [${_fill// /#}${_empty// /-}]");
	echo "$j"
}

showTimer(){
	local min=$(($1 / 60));
	local trueSec=$(($1 - ($min * 60)));

	local str1=$(printf  "%02d" $min);
	local str2=$(printf  "%02d" $trueSec);

	echo "$str1:$str2";
}

isDone(){
	read -n 1 -s -t 1 key;

	if [[ $key == 1 ]]; then
	 TypeLoop="";
	 countPause=0;
     return 1;
   	fi

   	if [[ $key == 2 ]]; then
   		local startPause=$(date +%s);
   		countPause=$(($countPause+1));

    	read -p "PAUSE" key;

    	local endPause=$(date +%s);
    	local pauseTime=$((endPause-startPause+3));
   	fi

	return 0;
}

expr $1 \+ 0 &>/dev/null
if (($? != 2));
then
		echo "Press: 1 - finish; 2 - pause; Enter - continue; Ctrl+C - exit";
        Loop $((60 * $1));
else
		printf "%s\n" "set time please";
fi