# Custom settings for session behaviour
# values for all settings should either be 1 or 0.(boolean)
# run bb_apg_2 at start.
run_bb_apg_2=1
# Check Superuser.
run_as_root=1
# Use /dev/urandom for print_RANDOM_BYTE.
use_urand=1
# invert print_RANDOM_BYTE.
invert_rand=1
# launch install() at start.(ONLY FOR REFERENCE, DON'T TOUCH!)
install=0
# launch debug_shell() at start.
debug=0
# Bourne-again Shell only.
bash_only=1
until [[ "$1" != --debug ]] && [[ "$1" != --verbose ]] && [[ "$1" != --supass ]] && [[ "$1" != --bbpass ]] && [[ "$1" != --urand ]] && [[ "$1" != --invrand ]] && [[ "$1" != --renice ]] && [[ "$1" != --install ]]; do
	if [[ "$1" == --debug ]]; then
		if [[ "$install" == 1 ]]; then
			echo cannot launch two overlapping parameters at a time.
			break
		fi
		readonly debug=1
	elif [[ "$1" == --verbose ]]; then
		set -x
	elif [[ "$1" == --install ]]; then
		if [[ "$debug" == 1 ]]; then
			echo cannot launch two overlapping parameters at a time.
			break
		fi
		readonly install=1
		shift
		save_args=$@
		break
	elif [[ "$1" == --supass ]] && [[ "$run_as_root" != 0 ]]; then
		readonly run_as_root=0
	elif [[ "$1" == --bbpass ]] && [[ "$run_bb_apg_2" != 0 ]]; then
		readonly run_bb_apg_2=0
	elif [[ "$1" == --urand ]] && [[ "$use_urand" != 1 ]]; then
		readonly use_urand=1
	elif [[ "$1" == --invrand ]] && [[ "$invert_rand" != 1 ]]; then
		readonly invert_rand=1
	elif [[ "$1" == --renice ]]; then
		if [[ ! "$(echo $2 | sed 's/[0-9]//g' | sed 's/^-//')" ]]; then
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
readonly version="1.0.5"
readonly BASE_NAME=$(basename $0)
readonly NO_EXTENSION=$(echo $BASE_NAME | sed 's/\..*//')
readonly backup_PATH=$PATH
readonly set_PATH=$(dirname $0 | sed 's/^\.//')
readonly set_PATH2=$(pwd)
if [[ "$set_PATH" ]]; then
	if [[ "$(ls / | grep $(echo $set_PATH | sed 's/\//\n/g' | head -n2 | sed ':a;N;s/\n//g;ba'))" ]] ; then
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
	echo $(echo $DIR_NAME | sed 's/\//\n/g' | head -n$(($1+1)) | sed ':a;N;s/\n/\//g;ba')
}
readonly ROOT_DIR=$(print_PARTIAL_DIR_NAME 1)
print_RANDOM_BYTE(){
	if [[ "$BASH" ]]&&[[ "$RANDOM" ]]; then
		echo $RANDOM
	else
		bb_apg_2 -f od
		if [[ "$?" == 1 ]]; then
			error critical command missing. \"error code 2\"
			exit 2
		fi
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
	fi
}

# Checkers 1.0
# You can type in any strings you would want it to print when called.
# It will start by checking from chk1, and its limit is up to chk20.
chk1=what?
chk2="i dont understand!"
chk3=pardon?
chk4="are you retarded?"
checkers(){
	for i in $(seq 1 20); do
		if [[ ! "$(eval echo \$chk$i)" ]]; then
			i=$((i-1))
			break
		fi
	done
	random=$(print_RANDOM_BYTE)
	random=$((random%i+1))
	echo -n -e "\r$(eval echo \$chk$random) "
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
			randtest | test9) #test9 version.
				trap "echo -e \"\e[2JI LOVE YOU\"; exit" 2
				while true; do
					random=$(print_RANDOM_BYTE)
					x_axis=$((random%$(($(stty size | awk '{print $2}' 2>/dev/null)-1))))
					random=$(print_RANDOM_BYTE)
					y_axis=$((random%$(stty size | awk '{print $1}' 2>/dev/null)))
					random=$(print_RANDOM_BYTE)
					color=$((random%7+31))
					echo -e -n "\e[${y_axis};${x_axis}H\e[${color}m0\e[0m"
				done
			;;
			help)
				echo -e "this debug shell is \e[1;31mONLY\e[0m used for testing conditions inside this program!
you can now use '>' and '>>' for output redirection. use along with 'set -x' for debugging purposes.
use 'export' if you want to declare a variable.
such includes:
	-functions
	-variables
	-built-in sh or bash commands

instead, you can use these commands built-in to this program:
	-print_PARTIAL_DIR_NAME
	-print_RANDOM_BYTE
	-bb_apg_2
	-as_root
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
				if [[ "$(echo $i | grep '>')" ]]; then
					if [[ "$(echo $i | grep '>>')" ]]; then
						i=$(echo $i | sed 's/>>/>/')
						if [[ "$(echo $i | cut -d'>' -f1)" ]]; then
							first_comm=$(echo $i | cut -d'>' -f1)
							second_comm=$(echo $i | sed 's/2>&1//' | cut -d'>' -f2)
							if [[ "$(echo $i | grep '2>&1')" ]]; then
								eval $first_comm >> $second_comm 2>&1
							else
								eval $first_comm >> $second_comm
							fi
						fi
					else
						if [[ "$(echo $i | cut -d'>' -f1)" ]]; then
							first_comm=$(echo $i | cut -d'>' -f1)
							second_comm=$(echo $i | sed 's/2>&1//' | cut -d'>' -f2)
							if [[ "$(echo $i | grep '2>&1')" ]]; then
								eval $first_comm > $second_comm 2>&1
							else
								eval $first_comm > $second_comm
							fi
						fi
					fi
				else
					$i
				fi
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
		return 0
	elif [[ "$1" == -s ]]; then
		shift
		for i in $(seq -s ' $slot' 0 $n | sed 's/^0//'); do
			if [[ "$(eval echo $i)" == "$1" ]]; then
				echo found it!
				loc=$1
				break
			fi
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
						checkers
					;;
				esac
				echo -n press \'q\' to quit.
			done
			if [[ "$loc" ]]; then
				break
			fi
		done
	fi
	if [[ ! "$loc" ]]; then
		echo couldnt install, sorry. :p
		return 1
	fi
	echo -e '\rplease wait...'
	loc_DIR_NAME=$(echo $loc | sed 's/\//\n/g' | head -n2 | sed ':a;N;s/\n/\//g;ba')
	mountstat=$(mount | grep $loc_DIR_NAME | head -n1)
	availperm=$(echo $mountstat | grep 'ro\|rw')
	if [[ "$availperm" ]]; then #linux else unix
		if [[ "$(echo $availperm | grep ro)" ]]; then
			ro=1
			echo -n -e '\rmounting...'
			mount -o remount,rw $loc_DIR_NAME
		else
			ro=0
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
					checkers
				;;
			esac
		done
	fi
	echo -n -e '\rcopying files...'
	if [[ "$DIR_NAME" == NULL ]]; then
		cp $0 $loc/$NO_EXTENSION
	else
		cp $FULL_NAME $loc/$NO_EXTENSION
	fi
	error=$?
	chmod 755 $loc/$NO_EXTENSION
	if [[ "$ro" == 1 ]]; then
		mount -o remount,ro $loc_DIR_NAME
	fi
	unset loc
	if [[ "$error" != 0 ]]; then
		echo -e "internal error! please use '--verbose' and try again. \e[1;31m\"error code $error\"\e[0m"
		return 1
	else
		echo
		long_line 2
		echo install complete!
		echo type \'$NO_EXTENSION\' to run the program!
	fi
}
long_line(){
	if [[ "$1" -gt 1 ]]; then
		echo -n -e '\e[3m'
	fi
	for i in $(seq 1 $(stty size | awk '{print $2}' 2>/dev/null)); do
		if [[ "$1" -le 1 ]]; then
			echo -n '_'
		else
			echo -n ' '
		fi
	done
	if [[ "$i" == 1 ]]; then
		echo -n -e '\r'
		for j in $(seq 1 80); do # 80 columns
			if [[ "$1" -le 1 ]]; then
				echo -n '_'
			else
				echo -n ' '
			fi
		done
	fi
	echo -e '\e[0m'
}
part_line(){
	count=$(echo $@ | wc -c)
	for i in $(seq 1 $(($(stty size | awk '{print $2}' 2>/dev/null)-count))); do
		echo -n '_'
	done
	echo $@
}
error(){
	message=$@
	if [[ "$(echo $message | grep \")" ]]; then
		echo -n $message | sed 's/".*//'
		errmsg=$(echo $message | cut -d'"' -f2)
		echo -e "\e[1;31m\"$errmsg\"\e[0m"
	else
		echo $message
	fi
	CUSTOM_DIR=$(echo $CUSTOM_DIR | sed 's/\/$//')
	cd /
	for i in $(echo $CUSTOM_DIR | sed 's/\//\n/g'); do
		if [[ ! -d $i ]]; then
			mkdir $i
			chmod 755 $i
		fi
		cd $i
	done
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
# May be freely distributed and modified as long as copyright
# is retained.
#
# Changelogs:
# 0.0.1 - first release
# 0.0.2 - init.d added
# 0.0.3 - new bootup tweaks and bugfixes added
# 0.0.4 - future-proof bugfixes
# 0.0.5 - more boot tweaks added
# 0.0.6 - mpengine added for performance
# 0.0.7 - audiofix added for single core devices
#       - changed license policy
#       - tweaked scAudioFix(update1)
#       - bugfixed scAudioFix(update2)
# 0.0.8 - advanced scAudioFix
#       - tweaked Android startup(update1)
# 0.0.9 - mpengine removed
#       - rtmixman added for AMM performance
#       - tweaked Android startup(update1)
#       - tweaked rtmixman(update1)
#       - rtmixman heapgrowthlimit support(update2)
# 1.0.0 - wakelock_sheriff added for battery life
# 1.0.1 - more details & potential bugfixes
# 1.0.2 - more critical bugfixes
# 1.0.3 - more error msgs for debugging
#       - wakelock_sheriff whitelist enabled
# 1.0.4 - more clear instructions on how to whitelist apps added
# 1.0.5 - thread_booster added for performance

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
cmd10=cp
cmd11=cut
cmd= # It notifies the generator how many cmds are available for check. Leave it as blank.

silent_mode= # enabling this will hide errors.
# This feature might not be compatible with some other multi-call binaries.
# if similar applets are found and Busybox do not have them, it will still continue but leave out some error messages regarding compatibility issues.
bb_check= # BB availability.
bb_apg_2(){
	if [[ "$1" == -f ]]; then
		shift
		used_fopt=1
	elif [[ "$1" == -g ]]; then
		shift
		used_gopt=1
	fi
	if [[ "$used_fopt" == 1 ]]||[[ "$used_gopt" == 1 ]]; then
		silent_mode=1
		if [[ "$cmd" ]]; then
			if [[ "$cmd" -lt 0 ]]; then
				cmd=0
			fi
		else
			cmd=224
		fi
		for i in $(seq -s ' $cmd' 0 $cmd | sed 's/^0//'); do
			v=$(eval echo $i)
			x=$(echo $i | sed 's/^\$//')
			export $x=$v #export everything.
			if [[ "$v" ]]; then
				unset $x
			else
				break #reduce cycle
			fi
		done
		for j in $(seq 1 $cmd); do
			if [[ ! "$1" ]]; then
				break
			fi
			export cmd$j=$1
			shift
		done
		export cmd=$j #this will reduce more cycles.
	fi
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
			x=$(echo $i | sed 's/^\$//')
			export $x=$v #export everything.
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
			x=$(echo $i | sed 's/^\$//')
			export $x=$v #export everything.
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
	if [[ "$used_gopt" == 1 ]]&&[[ "$bb_check" == 1 ]]; then
		fail=1 #used_gopt is NOT recommended, unless needed for specific use.
	fi
	if [[ "$fail" == 1 ]]; then #the fail manager!
		if [[ "$used_fopt" == 1 ]]||[[ "$used_gopt" == 1 ]]; then
			unset used_fopt
			unset used_gopt
			return 1
		fi
		echo -e "process terminated. \e[1;31m\"error code 1\"\e[0m"
		return 1
	fi
}

# Check Superuser.
su_check= # root availability
as_root(){
	bb_apg_2 -f id grep sed
	if [[ "$?" == 1 ]]; then
		error critical command missing. run with --supass for bypassing root check. \"error code 2\"
		exit 2
	fi
	su_check=0
	if [[ "$(id | sed 's/(/ /g' | sed 's/ /\n/g' | grep uid | sed 's/uid=//g')" != 0 ]]; then
		su_check=1
		echo "Permission denied, are you root?"
		return 1
	fi
}

bash_check=
bash_only(){
	bash_check=0
	if [[ ! "$BASH" ]]; then
		bashloc=$(which bash)
		if [[ "$bashloc" ]]; then
			$bashloc $FULL_NAME $@
			exit $?
		fi
		bash_check=1
		error Please re-run this program with BASH. \"error code 1\" #to pass the double-quote character to the error function, you must use the inverted-slash character.
		exit 1
	fi
}

# Session behaviour
Roll_Down(){
	local return
	
	#first run
	if [[ "$run_bb_apg_2" == 1 ]]; then
		bb_apg_2
		return=$?
		if [[ "$return" -ne 0 ]]; then
			exit $return
		fi
	fi
	if [[ "$run_as_root" == 1 ]]; then
		as_root
		return=$?
		if [[ "$return" -ne 0 ]]; then
			exit $return
		fi
	fi
	if [[ "$bash_only" == 1 ]]; then
		bash_only $@
		return=$?
		if [[ "$return" -ne 0 ]]; then
			exit $return
		fi
	fi
	
	#second run
	if [[ "$debug" == 1 ]]; then
		debug_shell
		return=$?
		exit $return
	fi
	if [[ "$install" == 1 ]]; then
		install $save_args
		return=$?
		exit $return
	fi
}
Roll_Down $@

CUSTOM_DIR=/data/log #log location
if [[ ! -f /sys/kernel/debug/sched_features ]]; then
	bb_apg_2 -g mount
	if [[ "$?" == 1 ]]; then
		error critical command missing. make sure you have busybox installed. \"error code 2\"
		exit 2
	fi
	mount -t debugfs none /sys/kernel/debug 2>/dev/null #some kernels have locked debugfs, so we reopen them.(NEED BUSYBOX FOR -t OPTION TO WORK!!!)
	if [[ "$?" != 0 ]]||[[ ! -f /sys/kernel/debug/sched_features ]]; then
		notsupported=1 #reg
	fi
	if [[ ! -f /sys/power/wait_for_fb_wake ]]; then #wait_for_fb_wake added for rtmixman
		no_wakelock=1
		error uh oh, looks like your device doesnt have necessary api to support some mods here. if you are lucky, it might work, otherwise it might glitch out.
		part_line press any key to continue...
		stty cbreak -echo
		f=$(dd bs=1 count=1 2>/dev/null)
		stty -cbreak echo
	fi
fi
mount -o remount,rw rootfs 2>/dev/null #remount rootfs to rw
mount -o remount,rw /system 2>/dev/null #remount system to rw

detect_feature(){
	if [[ "$notsupported" == 1 ]]; then
		echo -e "\e[1;31mnot supported.\e[0m"
	else
		n_cycle=0
		for i in $@; do #needs special input
			n_cycle=$((n_cycle+1))
			export mslot$n_cycle=$i #export to mslot# since slot# is taken.
		done
	fi
}
detect_feature $(cat /sys/kernel/debug/sched_features) #init neccessary!
list_feature(){
	if [[ "$notsupported" == 1 ]]; then
		echo -e "\e[1;31mnot supported.\e[0m"
	else
		for j in $(seq -s ' $mslot' 0 $n_cycle | sed 's/^0 //'); do #retrieve mslot#
			v=$(eval echo $j)
			echo -n "$v " | sed 's/^NO_//'
			if [[ ! "$(echo $v | grep '^NO_')" ]]; then
				echo -e '\e[1;31mis ON.\e[0m'
				notapplied=1 #for extra check
			else
				echo -e '\e[1;32mis OFF.\e[0m'
			fi
		done
	fi
}



thread_booster(){
	sleep=$1
	if [[ ! "$sleep" ]]; then
		sleep=10
	fi
	if [[ "$1" == -f ]]; then
		for i in $(pgrep -l '' | grep '\<org\.\|\<app\.\|\<com\.\|\<android\.' | grep -v -e 'android\.' | awk '{print $1}'); do
			niceness=$(cat /proc/$i/stat)
			niceness=${niceness#*)}
			niceness=$(echo $niceness | awk '{print $17}')
			if [[ "$niceness" == -20 ]]; then
				renice 0 $i
			fi
		done
		rm $external/thread_booster.cfg
		return 0
	fi
	if [[ ! -f $external/thread_booster.cfg ]]; then
		echo '#thread booster config file

settings\|vending' > $external/thread_booster.cfg
	fi
	custom_booster=$(cat $external/thread_booster.cfg | grep -v -e '#' | tail -n1)
	while true; do
		for i in $(pgrep -l '' | grep '\<org\.\|\<app\.\|\<com\.\|\<android\.' | grep -v -i -e $custom_booster | awk '{print $1}'); do
			niceness=$(cat /proc/$i/stat)
			niceness=${niceness#*)}
			niceness=$(echo $niceness | awk '{print $17}')
			if [[ "$(cat /proc/$i/oom_adj)" == 0 ]]; then
				if [[ "$niceness" != -20 ]]; then
					renice -20 $i
				fi
			else
				if [[ "$niceness" == -20 ]]; then
					renice 0 $i
				fi
			fi
		done
		sleep $sleep
		if [[ "$no_wakelock" == 1 ]]; then
			until [[ "$(cat /sys/class/graphics/fb0/show_blank_event)" == "panel_power_on = 1" ]]; do
				sleep 10
			done
		else
			awake=$(cat /sys/power/wait_for_fb_wake)
		fi
	done & echo $! > $external/thread_booster_pid
}


wakelock_sheriff(){
	if [[ "$1" == -f ]]; then
		rm $external/wakelock_sheriff.cfg
		return 0
	fi
	sleep=$1
	if [[ ! "$sleep" ]]; then
		sleep=60 #one-minute.
	fi
	target_usage=$2
	if [[ ! "$target_usage" ]]; then
		target_usage=0 #0%
	fi
	if [[ ! -f $external/wakelock_sheriff.cfg ]]; then
		echo '#wakelock sheriff custom whitelist config file

#how to use:
#-use \| as delimiter
#-e.g.) :remote\|android
#-to add more apps, like com.android.phone for example...
#-e.g.) :remote\|android\|com.android.phone
#-to add more stuff,
#-e.g.) :remote\|android\|com.android.phone\|com.android.launcher\|com.android.blahblahblah.....
#-but guess what? this list is called by grep, so basically you dont need to write any apps that start with "com.android.blahblah..."
#-because it is already whitelisted by this one word: "android"
#-lets say we want to have facebook app whitelisted. but you cannot know what the facebook apps real name is,
#-well you can just write like this: ":remote\|android\|facebook" since it might have "facebook" in that name...
#-e.g.) :remote\|android\|facebook
#-only one line permitted. no newlines!!(former settings will be overwritten by new settings)
#-dont do this!! e.g.)
# :remote\|android
# facebook\|twitter
# ...
#-only "..." will be read!

:remote\|android' > $external/wakelock_sheriff.cfg
	fi
	custom_sheriff=$(cat $external/wakelock_sheriff.cfg | grep -v -e '#' | tail -n1)
	while true; do
		usage=$(top -n1)
		for i in $(pgrep -l '' | grep '\<org\.\|\<app\.\|\<com\.\|\<android\.' | grep -v -i -e $custom_sheriff | awk '{print $1}'); do
			if [[ "$(IFS=''; echo $usage | grep $i | awk '{print $(NF-2)}' | cut -d'.' -f1)" -gt "$target_usage" ]]; then
				kill -9 $i
			fi
		done
		sleep $sleep
		if [[ "$no_wakelock" == 1 ]]; then
			until [[ "$(cat /sys/class/graphics/fb0/show_blank_event)" == "panel_power_on = 0" ]]; do #opposite
				sleep 10
			done
		else
			asleep=$(cat /sys/power/wait_for_fb_sleep)
		fi
	done & echo $! > $external/wakelock_sheriff_pid
}

# Task Killer 1.0
# this program includes:
# target_killer - reads 'exclude_target' and kills the desired ones.
# check_launcher - use this to exclude launcher pid
# debug_space - use this to log details
# task_killer - main program. launch this to start.

exclude_target='^-16\|^-12\|^0\|^1' # exclude target adj
target_killer(){
	for i in $(pgrep -l '' | grep '\<org\.\|\<app\.\|\<com\.\|\<android\.' | grep -v -e ':remote' | awk '{print $1}' | grep -v -e $launcher_pid); do
		if [[ $(grep -v -e $exclude_target /proc/$i/oom_adj) ]]; then
			kill -9 $i
		fi
	done
}

check_launcher(){ # code snippets from boostdemo.sh
	unset launcher_pid
	while true; do
		for launcher in $(grep "<h\>" /data/system/appwidgets.xml | sed 's/ /\n/g' | grep pkg | sed 's/^pkg="//; s/"$//'); do
			launcher_pid=$(pgrep $launcher)
			if [[ "$launcher_pid" ]]; then
				break
			fi
		done
		if [[ "$launcher_pid" ]]; then
			break
		fi
		sleep 1
	done
}

debug_space(){
	space=0
	for i in $(grep -i -e 'memfree\|buffers\|^cached' /proc/meminfo | awk '{print $2}'); do
		space=$((space+i))
	done
	if [[ "$1" == -i ]]; then
		if [[ "$prev_space" ]]; then
			freed=$((space-prev_space))
			if [[ "$freed" -lt 0 ]]; then
				freed=0
			fi
			error freed "$freed"KB of memory.
		fi
		prev_space=$space
	fi
}

task_killer(){
	backuplmk=$(cat /sys/module/lowmemorykiller/parameters/minfree)
	echo "0,0,0,0,0,0" > /sys/module/lowmemorykiller/parameters/minfree
	trap "echo "$backuplmk" > /sys/module/lowmemorykiller/parameters/minfree; exit" EXIT INT TERM
	debug=$1
	if [[ "$debug" == -i ]]; then
		shift
	else
		unset debug
	fi
	sleep=$1
	if [[ ! "$sleep" ]]; then
		sleep=10 #dumpsys refresh time is 10 secs.
	fi
	memlimit=$2
	if [[ ! "$memlimit" ]]; then
		memlimit=$(($(grep -i -e memtotal /proc/meminfo | awk '{print $2}')/2))
	else
		memlimit=$((memlimit*1024))
	fi
	renice 19 $$
	check_launcher
	debug_space
	while true; do
		if [[ "$no_wakelock" == 1 ]]; then
			until [[ "$(cat /sys/class/graphics/fb0/show_blank_event)" == "panel_power_on = 1" ]]; do
				sleep 10
			done
		else
			awake=$(cat /sys/power/wait_for_fb_wake)
		fi
		if [[ "$space" -lt "$memlimit" ]]; then
			target_killer
			if [[ ! "$(pgrep '' | grep "\<$launcher_pid\>")" ]]; then
				check_launcher
			fi
			if [[ "$debug" ]]; then
				debug_space -i
			else
				debug_space
			fi
		else
			debug_space
		fi
		sleep $sleep
	done
}

kill_garbage(){
	#kill garbageprocess 'android.process.media' when the device is sleeping.
	#do not attempt to do anything while user is interacting with the process.
	#the most accurate way to do is to detect garbage process via top command.
	
	#while $(cat /sys/power/wait_for_fb_sleep); do
		#asleep=$(cat /sys/power/wait_for_fb_sleep) #this causes fork bomb, dont use this:p
		garbageprocess=$(top -n1 | grep '{d.process.media}' | grep -v grep | awk '{print $1, $(NF-2)}' | cut -d'.' -f1)
		if [[ "$garbageprocess" ]]&&[[ "$(echo $garbageprocess | awk '{print $2}')" -gt "$1" ]]; then
			kill -9 $(echo $garbageprocess | awk '{print $1}')
		fi
	#	sleep 60
	#done
}

singlecorefix(){
	sleep=$1
	if [[ ! "$sleep" ]]; then
		sleep=10 #dumpsys refresh time is 10 secs.
	fi
	singlecorefix_usage=$2
	if [[ ! "$singlecorefix_usage" ]]; then
		singlecorefix_usage=15 #15%
	fi
	until [[ -f /proc/$(pgrep mediaserv)/status ]]; do
		sleep 1
	done
	cpuloc="cpu$(($(grep -i "Cpus_allowed:" /proc/$(pgrep mediaserv)/status | awk '{print $2}')-1))"
	renice 19 $$
	min_freq=$(cat /sys/devices/system/cpu/$cpuloc/cpufreq/cpuinfo_min_freq)
	max_freq=$(cat /sys/devices/system/cpu/$cpuloc/cpufreq/cpuinfo_max_freq)
	if [[ "$1" == -f ]]; then
		echo $min_freq > /sys/devices/system/cpu/$cpuloc/cpufreq/scaling_min_freq
		return 0
	fi
	while true; do
		if [[ "$sleep" -lt 10 ]]; then
			scaling=$(top -n1 | grep mediaserver | grep -v grep | awk '{print $(NF-1)}' | cut -d'.' -f1)
		else
			scaling=$(dumpsys cpuinfo | grep mediaserver | grep -v grep | awk '{print $1}' | sed 's/%$//' | cut -d'.' -f1)
		fi
		if [[ "$scaling" ]]&&[[ "$scaling" != 0 ]]; then
			applied=1
			echo $(($(($((max_freq-min_freq))*scaling/100))+min_freq)) > /sys/devices/system/cpu/$cpuloc/cpufreq/scaling_min_freq
		else
			echo $min_freq > /sys/devices/system/cpu/$cpuloc/cpufreq/scaling_min_freq
		fi
		if [[ "$applied" ]]; then
			unset applied
		else
			kill_garbage $singlecorefix_usage &
			if [[ "$no_wakelock" == 1 ]]; then
				until [[ "$(cat /sys/class/graphics/fb0/show_blank_event)" == "panel_power_on = 1" ]]; do
					sleep 10
				done
			else
				awake=$(cat /sys/power/wait_for_fb_wake)
			fi
		fi
		sleep $sleep
	done & echo $! > $external/singlecorefix_pid
}
rtmixman(){
	if [[ ! -f $EXTERNAL_STORAGE/sched_tuner/rtmixman_minfree ]]; then
		cat /sys/module/lowmemorykiller/parameters/minfree > $EXTERNAL_STORAGE/sched_tuner/rtmixman_minfree
	fi
	if [[ "$1" == -f ]]; then
		cat $EXTERNAL_STORAGE/sched_tuner/rtmixman_minfree > /sys/module/lowmemorykiller/parameters/minfree
		rm $EXTERNAL_STORAGE/sched_tuner/rtmixman_minfree 2>/dev/null
		return 0
	fi
	if [[ "$(getprop dalvik.vm.heapgrowthlimit)" ]]; then
		minfree=$(($(getprop dalvik.vm.heapgrowthlimit | sed -e 's/m//')*256+$(cat /proc/sys/vm/min_free_kbytes)/4))
	else
		minfree=$(($(getprop dalvik.vm.heapsize | sed -e 's/m//')*256+$(cat /proc/sys/vm/min_free_kbytes)/4))
	fi
	mfslot1=$(cat /sys/module/lowmemorykiller/parameters/minfree | cut -d',' -f1)
	mfslot2=$((minfree+$(cat /sys/module/lowmemorykiller/parameters/minfree | cut -d',' -f2)-mfslot1))
	mfslot3=$((minfree+$(cat /sys/module/lowmemorykiller/parameters/minfree | cut -d',' -f3)-mfslot1))
	mfslot4=$((minfree+$(cat /sys/module/lowmemorykiller/parameters/minfree | cut -d',' -f4)-mfslot1))
	mfslot5=$((minfree+$(cat /sys/module/lowmemorykiller/parameters/minfree | cut -d',' -f5)-mfslot1))
	mfslot6=$((minfree+$(cat /sys/module/lowmemorykiller/parameters/minfree | cut -d',' -f6)-mfslot1))
	mfslot1=$minfree
	final="$mfslot1,$mfslot2,$mfslot3,$mfslot4,$mfslot5,$mfslot6"
	while true; do
		current=$(cat /sys/module/lowmemorykiller/parameters/minfree)
		if [[ "$current" != "$final" ]]; then
			echo "$current" > $EXTERNAL_STORAGE/sched_tuner/rtmixman_minfree
			echo "$final" > /sys/module/lowmemorykiller/parameters/minfree
		fi
		if [[ "$no_wakelock" == 1 ]]; then
			until [[ "$(cat /sys/class/graphics/fb0/show_blank_event)" == "panel_power_on = 1" ]]; do
				sleep 10
			done
		else
			awake=$(cat /sys/power/wait_for_fb_wake)
		fi
		sleep 10
	done & echo $! > $external/rtmixman_pid
}
apply_SS(){
	if [[ "$notsupported" == 1 ]]; then
		error not supported.
		return 2
	else
		for i in $(cat /sys/kernel/debug/sched_features | sed 's/\<NO_//g'); do
			echo NO_$i > /sys/kernel/debug/sched_features
		done
	fi
}
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
# Main script
while [[ "$1" ]]; do
	case $1 in
		-h | --help)
			echo "$BASE_NAME v$version
Copyright (C) 2013-2015 hoholee12@naver.com
Usage: $BASE_NAME -a | --activate [on/off] -h | --help | -a -m -s -w
       $BASE_NAME -l lists all sched_features.
"
			shift
			exit 0
		;;
		-a | --activate)
			apply_SS
			status=$?
			if [[ "$status" != 0 ]]&&[[ "$status" != 2 ]]; then
				error something went wrong.
				exit 1
			fi
			error init complete!
			loop=1
		;;
		-m | --rtmixman)
			backup_feature
			rtmixman
			if [[ "$?" != 0 ]]; then
				error something went wrong.
				exit 1
			fi
			error rtmixman init complete!
			loop=1
		;;
		-s | --singlecorefix)
			backup_feature
			if [[ "$2" != -a ]]&&[[ "$2" != -m ]]&&[[ "$2" != -s ]]&&[[ "$2" != -w ]]&&[[ "$2" != -b ]]&&[[ "$3" != -a ]]&&[[ "$3" != -m ]]&&[[ "$3" != -s ]]&&[[ "$3" != -w ]]&&[[ "$3" != -b ]]; then
				singlecorefix $2 $3
				if [[ "$?" != 0 ]]; then
					error something went wrong.
					exit 1
				fi
				shift
				shift
			else
				singlecorefix
				if [[ "$?" != 0 ]]; then
					error something went wrong.
					exit 1
				fi
			fi
			error singlecorefix init complete!
			loop=1
		;;
		-w | --wakelock_sheriff)
			backup_feature
			if [[ "$2" != -a ]]&&[[ "$2" != -m ]]&&[[ "$2" != -s ]]&&[[ "$2" != -w ]]&&[[ "$2" != -b ]]&&[[ "$3" != -a ]]&&[[ "$3" != -m ]]&&[[ "$3" != -s ]]&&[[ "$3" != -w ]]&&[[ "$3" != -b ]]; then
				wakelock_sheriff $2 $3
				if [[ "$?" != 0 ]]; then
					error something went wrong.
					exit 1
				fi
				shift
				shift
			else
				wakelock_sheriff
				if [[ "$?" != 0 ]]; then
					error something went wrong.
					exit 1
				fi
			fi
			error wakelock_sheriff init complete!
			loop=1
		;;
		-b | --thread_booster)
			backup_feature
			if [[ "$2" != -a ]]&&[[ "$2" != -m ]]&&[[ "$2" != -s ]]&&[[ "$2" != -w ]]&&[[ "$2" != -b ]]; then
				thread_booster $2
				if [[ "$?" != 0 ]]; then
					error something went wrong.
					exit 1
				fi
				shift
			else
				thread_booster
				if [[ "$?" != 0 ]]; then
					error something went wrong.
					exit 1
				fi
			fi
			error thread_booster init complete!
			loop=1
		;;
		-l | --list)
			list_feature
			exit 0
		;;
		-d | --debug)
			debug_shell
		;;
	esac
	shift
done
if [[ "$loop" ]]; then
	exit 0
fi

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
		chmod 755 /system/etc/init.d/sched_tuner_task
		rm /system/etc/init.d/sched_tuner_task
	elif [[ -f /system/etc/sched_tuner_task ]]; then
		chmod 755 /init.rc
		cp $external/init.rc.bak /init.rc
		chmod 755 /init.rc
		chmod 755 /system/etc/sched_tuner_task
		rm /system/etc/sched_tuner_task
	else
		return=1
	fi
}
init_data(){
	echo "#!$BASH

background_task(){
	until [[ -d $external ]]; do
		sleep 1
	done
	for i in \$(grep noexec /proc/mounts | awk '{print \$2}'); do
		mount -o remount exec \$i
	done
	#execute sched_tuner
	until [[ -f $FULL_NAME ]]; do
		sleep 1
	done
	$FULL_NAME -a $install_rtmixman $install_singlecorefix $singlecorefix_time $singlecorefix_usage $install_wakelock_sheriff $wakelock_sheriff_time $wakelock_sheriff_usage $install_thread_booster $thread_booster_time
}
background_task & #in case the target was stored in external storage...

renice_task(){
	renice 19 \$(pgrep kswapd0) #renice kernel mm thread
	#set system_server in lowest priority.
	until [[ \"\$(pgrep zygote)\" ]]; do
		sleep 0.1
	done
	renice $thread_booster_compat \$(pgrep zygote)
	until [[ \"\$(pgrep system_server)\" ]]; do
		sleep 0.1
	done
	renice 0 \$(pgrep zygote)

	renice 19 \$\$ #run in lowest priority for multiple loops after boot completed.
	#set android.process.media in lowest priority.
	until [[ \"\$(pgrep android.process.media)\" ]]; do
		sleep 0.1
	done
	renice 19 \$(pgrep android.process.media)
}
renice_task & renice_pid=\$! #possible bootloop fix

taskdog(){
	sleep 90 #to be adjusted for various devices.
	kill -9 \$renice_pid
}
taskdog & #in case renice_task did not end properly

exit 0 #EOF" > $1
}
initialize(){
	if [[ "$type" ]]; then
		unset type
		mkdir -p /system/etc/init.d
		chmod 755 /system/etc/init.d
		init_data /system/etc/init.d/sched_tuner_task
		chmod 755 /system/etc/init.d/sched_tuner_task
	else
		init_data /system/etc/init.d/sched_tuner_task
		chmod 755 /system/etc/init.d/sched_tuner_task
		chmod 755 /init.rc
		if [[ ! -f $external/init.rc.bak ]]; then
			cp /init.rc $external/init.rc.bak
		fi
		cmp /init.rc $external/init.rc.bak 1>/dev/null
		if [[ "$?" == 0 ]]; then #compare two sizes
			echo "

service sched_tuner_task /system/etc/init.d/sched_tuner_task
     user root
     oneshot" >> /init.rc
		fi
	fi
}

thread_booster_compat=-20 #compat

main(){
	while true; do
		clear
		unset notapplied
		echo -n -e '\e[3m'
		if [[ "$(($(print_RANDOM_BYTE)%2))" == 0 ]]; then
			lines=$(stty size | awk '{print $1}')
			skip=$((lines/10))
			sequence=10
			if [[ "$skip" == 0 ]]; then
				skip=1
				sequence=$lines
			fi
			for i in $(seq 1 $sequence); do
				echo -n -e "\e[2J\e[$((lines-i*skip));1Hsystem performance enhancer for android v$version"
				sleep 0.1
			done
		else
			lines=$(stty size | awk '{print $2}')
			skip=$((lines/10))
			sequence=10
			if [[ "$skip" == 0 ]]; then
				skip=1
				sequence=$lines
			fi
			for i in $(seq 1 $sequence); do
				echo -n -e "\e[2J\e[1;$((lines-i*skip))Hsystem performance enhancer for android v$version"
				sleep 0.1
			done
		fi
		echo -n -e "\e[2J\e[0;0Hsystem performance enhancer for android v$version"
		echo -e "\e[0m"
		backup_feature
		if [[ ! -f $external/rtmixman_pid ]]; then
			echo null > $external/rtmixman_pid
		fi
		if [[ ! -f $external/singlecorefix_pid ]]; then
			echo null > $external/singlecorefix_pid
		fi
		if [[ ! -f $external/wakelock_sheriff_pid ]]; then
			echo null > $external/wakelock_sheriff_pid
		fi
		if [[ ! -f $external/thread_booster_pid ]]; then
			echo null > $external/thread_booster_pid
		fi
		if [[ "$?" != 0 ]]; then
			error something went wrong.
			exit 1
		fi
		appliedonboot=$(ps | grep '{sched_tuner_tas}' | grep -v grep | awk '{print $1}') #good fix for multiple tasks.
		if [[ "$appliedonboot" ]]&&[[ ! -s $external/rtmixman_pid ]]&&[[ ! -s $external/singlecorefix_pid ]]&&[[ ! -s $external/wakelock_sheriff_pid ]]&&[[ ! -s $external/thread_booster_pid ]]; then
			echo $(echo $appliedonboot | awk '{print $1}') > $external/rtmixman_pid
			echo $(echo $appliedonboot | awk '{print $2}') > $external/singlecorefix_pid
			echo $(echo $appliedonboot | awk '{print $3}') > $external/wakelock_sheriff_pid
			echo $(echo $appliedonboot | awk '{print $4}') > $external/thread_booster_pid
		fi
		echo "realtime engines list>>"
		if [[ "$(cat $external/rtmixman_pid)" != null ]]&&[[ "$(ps | grep "$(cat $external/rtmixman_pid)" | grep -v grep)" ]]; then
			echo -e 'rtmixman status: \e[1;32mrunning\e[0m'
		else
			echo -e 'rtmixman status: \e[1;31mnot running\e[0m'
		fi
		if [[ "$(cat $external/singlecorefix_pid)" != null ]]&&[[ "$(ps | grep "$(cat $external/singlecorefix_pid)" | grep -v grep)" ]]; then
			echo -e 'audiofix status: \e[1;32mrunning\e[0m'
		else
			echo -e 'audiofix status: \e[1;31mnot running\e[0m'
		fi
		if [[ "$(cat $external/wakelock_sheriff_pid)" != null ]]&&[[ "$(ps | grep "$(cat $external/wakelock_sheriff_pid)" | grep -v grep)" ]]; then
			echo -e 'wakelock sheriff status: \e[1;32mrunning\e[0m'
		else
			echo -e 'wakelock sheriff status: \e[1;31mnot running\e[0m'
		fi
		if [[ "$(cat $external/thread_booster_pid)" != null ]]&&[[ "$(ps | grep "$(cat $external/thread_booster_pid)" | grep -v grep)" ]]; then
			thread_booster_status=1
			echo -e 'thread booster status: \e[1;32mrunning\e[0m'
		else
			echo -e 'thread booster status: \e[1;31mnot running\e[0m'
			unset thread_booster_status
		fi
		long_line 1
		echo -n "boot tweaks status: "
		if [[ "$(ps -o nice,comm | grep kswapd0 | awk '{print $1}')" == 19 ]]; then
			if [[ "$(ps -o nice,comm | grep system_server | awk '{print $1}')" == -20 ]]; then
				if [[ "$thread_booster_status" == 1 ]]; then
					echo -e "\e[1;31merror!!\e[0m
\e[1;33mboot tweak settings are not properly configured and is causing conflicts with the following MOD:\e[0m thread_booster\e[1;33m
please reinstall and try again.\e[0m"
				else
					echo -e "\e[1;32mapplied!\e[0m"
				fi
				boottweak=1
			else
				if [[ "$thread_booster_status" == 1 ]]; then
					echo -e "\e[1;32musing thread booster\e[0m"
				else
					echo -e "\e[1;33mpartially applied!\e[0m

one of these may have happened: your kernel runs this MOD too late, or newer Android versions have blocked this exploit attempt.
or simply it could just be the result of 'soft' rebooting Android system..."
				fi
			fi
		else
			echo -e "\e[1;31mnot applied!\e[0m"
		fi
		long_line 1
		echo current scheduling features list:
		detect_feature $(cat /sys/kernel/debug/sched_features) #recycled crap
		list_feature
		long_line 1
		if [[ -f /system/etc/sched_tuner_task ]]||[[ -f /system/etc/init.d/sched_tuner_task ]]; then
			echo -n -e '\e[1;33mlooks like the mod is already installed\e[0m'
			if [[ "$notapplied" ]]&&[[ ! "$notsupported" ]]&&[[ ! "$boottweak" ]]; then
				echo -e '\e[1;33m,\e[1;31m but it did not run on boot.\e[0m

reminder: if you did not apply the first option before setting the tweak on boot, this message may appear.'
				unset notapplied
			else
				echo -e '\e[1;33m.\e[0m'
			fi
		else
			echo -e '
generally, \e[1;32mGREEN\e[0m is considered OK, while \e[1;31mRED\e[0m is NOT OK.
'
		fi
		long_line 1
		echo 'select an option:
1)disable everything(speedhack!)
2)set the MOD to run on boot & install boot tweaks'
		if [[ "$(cat $external/rtmixman_pid)" != null ]]&&[[ "$(ps | grep "$(cat $external/rtmixman_pid)" | grep -v grep)" ]]; then
			echo '3)stop rtmixman'
		else
			echo '3)run rtmixman in the background'
		fi
		if [[ "$(cat $external/singlecorefix_pid)" != null ]]&&[[ "$(ps | grep "$(cat $external/singlecorefix_pid)" | grep -v grep)" ]]; then
			echo '4)stop audiofix'
		else
			echo '4)run audiofix in the background'
		fi
		if [[ "$(cat $external/wakelock_sheriff_pid)" != null ]]&&[[ "$(ps | grep "$(cat $external/wakelock_sheriff_pid)" | grep -v grep)" ]]; then
			echo '5)stop wakelock sheriff'
		else
			echo '5)run wakelock sheriff in the background'
		fi
echo '6)restore list/uninstall
7)what does it do?(help)
8)refresh list
q)exit'
		stty cbreak -echo
		f=$(dd bs=1 count=1 2>/dev/null)
		stty -cbreak echo
		echo $f
		long_line 1
		case $f in
			1)
				echo -n applying tweaks...
				apply_SS
				if [[ "$?" != 2 ]]; then
					echo done!
				fi
				sleep 5
			;;
			2)
				if [[ -f /system/etc/sched_tuner_task ]]||[[ -f /system/etc/init.d/sched_tuner_task ]]; then
					echo program already installed.
					sleep 5
					continue
				fi
				echo -n 'press y to install on init.d, or press n for init.rc(may not work properly):'
				while true; do
					stty cbreak -echo
					f=$(dd bs=1 count=1 2>/dev/null)
					stty -cbreak echo
					echo $f
					case $f in
						y* | Y* | 1)
							type=1
							break
						;;
						n* | N* | 2)
							break
						;;
						q* | Q*)
							echo canceled.
							return=1
							break
						;;
						*)
							checkers
						;;
					esac
					echo -n press \'q\' to quit.
				done
				if [[ "$return" ]]; then
					unset return
					sleep 1
					continue
				fi
				long_line 1
				echo -n 'install rtmixman? Y/N:'
				while true; do
					stty cbreak -echo
					f=$(dd bs=1 count=1 2>/dev/null)
					stty -cbreak echo
					echo $f
					case $f in
						y* | Y*)
							install_rtmixman="-m"
							break
						;;
						n* | N*)
							break
						;;
						q* | Q*)
							echo canceled.
							return=1
							break
						;;
						*)
							checkers
						;;
					esac
					echo -n press \'q\' to quit.
				done
				if [[ "$return" ]]; then
					unset return
					sleep 1
					continue
				fi
				long_line 1
				echo -n 'install scAudioFix? Y/N:'
				while true; do
					stty cbreak -echo
					f=$(dd bs=1 count=1 2>/dev/null)
					stty -cbreak echo
					echo $f
					case $f in
						y* | Y*)
							install_singlecorefix="-s"
							break
						;;
						n* | N*)
							dont=1
							break
						;;
						q* | Q*)
							echo canceled.
							return=1
							dont=1
							break
						;;
						*)
							checkers
						;;
					esac
					echo -n press \'q\' to quit.
				done
				if [[ ! "$dont" ]]; then
					echo -n 'scAudioFix: how many seconds interval?: (press return for default setting: 10secs)>>'
					read singlecorefix_time
				fi
				if [[ ! "$dont" ]]; then
					echo 'scAudioFix: Garbageprocess Disposer - in how much cpu usage should the Disposer limit?(out of 100% cpu usage):'
					echo 'tip - lower usage limit is always the best, but be careful, it might terminate your audio application if its too low. (press return for default setting: 15%)'
					echo -n '>>'
					read singlecorefix_usage
				fi
				unset dont
				if [[ "$return" ]]; then
					unset return
					sleep 1
					continue
				fi
				long_line 1
				echo -n 'install wakelock sheriff? Y/N:'
				while true; do
					stty cbreak -echo
					f=$(dd bs=1 count=1 2>/dev/null)
					stty -cbreak echo
					echo $f
					case $f in
						y* | Y*)
							install_wakelock_sheriff="-w"
							break
						;;
						n* | N*)
							dont=1
							break
						;;
						q* | Q*)
							echo canceled.
							return=1
							dont=1
							break
						;;
						*)
							checkers
						;;
					esac
					echo -n press \'q\' to quit.
				done
				if [[ ! "$dont" ]]; then
					echo -n 'wakelock sheriff: how many seconds interval?: (press return for default setting: 60secs)>>'
					read wakelock_sheriff_time
				fi
				if [[ ! "$dont" ]]; then
					echo 'wakelock sheriff: Garbageprocess Disposer - in how much cpu usage should the Disposer limit?(out of 100% cpu usage):'
					echo 'tip - LOWEST IS THE BEST. (press return for default setting: 0%)'
					echo -n '>>'
					read wakelock_sheriff_usage
				fi
				unset dont
				if [[ "$return" ]]; then
					unset return
					sleep 1
					continue
				fi
				long_line 1
				echo -n 'install thread booster? Y/N:'
				while true; do
					stty cbreak -echo
					f=$(dd bs=1 count=1 2>/dev/null)
					stty -cbreak echo
					echo $f
					case $f in
						y* | Y*)
							install_thread_booster="-b"
							thread_booster_compat=0 #compat
							break
						;;
						n* | N*)
							dont=1
							break
						;;
						q* | Q*)
							echo canceled.
							return=1
							dont=1
							break
						;;
						*)
							checkers
						;;
					esac
					echo -n press \'q\' to quit.
				done
				if [[ ! "$dont" ]]; then
					echo -n 'thread booster: how many seconds interval?: (press return for default setting: 10secs)>>'
					read thread_booster_time
				fi
				unset dont
				if [[ "$return" ]]; then
					unset return
					sleep 1
					continue
				fi
				long_line 1
				echo -n 'setting on boot...'
				initialize
				unset install_rtmixman
				unset install_singlecorefix
				unset singlecorefix_time
				unset singlecorefix_usage
				unset install_wakelock_sheriff
				unset wakelock_sheriff_time
				unset wakelock_sheriff_usage
				unset install_thread_booster
				unset thread_booster_time
				echo done! reboot system to take effect!!
				echo would you like to reboot? Y/N:
				stty cbreak -echo
				f=$(dd bs=1 count=1 2>/dev/null)
				stty -cbreak echo
				echo $f
				case $f in
					y* | Y*)
						echo 16 > /proc/sys/kernel/sysrq 2>/dev/null # 0x10 //sync
						echo s > /proc/sysrq-trigger 2>/dev/null
						sync 2>/dev/null
						echo 128 > /proc/sys/kernel/sysrq 2>/dev/null # 0x80 //reboot
						echo b > /proc/sysrq-trigger 2>/dev/null
						reboot 2>/dev/null
						error something went wrong, please reboot manually!
					;;
					*)
						echo canceled.
					;;
				esac
				sleep 5
			;;
			3)
				if [[ "$(cat $external/rtmixman_pid)" != null ]]&&[[ "$(ps | grep "$(cat $external/rtmixman_pid)" | grep -v grep)" ]]; then
					kill -9 $(cat $external/rtmixman_pid)
					rtmixman -f
				else
					rtmixman 2>/dev/null
				fi
				if [[ "$?" != 0 ]]; then
					error something went wrong.
					exit 1
				fi
				error rtmixman init complete!
				sleep 5
			;;
			4)
				if [[ "$(cat $external/singlecorefix_pid)" != null ]]&&[[ "$(ps | grep "$(cat $external/singlecorefix_pid)" | grep -v grep)" ]]; then
					kill -9 $(cat $external/singlecorefix_pid)
					singlecorefix -f
				else
					echo -n 'how many seconds interval?: (press return for default setting: 10secs)>>'
					read time
					echo 'Garbageprocess Disposer - in how much cpu usage should the Disposer limit?(out of 100% cpu usage):'
					echo 'tip - lower usage limit is always the best, but be careful, it might terminate your audio application if its too low. (press return for default setting: 15%)'
					echo -n '>>'
					read usage
					singlecorefix $time $usage 2>/dev/null
				fi
				if [[ "$?" != 0 ]]; then
					error something went wrong.
					exit 1
				fi
				unset time
				unset usage
				error singlecorefix init complete!
				sleep 5
			;;
			5)
				if [[ "$(cat $external/wakelock_sheriff_pid)" != null ]]&&[[ "$(ps | grep "$(cat $external/wakelock_sheriff_pid)" | grep -v grep)" ]]; then
					kill -9 $(cat $external/wakelock_sheriff_pid)
					wakelock_sheriff -f
				else
					echo -n 'how many seconds interval?: (press return for default setting: 60secs)>>'
					read time
					echo 'Garbageprocess Disposer - in how much cpu usage should the Disposer limit?(out of 100% cpu usage):'
					echo 'tip - LOWEST IS THE BEST. (press return for default setting: 0%)'
					echo -n '>>'
					read usage
					wakelock_sheriff $time $usage 2>/dev/null
				fi
				if [[ "$?" != 0 ]]; then
					error something went wrong.
					exit 1
				fi
				unset time
				unset usage
				error wakelock_sheriff init complete!
				sleep 5
			;;
			6)
				echo -n restoring backup...
				apply_backup
				kill -9 $(cat $external/thread_booster_pid) 2>/dev/null
				thread_booster -f 2>/dev/null
				if [[ "$?" != 0 ]]; then
					echo -e '\rcould not restore backup.'
					return 1
				fi
				if [[ "$return" ]];then
					unset return
					echo program not installed.
				else
					echo done!
				fi
				sleep 5
			;;
			7)
				echo -e '-the first mod(scheduling features list "disable everything(speedhack!)") \e[1;33mturns off\e[0m all extra scheduling features that OEMs included for better performance.
why should i disable it when it is supposed to be a good thing?>>
because \e[1;31mIT DOESNT PLAY NICE MOST OF THE TIME & MAY ACTUALLY CREATE A HUGE OVERHEAD!!\e[0m(my Galaxy S does this:()
better to just disable \e[1;34mALL OF THEM\e[0m and make stuff work as intended.

-scAudioFix:  this is a new engine i have developed since v0.0.6(released as a working state on v0.0.7). it controls cpu clock speed to avoid throttling when mediaserver process bursts out for resources, therefore it has an effect of killing audio skipping, or audio stutters when playback.
\e[1;36mdo NOT get confused over its name, its more than just lagfixing audios. it also saves battery by monitoring mediaserver process in realtime!\e[0m

-rtmixman: continuation of my older project that has been widely used and loved by android community.
it adjusts minfree values so that heap allocation will be faster and supposedly boost general performance.
mpengine entry was replaced by rtmixman in v0.0.9

-boot tweaks: literally boot tweaks. these are the tweaks that cannot be done after boot.(such as changing system_server priority)(i am the only one who discovered this exploit, yay me!:D)
just changing the system_server priority to the top makes the overall system:
\e[1;35m>>have much more responsive touch screen
>>have faster load time(almost instant) on network related applications(e.g. tapatalk, twitter, facebook)
>>have much less jitter
>>etc...\e[0m
\e[1;33myou will have to make the script to run on boot in order to make boot tweaks work.\e[0m

-wakelock sheriff: a relatively new engine, introduced in v1.0.0(at the time i wrote this)
when your device goes to sleep, this will detect any processes that are hogging up the cpu and end them silently. thus prolonging battery life.
similar mechanism as scAudioFix, except:
\e[1;35m>>tracks all applications than just one
>>faster cycle thanks to my own advanced algorithm(completes cycle in less than quarter a second!)
>>etc...\e[0m
\e[1;33meven if the cycle is fast enough, cpu may wake up periodically from this engine too.
its recommended to set a longer sleep time(default: 1 min)\e[0m

-thread booster: continuation of my older project(thread priority booster beta: http://forum.xda-developers.com/showthread.php?t=2076101)
this will boost foreground applications to have more cpu resources than any other, resulting in smoother and less laggy performance!'
			long_line 1
			echo -e "thread booster \e[1;31mCANNOT\e[0m be launched directly, it must be set to run \e[1;33mON BOOT\e[0m.
this is because thread booster may have settings that conflict with boot tweaks.
"
			echo -e "wakelock_sheriff.cfg whitelist can be found on $external, please read the instructions there. :3
most important configuration files also can be found in the same directory. \e[1;31mDO NOT CORRUPT OR DELETE!!\e[0m"
			part_line press any key to continue...
			stty cbreak -echo
			f=$(dd bs=1 count=1 2>/dev/null)
			stty -cbreak echo
			;;
			8)
				echo refreshing...
				sleep 0.1
			;;
			9| q |Q)
				echo check out \'flag_tuner\' by Pizza_Dox@xda, highly recommended for perfect combination!:D
				echo official forum: http://forum.xda-developers.com/android/software-hacking/script-scheduling-performance-tuner-t3029984 i dont fuck with trolls.
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