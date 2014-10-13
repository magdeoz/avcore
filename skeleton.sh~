# Custom settings for session behaviour
# values for all settings should either be 1 or 0.
# Check Busybox Applet Generator 2.4.
run_Busybox_Applet_Generator=1
# Check Superuser.
run_Superuser=
# Use /dev/urandom for print_RANDOM_BYTE.
use_urand=
until [[ "$1" != verbose ]] && [[ "$1" != supass ]] && [[ "$1" != bbpass ]] && [[ "$1" != urand ]]; do
	if [[ "$1" == verbose ]]; then
		set -x
	elif [[ "$1" == supass ]] && [[ "$run_Superuser" != 0 ]]; then
		readonly run_Superuser=0
	elif [[ "$1" == bbpass ]] && [[ "$run_Busybox_Applet_Generator" != 0 ]]; then
		readonly run_Busybox_Applet_Generator=0
	elif [[ "$1" == urand ]] && [[ "$use_urand" != 1 ]]; then
		readonly use_urand=1
	fi
	shift
done
readonly skeleton_ver="0.0.1"
readonly BASE_NAME=$(basename $0)
reg_name=$(which $BASE_NAME)
if [[ ! "$reg_name" ]]; then
	echo "you are not running this program in proper location. this may cause trouble for codes that use this function: DIR_NAME"
	readonly DIR_NAME="NULL" #'NULL' will go out instead of an actual directory name
else
	readonly DIR_NAME=$(dirname $(which $BASE_NAME))
fi
readonly FULL_NAME=$(echo $DIR_NAME/$BASE_NAME)
print_PARTIAL_DIR_NAME(){
	echo $(echo $DIR_NAME | tr -s / \\n | head -n$(($1+1))	| tr -s \\n / | sed 's/\/$//')
}
readonly ROOT_DIR=$(print_PARTIAL_DIR_NAME 1)
print_RANDOM_BYTE(){
	if [[ "$use_urand" != 1 ]]; then
		echo $(($(od -An -N2 -i /dev/random)%32767))
	else
		echo $(($(od -An -N2 -i /dev/urandom)%32767))
	fi
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
cmd= # It notifies the generator how many cmds are available for check. Leave it as blank.

silent_mode=1 # enabling this will hide errors.
# This feature might not be compatible with some other multi-call binaries.
# if similar applets are found and Busybox do not have them, it will still continue but leave out some error messages regarding compatibility issues.
Busybox_Applet_Generator(){
	local n i busyboxloc busyboxenv fail
	if [[ ! "$(busybox)" ]]; then #allow non-Busybox users to continue.
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
Superuser(){
	if [[ "$(grep -i "^Uid:" /proc/$$/status | awk '{print $2}')" != 0 ]]; then
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
}
Roll_Down

#test range!
echo $skeleton_ver #show version number
echo $BASE_NAME
echo $DIR_NAME
echo $FULL_NAME
print_PARTIAL_DIR_NAME 1 #print home directory(will work only when DIR_NAME works)
print_RANDOM_BYTE #print random number upto 32767

exit 0 #EOF
