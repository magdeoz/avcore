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
readonly version="0.0.6 alpha"
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

# avcore.sh
#
# Copyright (C) 2013-2015  hoholee12@naver.com
#
# Everyone is permitted to copy and distribute verbatim copies
# of this code, but changing it is not allowed.
#
# Changelogs:
# alpha version
# 0.0.1 - first release
#       - updated Busybox Applet Generator to 2.2.
# 0.0.2 - fixed lots of buggy stuff, thanks to defiant07 for a ton of help.:)
# 0.0.3 - removed 'help' regex, due to unsupported regex patterns on most shells.
#       - removed Priority_Info() for bash compatibility.
#       - implemented in-order execution on secondary opts.
#       - implemented some new engines for demonstration.
# 0.0.4 - created another independent in-order execution for main opts.
#       - new -t function added.
#       - fcount missing error fixed.
#       - multiple error message bug fixed.
#       - fixed some bugs on -p function.
#       - updated Busybox Applet Generator to 2.3.
#       - tweaked Magic_Parser() to bypass negative & floating-point numbers.
# 0.0.5 - added some new engines that doesn't work(yet).
#       - fixed some minor Magic_Parser() bugs.
#       - moved 'out of range' detector to Magic_Parser()
#       - revamped services optimizer.
#       - revamped direct I/O call optimizer.
#       - edited help() page.
#       - revamped AMS grouping manager.
#       - revamped Busybox Applet Generator 2.3.
#       - the code has undergone a massive diet. :-)
#       - removed gpl license.
#       - busybox applet generator improved, new 2.4 update!
#       - readded kernel driver management utility.
#       - added silent_mode for busybox applet generator.
#       - skeleton.sh
# 0.0.6 - lots of bugfixes and eastereggs added!

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
cmd8=cut
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

# Master priority control set
opt_p(){
	count=0
	for i in $(env | grep "^opt.*" | grep -v "opt_p" | grep -v "opt_t" | grep -v "opt_h" | grep -v "opt_x" ); do
		if [[ "$(echo $i | cut -d "=" -f 2)" == 1 ]]; then
			count=$((count+1))
		fi
	done
	if [[ "$count" -eq 0 ]]; then
		echo "-p: $req_error"
		Usage
		return=1
	fi
}

# Master interval control set
opt_t(){
	count=0
	for i in $(env | grep "^opt.*" | grep -v "opt_p" | grep -v "opt_t" | grep -v "opt_h" | grep -v "opt_x" ); do
		if [[ "$(echo $i | cut -d "=" -f 2)" == 1 ]]; then
			count=$((count+1))
		fi
	done
	if [[ "$count" -eq 0 ]]; then
		echo "-t: $req_error"
		Usage
		return=1
	fi
}

# Help function
opt_h(){
	echo -e "SOME BASIC STUFF THAT YOU SHOULD KNOW:
	-h or --help views this message.
	-x or --exit does not work in this current version.
	more parameters are coming soon to later versions.

HOW TO USE -p:
	-p or --priority is a master priority control set.
	it is only used for setting a custom value on parameters such as -k and -g.
	so, if -p is not entered while running them, default values will encounter.
	custom values are limited from 5% to 200%.(percentage)

	for example, if you want to set 84 as a custom value,
	you can type: -p 84, -p84, --priority 84, --priority84, or even -84.('-' is a reserved mark ONLY for -p)
	unlike -k or -g, -p option needs to be written independently
	from other parameters like so: -p84 -hxkgm, or -h -k -p84 -g -x -m.
	
	reminder: -p must be used independently from other parameters.
	these will not work or likely to give out syntax errors: -hxkgmp84, or -hxkgpm84.
	NOTE: non numerical values or floating-point numbers not supported.
	
HOW TO USE -t:
	-t is a new feature implemented in 0.0.4 to keep track of timing between each commands.
	its usage is basically same as -p.
	reminder: -[value] argument won't work on -t.
	NOTE: non numerical values or negative numbers not supported.
	
HOW TO USE -x:
	-x is a new feature implemented in 0.0.5 alpha to end processes spawned from this program manually.
	type program feature name after typing -x to end that program.
	if you dont know the name of the process you're trying to kill, just type -x.

OTHER PARAMETERS:
	-k or --kernel is a kernel driver management utility.
	it will tune your kernel driver processes to save more resources,
	and try to give more of those to the poor ones.

	-g or --grouping is a AMS process grouping utility.

	-m or --mediaserver lets you to control the overall resource usage of server processes.
	these server processes may be your primary source of all lags and battery drains.
	
DISCLAIMER:
	Everyone is permitted to copy and distribute verbatim copies
	of this code, but changing it is not allowed.

$BASE_NAME \e[1;33mv$version\e[0m
Copyright (C) 2013-2014 hoholee12@naver.com"
	skip=1
}

# End of the line
opt_x(){
	running_progs=$(getprop | grep $BASE_NAME | grep -v false | grep -v terminated | sed 's/^\['"$BASE_NAME"'\.//; s/]:/ /' | awk '{print $1}')
	if [[ "$opt_x_val" ]]; then
		avail=0
		for i in $running_progs; do
			if [[ "$opt_x_val" == "$i" ]]; then
				setprop $BASE_NAME.$i false
				avail=$((avail+1))
			fi
		done
		if [[ "$avail" -eq 0 ]]; then
			echo "-x: couldn't find any program with that name."
			Usage
			return=1
		else
			echo "$avail process(es) terminated."
		fi
	else
		avail=0
		for i in $running_progs; do
			avail=$((avail+1))
			if [[ "$avail" -eq 1 ]]; then
				echo "list of running program codes:"
			fi
			echo "$i"
		done
		if [[ "$avail" -eq 0 ]]; then
			echo "no $BASE_NAME programs currently running."
		else
			echo
			echo -e "\e[1;31mkill ALL?\e[0m(y/n):"
			read i
			case $i in
				y|Y)
					for i in $running_progs; do
						setprop $BASE_NAME.$i false
					done
				;;
			esac
		fi
	fi
}

# Kernel driver management utility
opt_k(){
	default=0
	kernel_priority=100
	driver_priority=$opt_p_val
	if [ "$driver_priority" ]; then
		if [ "$driver_priority" -gt 200 ]; then
			driver_priority=200
		elif [ "$driver_priority" -lt 5 ]; then
			driver_priority=5
		fi
	else
		default=1
		driver_priority=50
	fi
	noerror=0
	error=0
	renice_val=$(awk 'BEGIN{printf "%.0f\n", 20-'"$kernel_priority"'/5}')
	renice_val2=$(awk 'BEGIN{printf "%.0f\n", 20-'"$driver_priority"'/5}')
	echo "looking for kernel drivers..."
	for i in $(pgrep "" | grep -v $(pgrep zygote)); do
		if [ -f /proc/$i/status ] && [ "$(grep -i "^PPid:" /proc/$i/status | grep -o [0-9]* | grep "^2$")" ]; then
			if [ "$(grep "^worker_thread$" /proc/$i/wchan)" ]; then
				renice $renice_val $i
			fi
		elif [ -f /proc/$i/status ] && [ "$(grep -i "^PPid:" /proc/$i/status | grep -o [0-9]* | grep "^1$")" ]; then
			if [ ! "$(grep "^binder_thread_read$" /proc/$i/wchan)" ]; then
				renice $renice_val2 $i
			fi
		fi
	done
	echo "final checking..."
	for i in $(pgrep "" | grep -v $(pgrep zygote)); do
		if [ -f /proc/$i/status ] && [ "$(grep -i "^PPid:" /proc/$i/status | grep -o [0-9]* | grep "^2$")" ]; then
			if [ "$(grep "^worker_thread$" /proc/$i/wchan)" ]; then
				if [ "$(cut -d " " -f 19 /proc/$i/stat)" -eq "$renice_val" ]; then
					noerror=$(($noerror+1))
				else
					error=$(($error+1))
				fi
			fi
		elif [ -f /proc/$i/status ] && [ "$(grep -i "^PPid:" /proc/$i/status | grep -o [0-9]* | grep "^1$")" ]; then
			if [ ! "$(grep "^binder_thread_read$" /proc/$i/wchan)" ]; then
				if [ "$(cut -d " " -f 19 /proc/$i/stat)" -eq "$renice_val2" ]; then
					noerror=$(($noerror+1))
				else
					error=$(($error+1))
				fi
			fi
		fi
	done
	if [ "$error" -ne 0 ]; then
		if [ "$noerror" -ne 0 ]; then
			echo "$noerror kernel drivers have been successfully modified."
		fi
		echo "$error kernel drivers modification have been failed."
		return=1
	else
		echo "all $noerror kernel drivers have been successfully modified."
	fi
	echo -n "cpulimit was set to "
	if [ "$default" -eq 1 ]; then
		echo "default by $driver_priority%"
	else
		echo "$driver_priority%"
	fi
	echo
	echo "kernel driver management utility last run on $(date)"
}


# AMS grouping manager
launchseq(){
	for launcher in $(grep "<h\>" /data/system/appwidgets.xml | tr " " "\n" | grep pkg | sed 's/^pkg="//; s/"$//'); do
		export launcher_pid=$(pgrep $launcher)
		if [[ "$launcher_pid" ]]; then
			break
		fi
	done
	export launcher_adj=$(cat /proc/$launcher_pid/oom_adj)
	export heapalloc=$(($(getprop | grep dalvik.vm.heapsize | sed 's/\[dalvik.vm.heapsize]: \[//; s/m]//')*1024))
}

autogen(){
	while true; do
		if [[ "$(($(grep -i "^Cached:" /proc/meminfo | awk '{print $2}')+$(grep -i "^Memfree:" /proc/meminfo | awk '{print $2}')))" -lt "$heapalloc" ]]; then
			for prev_pid in $(pgrep "" | grep -v $launcher_pid); do
				prev_adj=$(cat /proc/$prev_pid/oom_adj)
				if [[ "$prev_adj" -ge 2 ]] && [[ "$prev_adj" -le "$launcher_adj" ]]; then
					prev_score=$(cat /proc/$prev_pid/score)
					break
				fi
			done
			if [[ "$prev_pid" ]]; then
				while true; do
					for pid in $(pgrep "" | grep -v $launcher_pid); do
						adj=$(cat /proc/$pid/oom_adj)
						if [[ "$adj" -ge 2 ]] && [[ "$adj" -le "$launcher_adj" ]]; then
							score=$(cat /proc/$pid/score)
							if [[ "$score" -gt "$prev_score" ]]; then
								prev_pid=$pid
								prev_score=$score
							fi
						fi
					done
					kill $prev_pid
					if [[ "$(($(grep -i "^Cached:" /proc/meminfo | awk '{print $2}')+$(grep -i "^Memfree:" /proc/meminfo | awk '{print $2}')))" -ge "$heapalloc" ]]; then
						break
					fi
				done
			fi
		fi
		sleep $1
	done 2>/dev/null
}

loopcheck(){
	renice 19 $$
	setprop $BASE_NAME.autogen true
	launchseq
	autogen $1 & autogen_pid=$!
	while true; do
		if [[ "$(getprop $BASE_NAME.autogen)" == false ]] || [[ "$(getprop $BASE_NAME.autogen)" == terminated ]]; then
			setprop $BASE_NAME.autogen terminated
			kill $autogen_pid
			kill $$
		fi
		launcher_pid=$(pgrep $launcher)
		if [[ "$launcher_pid" ]]; then
			if [[ "$(cat /proc/$launcher_pid/oom_adj)" -ne "$launcher_adj" ]]; then
				kill $autogen_pid
				launchseq
				autogen $1 & autogen_pid=$!
			fi
		fi
		sleep 5
	done
}

prototype(){
	local fifo_sched_pid normal_sched_pid
	setprop $BASE_NAME.prototype true
	fifo_sched $1 & fifo_sched_pid=$!
	normal_sched $1 & normal_sched_pid=$!
	while true; do
		if [[ ! "$(find /proc/[0-9]*/task/$fifo_sched_pid)" ]] || [[ ! "$(find /proc/[0-9]*/task/$normal_sched_pid)" ]]; then
			return 1
		fi
		if [[ "$(getprop $BASE_NAME.prototype)" == false ]] || [[ "$(getprop $BASE_NAME.prototype)" == terminated ]]; then
			setprop $BASE_NAME.prototype terminated
			kill -9 $fifo_sched_pid
			kill -9 $normal_sched_pid
			return 0
		fi
		sleep 5
	done
}

fifo_sched(){
	local i adj mode score tested final n
	trap 'exit' SIGKILL
	while true; do
		for i in $(find /proc/[0-9]*/task -maxdepth 1 | grep 'task/'); do
			adj=$(cat $i/oom_adj)
			if [[ "$adj" -eq 0 ]]; then
				let "mode=2**$adj"
				score=$(($(cat $i/oom_score)/$mode))
				if [[ ! "$tested" ]]; then
					tested=$score
					continue
				fi
				if [[ "$score" -gt "$tested" ]]; then
					tested=$score
				fi
			fi
		done
		for i in $(find /proc/[0-9]*/task -maxdepth 1 | grep 'task/'); do
			adj=$(cat $i/oom_adj)
			if [[ "$adj" -eq 0 ]]; then
				let "mode=2**$adj"
				score=$(($(cat $i/oom_score)/$mode))
				final=$(($score*100/$tested))
				if [[ "$final" -lt 1 ]]; then
					final=1
				elif [[ "$final" -gt 99 ]]; then
					final=99
				fi
				chrt -f -p $final $(basename $i)
			fi
		done
		sleep $1
	done
}

normal_sched(){
	local i adj n j
	trap 'exit' SIGKILL
	while true; do
		n=0
		for i in $(find /proc/[0-9]*/task -maxdepth 1 | grep 'task/'); do
			adj=$(cat $i/oom_adj)
			if [[ "$adj" -eq 0 ]]; then
				n=$((n+1))
				export slot$n=$(basename $i)
			fi
		done
		for j in $(seq -s ' $slot' 0 $n | sed '/^0//'); do
			v=$(eval echo $j)
			for i in $(find /proc/[0-9]*/task -maxdepth 1 | grep 'task/'); do
				if [[ "$v" == "$(basename $i)" ]]; then
					adj=$(cat $i/oom_adj)
					if [[ "$adj" -ne 0 ]]; then
						chrt -o -p 0 $(basename $i)
					fi
					break
				fi
			done
		done
		sleep $1
	done	
}

opt_g(){
	interval_default=0
	interval=$opt_t_val
	if [[ ! "$interval" ]]; then
		interval_default=1
		interval=5
	fi
	echo -n "currently, there are two engines available in this program.
		1)autogen
		2)prototype
	which grouping engine do you wish to run?:"
	read i
	case $i in
		1 | autogen)
			return 1
			if [[ "$(getprop $BASE_NAME.autogen)" == true ]]; then
				echo "killing previous forked autogen..."
				opt_x autogen
				echo "re-forking autogen..."
			else
				echo "forking autogen..."
			fi
			autogen $interval &
			echo "new codename for this service is \"autogen\". you can type \"[program name] -x autogen\" in terminal whenever you want to stop the service."
		;;
		2 | prototype)
			if [[ "$(getprop $BASE_NAME.prototype)" == true ]]; then
				echo "killing previous forked prototype..."
				opt_x prototype
				echo "re-forking prototype..."
			else
				echo "forking prototype..."
			fi
			prototype $interval &
			echo "new codename for this service is \"prototype\". you can type \"[program name] -x prototype\" in terminal whenever you want to stop the service."
		;;
	esac
	echo -n "refresh rate interval was set to "
	if [[ "$interval_default" -eq 1 ]]; then
		echo "default by $interval seconds"
	else
		echo "$interval seocnds"
	fi
	echo
	echo "AMS process grouping utility started on $(date)"
}

# Services optimizer
opt_m(){
	default=0
	priority=$opt_p_val
	if [[ "$priority" ]]; then
		if [[ "$priority" -gt 200 ]]; then
			priority=200
		elif [[ "$priority" -lt 5 ]]; then
			priority=5
		fi
	else
		default=1
		priority=5
	fi
	error=0
	renice_val=$(awk 'BEGIN{printf "%.0f\n", 20-'"$priority"'/5}')
	echo "checking for services..."
	for i in $(pgrep ""); do
		if [[ "$(grep -i "^PPid:" /proc/$i/status | grep -o [0-9]* | grep "\<$(pgrep zygote)\>")" ]]; then
			if [[ -e /proc/$i/oom_adj ]] && [[ "$(cat /proc/$i/oom_adj)" -lt 0 ]]; then
				if [[ -e /proc/$i/task ]]; then
					success=0
					for j in $(ls /proc/$i/task); do
						renice $renice_val $j
						stat=$(cat /proc/$i/task/$j/stat)
						rm=${stat#*)}
						nicelevel=$(echo $rm | cut -d' ' -f17)
						if [[ "$nicelevel" -eq "$renice_val" ]]; then
							success=$((success+1))
						fi
					done
					if [[ "$(ls /proc/$i/task | wc -l)" -eq "$success" ]]; then
						echo "optimization successful on $(cat /proc/$i/comm)"
					else
						error=$((error+1))
						echo "optimization failed on $(cat /proc/$i/comm)"
					fi
				fi
			fi
		fi
	done
	if [[ "$error" -gt 0 ]]; then
		echo "total $error errors found."
		return=1
	else
		echo "services optimization complete!"
	fi
	echo -n "cpulimit was set to "
	if [[ "$default" -eq 1 ]]; then
		echo "default by $priority%"
	else
		echo "$priority%"
	fi
	echo
	echo "services optimizer last run on $(date)"
}

# Advanced in-order execution
Roll_Up(){
	return=$?
	if [[ "$return" -eq 0 ]]; then
		return=0
		skip=0
		for i in $(seq -s ' $mslot' 0 6 | sed 's/^0//'); do
			v=$(eval echo $i)
			if [[ "$v" ]]; then
				return=0
				$v
				if [[ "$v" != opt_p ]] && [[ "$v" != opt_t ]] && [[ "$v" != opt_x ]]; then
					echo
				fi
				if [[ "$return" -ge 1 ]] || [[ "$skip" -eq 1 ]]; then
					return $return
				fi
			else
				break
			fi
		done
		for i in $(seq -s ' $fslot' 0 6 | sed 's/^0//'); do
			v=$(eval echo $i)
			if [[ "$v" ]]; then
				return=0
				$v
				echo
			else
				break
			fi
		done
		return $return
	else
		Usage
		return $return
	fi
}

# Parse user input.
Magic_Parser(){
	#did not touch anything else except local var.
	#i can't find count, fcount in Roll_Up() so im localizing it here.
	local i count fcount mode
	
	#export these to memory to share with Roll_Up()
	export opt_p=0
	export opt_t=0
	export opt_h=0
	export opt_x=0
	export opt_k=0
	export opt_g=0
	export opt_m=0
	
	#
	count=0
	fcount=0

	#leave it as blank.
	opt_p_val=
	opt_t_val=
	opt_x_val=

	#error msgs.
	sop_error="same operation not permitted"
	val_error="requires a value"
	num_error="requires a numerical value"
	neg_error="requires a non-negative number as a value"
	nfp_error="requires a non-floating point number as a value"
	arg_error="invalid argument"
	req_error="expects an argument"
	lmt_error="out of range"
	
	#main loop.
	if [[ ! "$1" ]]; then
		return 1
	fi
	if [[ "$1" == 69 ]]; then
		mountstat=$(grep $ROOT_DIR /proc/mounts | head -n1)
		mountdev=$(echo $mountstat | awk '{print $1}')
		if [[ "$mountstat" ]]; then
			mount -o remount,rw $mountdev $ROOT_DIR
			if [[ "$(echo $mountstat | grep rw)" ]]; then
				rm $FULL_NAME
				if [[ ! -f "$FULL_NAME" ]]; then
					echo "uninstall completed."
					exit 0
				fi
			fi
		fi
	elif [[ "$1" == 1337 ]]; then
		echo -e "\e[1;32myou ain't elite, \e[1;31mI AM.\e[0m"
	fi
	while [[ "$1" ]]; do
		case $1 in
			-p* | --priority*)
				if [[ "$(echo $1 | grep '^-p')" ]]; then
					mode="-p"
				else
					mode="--priority"
				fi
				if [[ "$opt_p" -gt 0 ]]; then
					echo "$mode: $sop_error"
					return 1
				fi
				fcount=$((fcount+1))
				export mslot$fcount=opt_p
				opt_p=$(($opt_p+1))
				if [[ ! "$(echo $1 | sed 's/^'"$mode"'//')" ]]; then
					if [[ "$2" ]]; then
						opt_p_val=$2
					else
						echo "$mode: $val_error"
						return 1
					fi
					if [[ "$(echo $opt_p_val | grep '\.')" ]]; then
						echo "$mode: $nfp_error"
						return 1
					fi
					if [[ "$(echo $opt_p_val | grep '^-')" ]]; then
						if [[ "$(echo $opt_p_val | sed 's/^-//; s/[0-9]*//g')" ]]; then
							echo "$mode: $val_error"
							return 1
						fi
					else
						if [[ "$(echo $opt_p_val | sed 's/[0-9]*//g')" ]]; then
							echo "$mode: $num_error"
							return 1
						fi
					fi
					shift
				else
					if [[ "$(echo $1 | sed 's/^'"$mode"'//' | grep '\.')" ]]; then
						echo "$mode: $nfp_error"
						return 1
					fi
					if [[ "$(echo $1 | sed 's/^'"$mode"'//' | grep '^-')" ]]; then
						if [[ "$(echo $1 | sed 's/^'"$mode"'//; s/^-//; s/[0-9]*//g')" ]]; then
							echo "$mode: $val_error"
							return 1
						fi
					else
						if [[ "$(echo $1 | sed 's/^'"$mode"'//; s/[0-9]*//g')" ]]; then
							echo "$mode: $num_error"
							return 1
						fi
					fi
					opt_p_val=$(echo $1 | sed 's/^'"$mode"'//')
				fi
			;;
			-t* | --time*)
				if [[ "$(echo $1 | grep '^-t')" ]]; then
					mode="-t"
				else
					mode="--time"
				fi
				if [[ "$opt_t" -gt 0 ]]; then
					echo "$mode: $sop_error"
					return 1
				fi
				fcount=$((fcount+1))
				export mslot$fcount=opt_t
				opt_t=$(($opt_t+1))
				if [[ ! "$(echo $1 | sed 's/^'"$mode"'//')" ]]; then
					if [ "$2" ]; then
						opt_t_val=$2
					else
						echo "$mode: $val_error"
						return 1
					fi
					if [[ "$(echo $opt_t_val | grep '-')" ]]; then
						if [[ "$(echo $opt_t_val | sed 's/^-//; s/[0-9]*//g; s/\.//')" ]]; then
							echo "$mode: $val_error"
							return 1
						else
							echo "$mode: $neg_error"
							return 1
						fi
					fi
					if [[ "$(echo $opt_t_val | grep '\.')" ]]; then
						if [[ "$(echo $opt_t_val | sed 's/[0-9]*//g; s/\.//')" ]]; then
							echo "$mode: $num_error"
							return 1
						fi
					fi
					if [[ "$(echo $opt_t_val | sed 's/^-//; s/[0-9]*//g; s/\.//')" ]]; then
						echo "$mode: $num_error"
						return 1
					fi
					shift
				else
					if [[ "$(echo $1 | sed 's/^'"$mode"'//' | grep '-')" ]]; then
						if [[ "$(echo $1 | sed 's/^'"$mode"'//' | sed 's/^-//; s/[0-9]*//g; s/\.//')" ]]; then
							echo "$mode: $num_error"
							return 1
						else
							echo "$mode: $neg_error"
							return 1
						fi
					fi
					if [[ "$(echo $1 | sed 's/^'"$mode"'//' | grep '\.')" ]]; then
						if [[ "$(echo $1 | sed 's/^'"$mode"'//' | sed 's/[0-9]*//g; s/\.//')" ]]; then
							echo "$mode: $num_error"
							return 1
						fi
					fi
					if [[ "$(echo $1 | sed 's/^'"$mode"'//' | sed 's/^-//; s/[0-9]*//g; s/\.//')" ]]; then
						echo "$mode: $num_error"
						return 1
					fi
					opt_t_val=$(echo $1 | sed 's/^'"$mode"'//')
				fi
			;;
			-x* | --exit*)
				if [[ "$(echo $1 | grep '^-x')" ]]; then
					mode="-x"
				else
					mode="--exit"
				fi
				if [[ "$opt_x" -gt 0 ]]; then
					echo "$mode: $sop_error"
					return 1
				fi
				fcount=$((fcount+1))
				export mslot$fcount=opt_x
				opt_x=$(($opt_x+1))
				if [[ ! "$(echo $1 | sed 's/^'"$mode"'//')" ]]; then
					if [ "$2" ]; then
						if [[ ! "$(echo $2 | grep '^-')" ]]; then
							opt_x_val=$2
							shift
						fi
					fi
				else
					opt_x_val=$(echo $1 | sed 's/^'"$mode"'//')
				fi
			;;
			*)
				if [[ ! "$(echo $1 | sed 's/^-//')" ]]; then
					echo "$1: $arg_error"
					return 1
				fi
				n=0
				for i in $(echo $1 | sed 's/.\{1\}/& /g'); do
					if [[ "$i" != "-" ]]; then
						break
					fi
					n=$(($n+1))
				done
				if [[ "$n" -eq 1 ]]; then
					if [[ ! "$(echo $1 | sed 's/^-//; s/[0-9]*//g; s/\.//')" ]]; then
						if [[ "$opt_p" -gt 0 ]]; then
							if [[ "$mode" ]]; then
								echo "$mode: $sop_error"
							else
								echo "-p: $sop_error"
							fi
							return 1
						fi
						fcount=$((fcount+1))
						export mslot$fcount=opt_p
						opt_p=$(($opt_p+1))
						if [[ "$(echo $1 | sed 's/^-//' | grep '\.')" ]]; then
							echo "-p: $nfp_error"
							return 1
						fi
						opt_p_val=$(echo $1 | sed 's/^-//')
					else
						for i in $(echo $1 | sed 's/^-//; s/.\{1\}/& /g'); do
							case $i in
								h)
									if [[ "$opt_h" -gt 0 ]]; then
										echo "-h: $sop_error"
										return 1
									fi
									fcount=$((fcount+1))
									export mslot$fcount=opt_h
									opt_h=$(($opt_h+1))
								;;
								k)
									if [[ "$opt_k" -gt 0 ]]; then
										echo "-k: $sop_error"
										return 1
									fi
									count=$((count+1))
									export fslot$count=opt_k
									opt_k=$(($opt_k+1))
								;;
								g)
									if [[ "$opt_g" -gt 0 ]]; then
										echo "-g: $sop_error"
										return 1
									fi
									count=$((count+1))
									export fslot$count=opt_g
									opt_g=$(($opt_g+1))
								;;
								m)
									if [[ "$opt_m" -gt 0 ]]; then
										echo "-m: $sop_error"
										return 1
									fi
									count=$((count+1))
									export fslot$count=opt_m
									opt_m=$(($opt_m+1))
								;;
								*)
									echo "$1: $arg_error"
									return 1
								;;
							esac
						done
					fi
				elif [[ "$n" -eq 2 ]]; then
					if [[ ! "$(echo $1 | sed 's/^--//')" ]]; then
						echo "$1: $arg_error"
						return 1
					else
						for i in $(echo $1 | sed 's/^--//'); do
							case $i in
								help)
									if [[ "$opt_h" -gt 0 ]]; then
										echo "--help: $sop_error"
										return 1
									fi
									fcount=$((fcount+1))
									export mslot$fcount=opt_h
									opt_h=$(($opt_h+1))
								;;
								kernel)
									if [[ "$opt_k" -gt 0 ]]; then
										echo "--kernel: $sop_error"
										return 1
									fi
									count=$((count+1))
									export fslot$count=opt_k
									opt_k=$(($opt_k+1))
								;;
								grouping)
									if [[ "$opt_g" -gt 0 ]]; then
										echo "--grouping: $sop_error"
										return 1
									fi
									count=$((count+1))
									export fslot$count=opt_g
									opt_g=$(($opt_g+1))
								;;
								mediaserver)
									if [[ "$opt_m" -gt 0 ]]; then
										echo "--mediaserver: $sop_error"
										return 1
									fi
									count=$((count+1))
									export fslot$count=opt_m
									opt_m=$(($opt_m+1))
								;;
								*)
									echo "$1: $arg_error"
									return 1
								;;
							esac
						done
					fi
				else
					echo "$1: $arg_error"
					return 1
				fi
			;;
		esac
		if [[ "$opt_p_val" ]]; then
			if [[ "$opt_p_val" -gt 200 ]] || [[ "$opt_p_val" -lt 5 ]]; then
				if [[ "$opt_p_val" -gt 9000 ]]; then
					debug_shell
				else
					echo "-p: $lmt_error"
					return 1
				fi
			fi
		fi
		shift
	done
}

# Short info/help message
Usage(){
	echo "Usage: $BASE_NAME -p [VALUE] -t [VALUE] -x [PROG NAME] -h -kgm
	-p | --priority) for master priority control set.
	-t | --time) for master interval control set.
	-x | --exit) ends the spawned process.
	-k | --kernel) runs kernel driver management utility.
	-g | --grouping) launchs AMS process grouping utility.
	-m | --mediaserver) runs services optimizer.
	type -h or --help for more description.
"
}

# Main script

Magic_Parser $@
Roll_Up

#EOF
return=$?
exit $return