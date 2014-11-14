# Custom settings for session behaviour
# values for all settings should either be 1 or 0.
# Check Busybox Applet Generator 2.4.
run_Busybox_Applet_Generator=1
# Check Superuser.
run_Superuser=
# Use /dev/urandom for print_RANDOM_BYTE.
use_urand=1
# invert print_RANDOM_BYTE.
invert_rand=1
until [[ "$1" != --verbose ]] && [[ "$1" != --supass ]] && [[ "$1" != --bbpass ]] && [[ "$1" != --urand ]] && [[ "$1" != --invrand ]] && [[ "$1" != --renice ]]; do
	if [[ "$1" == --verbose ]]; then
		set -x
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
readonly CLEAN_NAME=$(echo $BASE_NAME | sed 's/\..*//')
readonly backup_PATH=$PATH
readonly set_PATH=$(dirname $0 | sed 's/^\.//')
readonly set_PATH2=$(pwd)
if [[ "$set_PATH" ]]; then
	if [[ "$(ls / | grep $(echo $set_PATH | tr -s / \\n | head -n2	| tr -s \\n / | sed 's/\/$//' | sed 's/^\///'))" ]] ; then
		export PATH=$PATH:$set_PATH
	else
		export PATH=$PATH:$set_PATH2
	fi
else
	export PATH=$PATH:$set_PATH2
fi
reg_name=$(which $BASE_NAME 2>/dev/null)
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
	echo $n hits.
	for i in $(seq -s ' $slot' 0 $n | sed 's/^0//'); do
		v=$(eval echo $i)
		echo -n "would you like to install it in $v? (y/n) "
		while true; do
			read f
			case $f in
				y* | Y*)
					loc=$v
					break
				;;
				n* | N*)
					break
				;;
				q* | Q*)
					return 0
				;;
				*)
					random=$(print_RANDOM_BYTE)
					random=$((random%4+1))
					if [[ "$random" -eq 1 ]]; then
						echo -n 'what? '
					elif [[ "$random" -eq 2 ]]; then
						echo -n 'i dont understand. '
					elif [[ "$random" -eq 3 ]]; then
						echo -n 'come on mate, you could do better than that! '
					elif [[ "$random" -eq 4 ]]; then
						echo -n 'if i were you, i would choose the chicken. '
					fi
				;;
			esac
		done
		if [[ "$loc" ]]; then
			break
		fi
	done
	if [[ ! "$loc" ]]; then
		echo couldnt install, sorry. :p
		return 1
	fi
	echo 'please wait...'
	loc_DIR_NAME=$(echo $loc | tr -s / \\n | head -n2	| tr -s \\n / | sed 's/\/$//')
	mountstat=$(grep $loc_DIR_NAME /proc/mounts | head -n1)
	echo -n 'mounting...'
	if [[ "$mountstat" ]]; then
		if [[ "$(echo $mountstat | grep ro)" ]]; then
			ro=1
			mount -o remount,rw $loc_DIR_NAME
		fi
		if [[ "$(echo $mountstat | grep rw)" ]]; then
			echo -e '\rcopying files...'
			cp $0 $loc/$CLEAN_NAME
			if [[ "$?" == 1 ]]; then
				return 1
			fi
			chmod 755 $loc/$CLEAN_NAME
			if [[ "$ro" == 1 ]]; then
				mount -o remount,ro $loc_DIR_NAME
			fi
		else
			error=1
		fi
	else
		error=1 # exception error
	fi
	if [[ "$error" == 1 ]]; then
		echo -e "internal error! please use '--verbose' and try again. \e[1;31m\"error code 1\"\e[0m"
		return 1
	else
		long_line cols 2
		echo install complete!
		echo type $CLEAN_NAME to run the program!
	fi
}
long_line(){
	tcount=$(tput $1)
	for i in $(seq 1 $tcount); do
		if [[ "$2" -le 1 ]]; then
			echo -n '-'
		else
			echo -n '='
		fi
	done
	echo
}
# chklnk.sh
#
# Copyright (C) 2013-2015  hoholee12@naver.com
#
# Everyone is permitted to copy and distribute verbatim copies
# of this code, but changing it is not allowed.
#
# Changelogs:
# alpha version
# 0.0.1 - first release
# 0.0.2 - permission error support added.
#       - revamped return command.
#       - some codes borrowed from avcore.sh
#       - skeleton.sh

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
su_check= # root availability
Superuser(){
	su_check=0
	if [[ "$(grep -i "^Uid:" /proc/$$/status | awk '{print $2}')" != 0 ]]; then
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
}
Roll_Down

# Main script
case $1 in
	-h | --help)
		echo "$BASE_NAME v$version
Copyright (C) 2013-2014 hoholee12@naver.com
Usage: $BASE_NAME [LOCATION] -h
"
		shift
		exit 0
	;;
	*)
		if [[ ! "$1" ]]; then
			exit 0
		fi
	;;
esac
file=$1
dir=$(dirname $file)
base=$(basename $file)
if [ ! -e "$file" ] && [ ! -d "$file" ]; then
	echo "$file: not found"
	exit 127
fi
count=0
for i in $(ls -l $dir | grep $base | head -1); do
	count=$((count+1))
	if [ "$i" == "->" ]; then
		found=y
		break
	fi
done 2>/dev/null
return=$?
if [ "$return" != 0 ]; then
	echo "$file: operation not permitted"
	exit $return
fi
if [ ! "$found" ] || [ "$file" == "/" ]; then
	echo "$file: is not a symlink"
	exit 1
fi
#link=$((count-1))
orig=$((count+1))
linked_file=$(ls -l $dir | grep $base | head -1 | awk '{print $'"$orig"'}')
echo "$linked_file"

exit 0 #EOF