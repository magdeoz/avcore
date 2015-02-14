# Custom settings for session behaviour
# values for all settings should either be 1 or 0.(boolean)
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
readonly version="0.0.2"
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
			echo -n -e "\rwould you like to install it in $v? (y/n) "
			while true; do
				stty cbreak -echo
				f=$(dd bs=1 count=1 2>/dev/null)
				stty -cbreak echo
				echo $f
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
			echo -n 'program file already exists. overwrite? (y/n) '
			while true; do
				stty cbreak -echo
				f=$(dd bs=1 count=1 2>/dev/null)
				stty -cbreak echo
				echo $f
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
	CUSTOM_DIR=$(echo $CUSTOM_DIR | sed 's/\/$//')
	if [[ "$CUSTOM_DIR" ]]; then
		date '+date: %m/%d/%y%ttime: %H:%M:%S ->'"$message"'' >> $CUSTOM_DIR/$NO_EXTENSION.log
	else
		date '+date: %m/%d/%y%ttime: %H:%M:%S ->'"$message"'' >> $DIR_NAME/$NO_EXTENSION.log
	fi
}
# sched_tuner.sh
#
# Copyright (C) 2013-2015  hoholee12@naver.com
#
# Everyone is permitted to copy and distribute verbatim copies
# of this code, but changing it is not allowed.
#
# Changelogs:
# 0.0.1 - first release
# 0.0.2 - init.d added

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

detect_feature(){
	n_cycle=0
	for i in $@; do #needs special input
		n_cycle=$((n_cycle+1))
		export mslot$n_cycle=$i #export to mslot# since slot# is taken.
	done
}
detect_feature $(cat /sys/kernel/debug/sched_features) #init neccessary!
list_feature(){
	for j in $(seq -s ' $mslot' 0 $n_cycle | sed 's/^0 //'); do #retrieve mslot#
		v=$(eval echo $j)
		echo -n "$v " | sed 's/^NO_//'
		if [[ ! "$(echo $v | grep '^NO_')" ]]; then
			echo -e '\e[1;31mis ON.\e[0m'
		else
			echo -e '\e[1;32mis OFF.\e[0m'
		fi
	done
}
apply_SS(){
	#WIP
	for i in $(cat /sys/kernel/debug/sched_features | sed 's/\<NO_//g'); do
		echo NO_$i > /sys/kernel/debug/sched_features
	done
}
# Main script
case $1 in
	-h | --help)
		echo "$BASE_NAME v$version
Copyright (C) 2013-2015 hoholee12@naver.com
Usage: $BASE_NAME -a | --activate [on/off] -h | --help
       $BASE_NAME -l lists all sched_features.
"
		shift
		exit 0
	;;
	-a | --activate)
		apply_SS
		CUSTOM_DIR=/data/log
		if [[ "$?" == 1 ]]; then
			error something went wrong.
			exit 1
		fi
		error init complete!
		exit 0
	;;
	-l | --list)
		list_feature
		exit 0
	;;
esac


backup_feature(){
	if [[ "$EXTERNAL_STORAGE" ]]; then
		if [[ ! -f $EXTERNAL_STORAGE/sched_tuner/init.bak ]]; then
			mkdir $EXTERNAL_STORAGE/sched_tuner
			echo $(cat /sys/kernel/debug/sched_features) > $EXTERNAL_STORAGE/sched_tuner/init.bak
		fi
		external="$EXTERNAL_STORAGE/sched_tuner"
	else
		if [[ ! -f /data/sched_tuner/init.bak ]]; then
			mkdir /data/sched_tuner
			echo $(cat /sys/kernel/debug/sched_features) > /data/sched_tuner/init.bak
		fi
		external=/data/sched_tuner
	fi
}
apply_backup(){
	if [[ "$EXTERNAL_STORAGE" ]]; then
		if [[ ! -f $EXTERNAL_STORAGE/sched_tuner/init.bak ]]; then
			if [[ ! -f /data/sched_tuner/init.bak ]]; then
				echo there is no backup!
				return 1
			else
				for i in $(cat /data/sched_tuner/init.bak); do
					echo $i > /sys/kernel/debug/sched_features
				done
			fi
		else
			for i in $(cat $EXTERNAL_STORAGE/sched_tuner/init.bak); do
				echo $i > /sys/kernel/debug/sched_features
			done
		fi
	else
		if [[ ! -f /data/sched_tuner/init.bak ]]; then
			if [[ ! -f $EXTERNAL_STORAGE/sched_tuner/init.bak ]]; then
				echo there is no backup!
				return 1
			else
				for i in $(cat $EXTERNAL_STORAGE/sched_tuner/init.bak); do
					echo $i > /sys/kernel/debug/sched_features
				done
			fi
		else
			for i in $(cat /data/sched_tuner/init.bak); do
				echo $i > /sys/kernel/debug/sched_features
			done
		fi
	fi
	if [[ -f /system/etc/init.d/sched_tuner_task ]]; then
		cp $external/init.rc.bak /init.rc
		chmod 755 /init.rc
		chmod 755 /system/etc/init.d/sched_tuner_task
		rm /system/etc/init.d/sched_tuner_task
	fi
}
initialize(){
	mkdir -p /system/etc/init.d
	chmod 755 /system/etc/init.d
	echo "#!/system/bin/sh
until [[ -f $FULL_NAME ]]; do
	sleep 1
done
$FULL_NAME -a" > /system/etc/init.d/sched_tuner_task
	chmod 755 /system/etc/init.d/sched_tuner_task
	chmod 755 /init.rc
	if [[ ! -f $external/init.rc.bak ]]; then
		cp /init.rc $external/init.rc.bak
	fi
	echo "

service sched_tuner_task /system/etc/init.d/sched_tuner_task
     user root
     oneshot" >> /init.rc
}
main(){
	while true; do
		clear
		echo "scheduling features tuner v$version
"
		backup_feature
		echo current scheduling features list:
		detect_feature $(cat /sys/kernel/debug/sched_features) #recycled crap
		list_feature
		if [[ -f /system/etc/init.d/sched_tuner_task ]]; then
			echo -e '\e[1;33mlooks like the mod is already installed.\e[0m'
		else
			echo -e '
generally, \e[1;32mGREEN\e[0m is considered OK, while \e[1;31mRED\e[0m is NOT OK.
'
		fi
		long_line 1
		echo 'select an option:
1)disable everything(speedhack!)
2)set the tweak on boot(init.rc)
3)backup list
4)restore list
5)refresh list
6)exit'
		stty cbreak -echo
		f=$(dd bs=1 count=1 2>/dev/null)
		stty -cbreak echo
		echo $f
		long_line 2
		case $f in
			1)
				echo -n applying tweaks...
				apply_SS
				echo done!
				sleep 5
			;;
			2)
				echo -n setting on boot...
				initialize
				echo done!
				sleep 5
			;;
			3)
				echo backup already exists.
				sleep 5
			;;
			4)
				echo -n restoring backup...
				apply_backup
				if [[ $? -eq 1 ]]; then
					echo -e '\rcould not restore backup.'
					return 1
				fi
				echo done!
				sleep 5
			;;
			5)
				echo refreshing...
				sleep 0.5
			;;
			6| q |Q)
				return 0
			;;
			*)
				echo typo! try again.
				sleep 1
			;;
		esac
	done
}
main


exit 0 #EOF