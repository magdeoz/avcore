# Custom settings for session behaviour
# values for all settings should either be 1 or 0.
# Check Busybox Applet Generator 2.4.
run_Busybox_Applet_Generator=1
# Check Superuser.
run_Superuser=1
# Use /dev/urandom for print_RANDOM_BYTE.
use_urand=1
# invert print_RANDOM_BYTE.
invert_rand=1
# launch install() at start.(ONLY FOR REFERENCE, DON'T TOUCH!)
install=0
until [[ "$1" != --verbose ]] && [[ "$1" != --supass ]] && [[ "$1" != --bbpass ]] && [[ "$1" != --urand ]] && [[ "$1" != --invrand ]] && [[ "$1" != --renice ]] && [[ "$1" != --install ]]; do
	if [[ "$1" == --verbose ]]; then
		set -x
	elif [[ "$1" == --install ]]; then
		readonly install=1
	elif [[ "$1" == --supass ]] && [[ "$run_Superuser" != 0 ]]; then
		readonly run_Superuser=0
	elif [[ "$1" == --bbpass ]] && [[ "$run_Busybox_Applet_Generator" != 0 ]]; then
		readonly run_Busybox_Applet_Generator=0
	elif [[ "$1" == --urand ]] && [[ "$use_urand" != 1 ]]; then
		readonly use_urand=1
	elif [[ "$1" == --invrand ]] && [[ "$invert_rand" != 1 ]]; then
		readonly invert_rand=1
	elif [[ "$1" == --renice ]]; then
		if [[ ! "$(echo $2 | tr [0-9] ' ' | sed 's/^-//' | sed 's/ //g')" ]]; then
			if [[ "$2" -le 19 ]] && [[ "$2" -ge -20 ]]; then
				renice $2 $$ 1>/dev/null
			else
				echo "parameter input out-of-range!"
				exit 1
			fi
		else
			echo "invalid parameter input!"
			exit 1
		fi
		shift
	fi
	shift
done
readonly version="0.1"
readonly BASE_NAME=$(basename $0)
readonly NO_EXTENSION=$(echo $BASE_NAME | sed 's/\..*//')
readonly backup_PATH=$PATH
readonly set_PATH=$(dirname $0 | sed 's/^\.//')
readonly set_PATH2=$(pwd)
if [[ "$set_PATH" ]]; then
	if [[ "$(ls / | grep $(echo $set_PATH | tr -s / \\n | head -n2	| tr -s \\n / | sed 's/\/$//' | sed 's/^\///'))" ]] ; then
		export PATH=$set_PATH:$PATH
	else
		export PATH=$set_PATH2:$PATH
	fi
else
	export PATH=$set_PATH2:$PATH
fi
reg_name=$(which $BASE_NAME 2>/dev/null) # somewhat seems to be incompatible with 1.22.1-stericson.
if [[ ! "$reg_name" ]]; then
	echo "you are not running this program in proper location. this may cause trouble for codes that use this function: DIR_NAME"
	readonly DIR_NAME="NULL" #'NULL' will go out instead of an actual directory name
else
	readonly DIR_NAME=$(dirname $reg_name | sed 's/^\.//')
fi
export PATH=$backup_PATH # revert back to default
readonly FULL_NAME=$(echo $DIR_NAME/$BASE_NAME)
print_PARTIAL_DIR_NAME(){
	echo $(echo $DIR_NAME | tr -s / \\n | head -n$(($1+1))	| tr -s \\n / | sed 's/\/$//')
}
readonly ROOT_DIR=$(print_PARTIAL_DIR_NAME 1)
print_RANDOM_BYTE(){
	if [[ "$use_urand" != 1 ]]; then
		rand=$(($(od -An -N2 -i /dev/random)%32767))
	else
		rand=$(($(od -An -N2 -i /dev/urandom)%32767))
	fi
	if [[ "$invert_rand" == 1 ]]; then
		if [[ "$rand" -lt 0 ]]; then
			rand=$(($((rand*-1))-1))
		fi
	fi
	echo $rand #output
}
debug_shell(){
	echo "welcome to the debug_shell program! type in: 'help' for more information."
	echo  -e -n "\e[1;32mdebug-\e[1;33m$version\e[0m"
	if [[ "$su_check" == 0 ]]; then
		echo -n '# '
	else
		echo -n '$ '
	fi
	while eval read i; do
		case $i in
			randtest)
				while true; do echo -n $(print_RANDOM_BYTE); done
			;;
			help)
				echo -e "this debug shell is \e[1;31mONLY\e[0m used for testing conditions inside this program!
it is not a complete shell as you CANNOT use any regex with it.
such includes:
	-functions
	-variables
	-built-in sh or bash commands

instead, you can use these commands built-in to this program:
	-print_PARTIAL_DIR_NAME
	-print_RANDOM_BYTE
	-Busybox_Applet_Generator
	-Superuser
	-any other functions built-in to this program...
you can use set command to view all the functions and variables built-in to this program.

you can also use these built-in commands in debug_shell:
	-randtest (tests if print_RANDOM_BYTE is functioning properly)
	-help (brings out this message)

debug_shell \e[1;33mv$version\e[0m
Copyright (C) 2013-2015 hoholee12@naver.com"
			;;
			return*)
				exit
			;;
			*)
				$i
			;;
		esac
		echo  -e -n "\e[1;32mdebug-\e[1;33m$version\e[0m"
		if [[ "$su_check" == 0 ]]; then
			echo -n '# '
		else
			echo -n '$ '
		fi
	done
}
install(){
	local loc # prevent breaks
	n=0
	for i in $(echo $PATH | sed 's/:/ /g'); do
		n=$(($n+1))
		export slot$n=$i
	done
	if [[ "$1" == -i ]]; then
		for i in $(seq -s ' $slot' 0 $n | sed 's/^0//'); do
			eval echo $i
		done
	else
		echo $n hits.
		for i in $(seq -s ' $slot' 0 $n | sed 's/^0//'); do
			v=$(eval echo $i)
			echo -e "\rwould you like to install it in $v? (y/n) "
			while true; do
				stty cbreak -echo
				f=$(dd bs=1 count=1 2>/dev/null)
				stty -cbreak echo
				case $f in
					y* | Y*)
						loc=$v
						break
					;;
					n* | N*)
						break
					;;
					q* | Q*)
						echo canceled.
						return 0
					;;
					*)
						random=$(print_RANDOM_BYTE)
						random=$((random%4+1))
						if [[ "$random" -eq 1 ]]; then
							echo -n -e '\rwhat? '
						elif [[ "$random" -eq 2 ]]; then
							echo -n -e '\ri dont understand. '
						elif [[ "$random" -eq 3 ]]; then
							echo -n -e '\rcome on mate, you could do better than that! '
						elif [[ "$random" -eq 4 ]]; then
							echo -n -e '\rif i were you, i would choose the broccoli. '
						fi
					;;
				esac
				echo -n press \'q\' to quit.
			done
			if [[ "$loc" ]]; then
				break
			fi
		done
		if [[ ! "$loc" ]]; then
			echo couldnt install, sorry. :p
			return 1
		fi
		echo -e '\rplease wait...'
		loc_DIR_NAME=$(echo $loc | tr -s / \\n | head -n2 | tr -s \\n / | sed 's/\/$//')
		mountstat=$(mount | grep $loc_DIR_NAME | head -n1)
		availperm=$(echo $mountstat | grep 'ro\|rw')
		if [[ "$availperm" ]]; then #linux else unix
			if [[ "$(echo $mountstat | grep ro)" ]]; then
				ro=1
				echo -n -e '\rmounting...'
				mount -o remount,rw $loc_DIR_NAME
			fi
		else
			ro=0
		fi
		if [[ -f "$loc/$NO_EXTENSION" ]]; then
			echo 'program file already exists. overwrite? (y/n) '
			while true; do
				stty cbreak -echo
				f=$(dd bs=1 count=1 2>/dev/null)
				stty -cbreak echo
				case $f in
					y* | Y*)
						break
					;;
					n* | N* | q* | Q*)
						echo canceled.
						return 0
					;;
					*)
						random=$(print_RANDOM_BYTE)
						random=$((random%4+1))
						if [[ "$random" -eq 1 ]]; then
							echo -n -e '\rwhat? '
						elif [[ "$random" -eq 2 ]]; then
							echo -n -e '\ri really dont understand. '
						elif [[ "$random" -eq 3 ]]; then
							echo -n -e '\rtry again. '
						elif [[ "$random" -eq 4 ]]; then
							echo -n -e '\rnya~ '
						fi
					;;
				esac
			done
		fi
		if [[ "$(echo $mountstat | grep rw)" ]]; then
			echo -n -e '\rcopying files...'
			cp $0 $loc/$NO_EXTENSION
			if [[ "$?" == 1 ]]; then
				return 1
			fi
			chmod 755 $loc/$NO_EXTENSION
			if [[ "$ro" == 1 ]]; then
				mount -o remount,ro $loc_DIR_NAME
			fi
		else
			if [[ ! "$availperm" ]]; then
				echo -n -e '\rcopying files...'
				cp $0 $loc/$NO_EXTENSION
				if [[ "$?" == 1 ]]; then
					return 1
				fi
				chmod 755 $loc/$NO_EXTENSION
			else
				error=1
			fi
		fi
		if [[ "$error" == 1 ]]; then
			echo -e "internal error! please use '--verbose' and try again. \e[1;31m\"error code 1\"\e[0m"
			return 1
		else
			echo
			long_line 2
			echo install complete!
			echo type \'$NO_EXTENSION\' to run the program!
		fi
	fi
}
long_line(){
	for i in $(seq 1 $(tput cols 2>/dev/null)); do
		if [[ "$1" -le 1 ]]; then
			echo -n '-'
		else
			echo -n '='
		fi
	done
	if [[ "$i" == 1 ]]; then
		echo -n -e '\r'
		for j in $(seq 1 80); do # 80 columns
			if [[ "$1" -le 1 ]]; then
				echo -n '-'
			else
				echo -n '='
			fi
		done
	fi
	echo
}
error(){
	message=$@
	echo $message
	date '+date: %m/%d/%y%ttime: %H:%M:%S ->'"$message"'' >> $DIR_NAME/$NO_EXTENSION.log
}
# skeleton.sh
#
# Copyright (C) 2013-2015  hoholee12@naver.com
#
# Everyone is permitted to copy and distribute verbatim copies
# of this code, but changing it is not allowed.
#
# Changelogs:

set +e #error proof

# Busybox Applet Generator 2.4
# You can type in any commands you would want it to check.
# It will start by checking from cmd1, and its limit is up to cmd224.
cmd1=dirname
cmd2=basename
cmd3=ls
cmd4=grep
cmd5=head
cmd6=awk
cmd7=cat
cmd8=pgrep
cmd9=ps
cmd10=chrt
cmd11=cp
cmd= # It notifies the generator how many cmds are available for check. Leave it as blank.

silent_mode= # enabling this will hide errors.
# This feature might not be compatible with some other multi-call binaries.
# if similar applets are found and Busybox do not have them, it will still continue but leave out some error messages regarding compatibility issues.
bb_check= # BB availability.
Busybox_Applet_Generator(){
	bb_check=0
	local n i busyboxloc busyboxenv fail
	if [[ ! "$(busybox)" ]]; then #allow non-Busybox users to continue.
		bb_check=1
		if [[ "$silent_mode" != 1 ]]; then
			echo "Busybox does not exist! Busybox is required for best compatibility!"
		fi
		if [[ "$cmd" ]]; then
			if [[ "$cmd" -lt 0 ]]; then
				cmd=0
			fi
		else
			cmd=224
		fi
		for i in $(seq -s ' $cmd' 0 $cmd | sed 's/^0//'); do
			v=$(eval echo $i)
			if [[ "$v" ]]; then
				if [[ ! "$(which $v)" ]]; then
					if [[ "$silent_mode" != 1 ]]; then
						echo "required applet: '$v' does not exist!"
					fi
					fail=1 #fail later
				fi
			else
				break #reduce cycle
			fi
		done
	else
		busyboxloc=$(dirname $(which busybox))
		n=0
		for i in $(echo $PATH | sed 's/:/ /g'); do
			n=$(($n+1))
			export slot$n=$i
			if [[ "$i" == "$busyboxloc" ]]; then
				busyboxenv=slot$n
			fi
		done
		if [[ "$busyboxenv" != slot1 ]]; then
			export PATH=$(echo -n $busyboxloc
			for i in $(seq -s ' $slot' 0 $n | sed 's/^0//'); do
				v=$(eval echo $i)
				if [[ "$v" != "$busyboxloc" ]]; then
					echo -n ":$v"
				fi
			done)
		fi
		if [[ "$cmd" ]]; then
			if [[ "$cmd" -lt 0 ]]; then
				cmd=0
			fi
		else
			cmd=224
		fi
		for i in $(seq -s ' $cmd' 0 $cmd | sed 's/^0//'); do
			v=$(eval echo $i)
			if [[ "$v" ]]; then
				if [[ ! "$(busybox | grep "\<$v\>")" ]]; then
					if [[ "$silent_mode" != 1 ]]; then
						echo -n "required applet: '$v' not embedded in Busybox!"
					fi
					if [[ ! "$(which $v)" ]]; then
						if [[ "$silent_mode" != 1 ]]; then
							echo "...and also does not exist!"
						fi
						fail=1 #fail later
					else
						if [[ "$silent_mode" != 1 ]]; then
							echo
						fi
					fi
				fi
				if [[ ! -e "$busyboxloc"/"$v" ]]; then
					alias $i="busybox $i"
				fi
			else
				break #reduce cycle
			fi
		done
	fi 2>/dev/null
	if [[ "$fail" == 1 ]]; then #the fail manager!
		echo -e "process terminated. \e[1;31m\"error code 1\"\e[0m"
		return 1
	fi
}

# Check Superuser.
su_check= # root availability
Superuser(){
	su_check=0
	if [[ "$(id | tr '(' ' ' | tr ' ' '\n' | grep uid | sed 's/uid=//g')" != 0 ]]; then
		su_check=1
		echo "Permission denied, are you root?"
		return 1
	fi
}

# Session behaviour
Roll_Down(){
	local return
	if [[ "$run_Busybox_Applet_Generator" == 1 ]]; then
		Busybox_Applet_Generator
		return=$?
		if [[ "$return" -ne 0 ]]; then
			exit $return
		fi
	fi
	if [[ "$run_Superuser" == 1 ]]; then
		Superuser
		return=$?
		if [[ "$return" -ne 0 ]]; then
			exit $return
		fi
	fi
	if [[ "$install" == 1 ]]; then
		install
		return=$?
		exit $return
	fi
}
Roll_Down


process=$1
suddencharge=$2
sleep=$3

task(){
	stat=$(cat /proc/$1/task/$2/stat)
	rm=${stat#*)}
	last_prio=$(echo $rm | cut -d' ' -f17)
	proctime=$(echo $rm | cut -d' ' -f12)
	while true
	do
		if [[ ! $(cat /proc/$1/task/$2/stat) ]]; then
			exit
		fi
		prev_proctime=$proctime
		stat=$(cat /proc/$1/task/$2/stat)
		rm=${stat#*)}
		proctime=$(echo $rm | cut -d' ' -f12)
		buffer=$(awk 'BEGIN{printf "%d\n", ('"$proctime"'-'"$prev_proctime"')/'"$4"'}')
		#buffer=$(echo $proctime $prev_proctime $4 | awk '{print ($1-$2)/$3}' | cut -d'.' -f1)
		if [[ $buffer -gt $3 ]]; then
			renice $5 $2
		else
			renice $last_prio $2
		fi
		sleep $4
	done | tee 2>&1 /data/log/skeleton.log
}

fork(){
	until [[ $(pgrep $1) ]]
	do
		sleep 1
	done
	pid=$(pgrep $1)
	if [[ $(ls /proc/$pid/task) ]]; then
		for i in $(ls /proc/$pid/task)
		do
			task $pid $i $2 $3 $4 &
		done
	fi 2>/dev/null
}

#fork $process $suddencharge $sleep $nice

test_task(){
	stat=$(cat /proc/$1/task/$2/stat)
	rm=${stat#*)}
	last_prio=$(echo $rm | cut -d' ' -f17)
	proctime=$(echo $rm | cut -d' ' -f12)
	while true
	do
		if [[ ! $(cat /proc/$1/task/$2/stat) ]]; then
		exit
	fi
	prev_proctime=$proctime
	stat=$(cat /proc/$1/task/$2/stat)
	rm=${stat#*)}
	proctime=$(echo $rm | cut -d' ' -f12)
	buffer=$(awk 'BEGIN{printf "%d\n", ('"$proctime"'-'"$prev_proctime"')/'"$4"'}')
	#buffer=$(echo $proctime $prev_proctime $4 | awk '{print ($1-$2)/$3}' | cut -d'.' -f1)
	if [[ $buffer -gt $3 ]]; then
		renice $5 $2
	else
		renice $last_prio $2
	fi
	sleep $4
	done | tee 2>&1 /data/log/skeleton.log
}



#exit

#todo: limit threads that illegaly use -20.
#top

testdebug(){
	process=$1
	sleep=$2
	if [[ ! $sleep ]]; then
		sleep=5
	fi
	while true
	do
		gprocess=$(pgrep $process)
		if [[ "$gprocess" ]]; then
			for i in $(ls /proc/$gprocess/task); do
				echo -e "\e[1;31m$(cat /proc/$gprocess/task/$i/comm)\e[0m -> \e[1;32m$(cat /proc/$gprocess/task/$i/wchan)\e[0m"
				stat=$(cat /proc/$gprocess/task/$i/stat)
				rm=${stat#*)}
				nicelevel=$(echo $rm | cut -d' ' -f17)
				echo "nicelevel:$nicelevel"
				echo -e $(cat /proc/$gprocess/task/$i/stat)
				if [[ "$3" == 1 ]]; then
					if [[ $(grep -i 'congestion\|0\|linux' /proc/$gprocess/task/$i/wchan) ]] && [[ $(cat /proc/$gprocess/comm) == $(cat /proc/$gprocess/task/$i/comm) ]]; then
						pid=$i
						renice -20 $i
					else
						if [[ $pid != $i ]] && [[ $nicelevel -le -16 ]]; then
							#if [[ $(grep -i 'audio' /proc/$gprocess/task/$i/comm) ]]; then
								renice 19 $i
							#else
								#renice 0 $i
							#fi
						fi
					fi
				fi
				echo
			done
		else
			echo waiting...
		fi
		sleep $sleep
		echo
		echo
		echo
		long_line 2
	done | tee 2>&1 /data/log/shit.txt
}

test(){
	process=$1
	sleep=$2
	if [[ ! $sleep ]]; then
		sleep=5
	fi
	echo waiting...
	until [[ $(pgrep $process) ]]; do sleep 1; done
	while true; do
		gprocess=$(pgrep $process)
		if [[ "$gprocess" ]]; then
			clear
			echo pid $gprocess is being monitored.
			for i in $(ls /proc/$gprocess/task); do
				stat=$(cat /proc/$gprocess/task/$i/stat)
				rm=${stat#*)}
				nicelevel=$(echo $rm | cut -d' ' -f17)
				echo $i $nicelevel $(cat /proc/$gprocess/task/$i/wchan)
				if [[ $(grep -i 'congestion\|0\|linux' /proc/$gprocess/task/$i/wchan) ]] && [[ $(cat /proc/$gprocess/comm) == $(cat /proc/$gprocess/task/$i/comm) ]] && [[ $gprocess != $i  ]]; then
					pid=$i
					if [[ $3 != 1 ]]; then
						renice -20 $i
					else
						chrt -f -p 1 $i
					fi
				else
					if [[ $pid != $i ]] && [[ $nicelevel -le -16 ]]; then
						#if [[ $(grep -i 'audio' /proc/$gprocess/task/$i/comm) ]]; then
							renice 19 $i
						#else
							#renice 0 $i
						#fi
					fi
				fi
			done
		else
			echo process ended.
			break
		fi
		sleep $sleep
	done
}

#test range!
#echo $version #show version number
#echo $BASE_NAME
#echo $DIR_NAME
#echo $FULL_NAME
#print_PARTIAL_DIR_NAME 1 #print home directory(will work only when DIR_NAME works)
#print_RANDOM_BYTE #print random number upto 32767

echo thread priority manager beta v0.1
echo only tested in applications that use congestion_wait sched!
long_line 1
if [[ ! "$(echo $(install -i) | grep $DIR_NAME | sed 's/ //g')" ]]; then
	echo "type 'install' to begin installation!"
else
	echo 'test [app name] [interval] [rt_sched]'
	echo '-useful for processes that use congestion_wait scheduler'
	echo 'fork [app name] [throttle] [interval(float)] [niceness]'
	echo '-useful for preventing processes that randomly spark their thread priority to max'
fi
debug_shell

exit 0 #EOF