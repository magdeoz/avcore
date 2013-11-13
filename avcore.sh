CLIPPER_VERSION="0.0.5 alpha"
BASE_NAME=$(basename $0)
# Clipper - a user executable binary for Dalvik VM & process management.
#
# Copyright (C) 2013  hoholee12@naver.com
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
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
set +e
# Un-comment out the following line to enable debugging.
#set -x

# Custom settings for session behaviour
# Check Busybox Applet Generator 2.3.
run_Busybox_Applet_Generator=yes
# Check Superuser.
run_Superuser=yes

# Busybox Applet Generator 2.3
# You can type in any commands you would want it to check.
# It will start by checking from cmd1, and its limit is up to cmd224.
cmd1=renice
cmd2=pgrep
cmd3=mount
cmd4="Your permission to use this program has been taken away for now. If you wish to gain immediate access to this program, you must edit 'cmd=' to 'cmd=3'."
cmd= # It notifies the generator how many cmds are available for check. Leave it as blank.
# This feature might not be compatible with some other multi-call binaries.
Busybox_Applet_Generator(){
	if [ ! "$(busybox)" ]; then
		echo "Failed to locate busybox!"
		return 127
	else
		busyboxloc=$(dirname $(which busybox))
		n=0
		for i in $(echo $PATH | sed 's/:/ /g'); do
			n=$(($n+1))
			export slot$n=$i
			if [ "$i" == "$busyboxloc" ]; then
				busyboxenv=slot$n
			fi
		done
		if [ "$busyboxenv" != slot1 ]; then
			export PATH=$(echo -n $busyboxloc
			for i in $(seq -s ' $slot' 0 $n | sed 's/^0//'); do
				v=$(eval echo $i)
				if [ "$v" != "$busyboxloc" ]; then
					echo -n ":$v"
				fi
			done)
		fi
		if [ "$cmd" ]; then
			if [ "$cmd" -lt 0 ]; then
				cmd=0
			fi
		else
			cmd=224
		fi
		for i in $(seq -s ' $cmd' 0 $cmd | sed 's/^0//'); do
			v=$(eval echo $i)
			if [ "$v" ]; then
				if [ ! "$(busybox | grep "\<$v\>")" ]; then
					echo "This program needs the following applet to run: $v"
					return 127
				fi
				if [ ! -e "$busyboxloc"/"$v" ]; then
					alias $i="busybox $i"
				fi
			else
				break
			fi
		done
	fi 2>/dev/null
}

# Check Superuser.
Superuser(){
	if [ "$(grep -i "^Gid:" /proc/$$/status | awk '{print $2}')" != 0 ] || [ "$(grep -i "^Uid:" /proc/$$/status | awk '{print $2}')" != 0 ]; then
		echo "Permission denied, are you root?"
		return 126
	fi
}

# Session behaviour
Roll_Down(){
	if [ "$run_Busybox_Applet_Generator" ] && [ "$run_Busybox_Applet_Generator" == yes ]; then
		Busybox_Applet_Generator
		return=$?
		if [ "$return" -ne 0 ]; then
			return $return
		fi
	fi
	if [ "$run_Superuser" ] && [ "$run_Superuser" == yes ]; then
		Superuser
		return=$?
		if [ "$return" -ne 0 ]; then
			return $return
		fi
	fi
}

# Master priority control set
opt_p(){
	count=0
	for i in $(env | grep "^opt.*" | grep -v "opt_p" | grep -v "opt_t" | grep -v "opt_h" | grep -v "opt_x" ); do
		if [ "$(echo $i | cut -d "=" -f 2)" == 1 ]; then
			count=$((count+1))
		fi
	done
	if [ "$count" -eq 0 ]; then
		echo "-p: $req_error"
		Usage
		return=1
	fi
}

# Master interval control set
opt_t(){
	count=0
	for i in $(env | grep "^opt.*" | grep -v "opt_p" | grep -v "opt_t" | grep -v "opt_h" | grep -v "opt_x" ); do
		if [ "$(echo $i | cut -d "=" -f 2)" == 1 ]; then
			count=$((count+1))
		fi
	done
	if [ "$count" -eq 0 ]; then
		echo "-t: $req_error"
		Usage
		return=1
	fi
}

# Help function
opt_h(){
	echo "SOME BASIC STUFF THAT YOU SHOULD KNOW:
	-h or --help views this message.
	-x or --exit does not work in this current version.
	more options are coming soon to later versions.

HOW TO USE -p:
	-p or --priority is a master priority control set.
	it is only used for setting a custom value on options such as -k and -g.
	so, if -p is not entered while running them, default values will encounter.
	custom values are limited from 5% to 200%.(percentage)

	for example, if you want to set 84 as a custom value,
	you can type: -p 84, -p84, --priority 84, --priority84, or even -84.('-' is a reserved mark ONLY for -p)
	unlike -k or -g, -p option needs to be written independently
	from other options like so: -p84 -hxkgm, or -h -k -p84 -g -x -m.
	
	reminder: -p must be used independently from other options.
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

OTHER OPTIONS:
	-k or --kernel is a utility for optimizing direct I/O calls.
	the purpose of this utility is to attempt delay on non-buffering I/O(or direct I/O), in order to prevent certain I/O hangs.
	it may fix mediaserver audio stutter issue from earlier Android 2.3.x builds.

	-g or --grouping is a AMS process grouping utility.

	-m or --mediaserver lets you to control the overall resource usage of server processes.
	these server processes may be your primary source of all lags and battery drains.

THE AMAZING POWER OF Magic_Parser():
	Clipper uses an advanced logic function called Magic_Parser() to parse arguments,
	in order to allow users to be able to input arguments more dynamically.
	it basically means that this parser will be able to understand about any method across various argument inputs.
	it is also designed to be very fast in complex parsing, so that any delays can be avoided.
	
DISCLAIMER:
	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

Clipper Version $CLIPPER_VERSION
Copyright (C) 2013 hoholee12@naver.com"
	skip=1
}

# End of the line
opt_x(){
	running_progs=$(getprop | grep $BASE_NAME | grep -v false | grep -v terminated | sed 's/^\['"$BASE_NAME"'\.//; s/]:/ /' | awk '{print $1}')
	if [ "$opt_x_val" ]; then
		avail=0
		for i in $running_progs; do
			if [ "$opt_x_val" == "$i" ]; then
				setprop $BASE_NAME.$i false
				avail=$((avail+1))
			fi
		done
		if [ "$avail" -eq 0 ]; then
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
			if [ "$avail" -eq 1 ]; then
				echo "list of running program codes:"
			fi
			echo "$i"
		done
		if [ "$avail" -eq 0 ]; then
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

# Direct I/O call optimizer
opt_k(){
	default=0
	priority=$opt_p_val
	if [ "$priority" ]; then
		if [ "$priority" -gt 200 ]; then
			priority=200
		elif [ "$priority" -lt 5 ]; then
			priority=5
		fi
	else
		default=1
		priority=5
	fi
	error=0
	renice_val=$(echo $priority | awk '{printf "%.0f\n", 20-$1/5}')
	echo "looking through direct I/O calls..."
	for i in $(pgrep ""); do
		if [ "$(grep -i "^PPid:" /proc/$i/status | grep -o [0-9]* | grep "\<2\>")" ]; then
			if [ "$(grep -i "dio" /proc/$i/comm)" ]; then
				renice $renice_val $i
				stat=$(cat /proc/$i/stat)
				rm=${stat#*)}
				nicelevel=$(echo $rm | cut -d' ' -f17)
				if [ "$nicelevel" -ne "$renice_val" ]; then
					error=$((error+1))
				fi
			fi
		fi
	done
	if [ "$error" -gt 0 ]; then
		echo "total $error errors found."
		return=1
	else
		echo "direct I/O call optimization complete!"
	fi
	echo -n "cpulimit was set to "
	if [ "$default" -eq 1 ]; then
		echo "default by $priority%"
	else
		echo "$priority%"
	fi
	echo
	echo "direct I/O call optimizer last run on $(date)"
}

# AMS grouping manager
launchseq(){
	for launcher in $(grep "<h\>" /data/system/appwidgets.xml | tr " " "\n" | grep pkg | sed 's/^pkg="//; s/"$//'); do
		export launcher_pid=$(pgrep $launcher)
		if [ "$launcher_pid" ]; then
			break
		fi
	done
	export launcher_adj=$(cat /proc/$launcher_pid/oom_adj)
	export heapalloc=$(($(getprop | grep dalvik.vm.heapsize | sed 's/\[dalvik.vm.heapsize]: \[//; s/m]//')*1024))
}
autogen(){
	while true; do
		if [ "$(($(grep -i "^Cached:" /proc/meminfo | awk '{print $2}')+$(grep -i "^Memfree:" /proc/meminfo | awk '{print $2}')))" -lt "$heapalloc" ]; then
			for prev_pid in $(pgrep "" | grep -v $launcher_pid); do
				prev_adj=$(cat /proc/$prev_pid/oom_adj)
				if [ "$prev_adj" -ge 2 ] && [ "$prev_adj" -le "$launcher_adj" ]; then
					prev_score=$(cat /proc/$prev_pid/score)
					break
				fi
			done
			if [ "$prev_pid" ]; then
				while true; do
					for pid in $(pgrep "" | grep -v $launcher_pid); do
						adj=$(cat /proc/$pid/oom_adj)
						if [ "$adj" -ge 2 ] && [ "$adj" -le "$launcher_adj" ]; then
							score=$(cat /proc/$pid/score)
							if [ "$score" -gt "$prev_score" ]; then
								prev_pid=$pid
								prev_score=$score
							fi
						fi
					done
					kill $prev_pid
					if [ "$(($(grep -i "^Cached:" /proc/meminfo | awk '{print $2}')+$(grep -i "^Memfree:" /proc/meminfo | awk '{print $2}')))" -ge "$heapalloc" ]; then
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
		if [ "$(getprop $BASE_NAME.autogen)" == false ] || [ "$(getprop $BASE_NAME.autogen)" == terminated ]; then
			setprop $BASE_NAME.autogen terminated
			kill $autogen_pid
			kill $$
		fi
		launcher_pid=$(pgrep $launcher)
		if [ "$launcher_pid" ]; then
			if [ "$(cat /proc/$launcher_pid/oom_adj)" -ne "$launcher_adj" ]; then
				kill $autogen_pid
				launchseq
				autogen $1 & autogen_pid=$!
			fi
		fi
		sleep 5
	done
}
opt_g(){
	interval_default=0
	interval=$opt_t_val
	if [ ! "$interval" ]; then
		interval_default=1
		interval=5
	fi
	if [ "$(getprop $BASE_NAME.autogen)" == true ]; then
		echo "killing previous forked AMS grouping manager..."
		opt_x autogen
		echo "re-forking AMS grouping manager..."
	else
		echo "forking AMS grouping manager..."
	fi
	loopcheck $interval &
	echo "new codename for this service is \"autogen\". you can type \"[program name] -x autogen\" in terminal whenever you want to stop the service."
	echo -n "refresh rate interval was set to "
	if [ "$interval_default" -eq 1 ]; then
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
	if [ "$priority" ]; then
		if [ "$priority" -gt 200 ]; then
			priority=200
		elif [ "$priority" -lt 5 ]; then
			priority=5
		fi
	else
		default=1
		priority=5
	fi
	error=0
	renice_val=$(echo $priority | awk '{printf "%.0f\n", 20-$1/5}')
	echo "checking for services..."
	for i in $(pgrep ""); do
		if [ "$(grep -i "^PPid:" /proc/$i/status | grep -o [0-9]* | grep "\<$(pgrep zygote)\>")" ]; then
			if [ -e /proc/$i/oom_adj ] && [ "$(cat /proc/$i/oom_adj)" -lt 0 ]; then
				if [ -e /proc/$i/task ]; then
					success=0
					for j in $(ls /proc/$i/task); do
						renice $renice_val $j
						stat=$(cat /proc/$i/task/$j/stat)
						rm=${stat#*)}
						nicelevel=$(echo $rm | cut -d' ' -f17)
						if [ "$nicelevel" -eq "$renice_val" ]; then
							success=$((success+1))
						fi
					done
					if [ "$(ls /proc/$i/task | wc -l)" -eq "$success" ]; then
						echo "optimization successful on $(cat /proc/$i/comm)"
					else
						error=$((error+1))
						echo "optimization failed on $(cat /proc/$i/comm)"
					fi
				fi
			fi
		fi
	done
	if [ "$error" -gt 0 ]; then
		echo "total $error errors found."
		return=1
	else
		echo "services optimization complete!"
	fi
	echo -n "cpulimit was set to "
	if [ "$default" -eq 1 ]; then
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
	if [ "$return" -eq 0 ]; then
		return=0
		skip=0
		for i in $(seq -s ' $mslot' 0 6 | sed 's/^0//'); do
			v=$(eval echo $i)
			if [ "$v" ]; then
				return=0
				$v
				if [ "$v" != opt_p ] && [ "$v" != opt_t ] && [ "$v" != opt_x ]; then
					echo
				fi
				if [ "$return" -ge 1 ] || [ "$skip" -eq 1 ]; then
					return $return
				fi
			else
				break
			fi
		done
		for i in $(seq -s ' $fslot' 0 6 | sed 's/^0//'); do
			v=$(eval echo $i)
			if [ "$v" ]; then
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
	# We export main instructions to memory for later check.
	export opt_p=0
	export opt_t=0
	export opt_h=0
	export opt_x=0
	export opt_k=0
	export opt_g=0
	export opt_m=0
	
	# Parameters needed for Roll_Up
	count=0
	fcount=0

	# Extra instructions that must not have initial values
	opt_p_val=
	opt_t_val=
	opt_x_val=

	# Error messages
	sop_error="same operation not permitted"
	val_error="requires a value"
	num_error="requires a numerical value"
	neg_error="requires a non-negative number as a value"
	nfp_error="requires a non-floating point number as a value"
	arg_error="invalid argument"
	req_error="expects an argument"
	lmt_error="out of range"
	
	if [ ! "$1" ]; then
		return 1
	fi
	if [ "$1" == 69 ]; then
		echo -e "\e[1;36mHi, zepp!:D\e[0m"
	elif [ "$1" == 1337 ]; then
		echo -e "\e[1;32myou ain't elite, \e[1;31mI AM.\e[0m"
	fi
	while [ "$1" ]; do
		case $1 in
			-p* | --priority*)
				if [ "$(echo $1 | grep '^-p')" ]; then
					mode="-p"
				else
					mode="--priority"
				fi
				if [ "$opt_p" -gt 0 ]; then
					echo "$mode: $sop_error"
					return 1
				fi
				fcount=$((fcount+1))
				export mslot$fcount=opt_p
				opt_p=$(($opt_p+1))
				if [ ! "$(echo $1 | sed 's/^'"$mode"'//')" ]; then
					if [ "$2" ]; then
						opt_p_val=$2
					else
						echo "$mode: $val_error"
						return 1
					fi
					if [ "$(echo $opt_p_val | grep '\.')" ]; then
						echo "$mode: $nfp_error"
						return 1
					fi
					if [ "$(echo $opt_p_val | grep '^-')" ]; then
						if [ "$(echo $opt_p_val | sed 's/^-//; s/[0-9]*//g')" ]; then
							echo "$mode: $val_error"
							return 1
						fi
					else
						if [ "$(echo $opt_p_val | sed 's/[0-9]*//g')" ]; then
							echo "$mode: $num_error"
							return 1
						fi
					fi
					shift
				else
					if [ "$(echo $1 | sed 's/^'"$mode"'//' | grep '\.')" ]; then
						echo "$mode: $nfp_error"
						return 1
					fi
					if [ "$(echo $1 | sed 's/^'"$mode"'//' | grep '^-')" ]; then
						if [ "$(echo $1 | sed 's/^'"$mode"'//; s/^-//; s/[0-9]*//g')" ]; then
							echo "$mode: $val_error"
							return 1
						fi
					else
						if [ "$(echo $1 | sed 's/^'"$mode"'//; s/[0-9]*//g')" ]; then
							echo "$mode: $num_error"
							return 1
						fi
					fi
					opt_p_val=$(echo $1 | sed 's/^'"$mode"'//')
				fi
			;;
			-t* | --time*)
				if [ "$(echo $1 | grep '^-t')" ]; then
					mode="-t"
				else
					mode="--time"
				fi
				if [ "$opt_t" -gt 0 ]; then
					echo "$mode: $sop_error"
					return 1
				fi
				fcount=$((fcount+1))
				export mslot$fcount=opt_t
				opt_t=$(($opt_t+1))
				if [ ! "$(echo $1 | sed 's/^'"$mode"'//')" ]; then
					if [ "$2" ]; then
						opt_t_val=$2
					else
						echo "$mode: $val_error"
						return 1
					fi
					if [ "$(echo $opt_t_val | grep '-')" ]; then
						if [ "$(echo $opt_t_val | sed 's/^-//; s/[0-9]*//g; s/\.//')" ]; then
							echo "$mode: $val_error"
							return 1
						else
							echo "$mode: $neg_error"
							return 1
						fi
					fi
					if [ "$(echo $opt_t_val | grep '\.')" ]; then
						if [ "$(echo $opt_t_val | sed 's/[0-9]*//g; s/\.//')" ]; then
							echo "$mode: $num_error"
							return 1
						fi
					fi
					if [ "$(echo $opt_t_val | sed 's/^-//; s/[0-9]*//g; s/\.//')" ]; then
						echo "$mode: $num_error"
						return 1
					fi
					shift
				else
					if [ "$(echo $1 | sed 's/^'"$mode"'//' | grep '-')" ]; then
						if [ "$(echo $1 | sed 's/^'"$mode"'//' | sed 's/^-//; s/[0-9]*//g; s/\.//')" ]; then
							echo "$mode: $num_error"
							return 1
						else
							echo "$mode: $neg_error"
							return 1
						fi
					fi
					if [ "$(echo $1 | sed 's/^'"$mode"'//' | grep '\.')" ]; then
						if [ "$(echo $1 | sed 's/^'"$mode"'//' | sed 's/[0-9]*//g; s/\.//')" ]; then
							echo "$mode: $num_error"
							return 1
						fi
					fi
					if [ "$(echo $1 | sed 's/^'"$mode"'//' | sed 's/^-//; s/[0-9]*//g; s/\.//')" ]; then
						echo "$mode: $num_error"
						return 1
					fi
					opt_t_val=$(echo $1 | sed 's/^'"$mode"'//')
				fi
			;;
			-x* | --exit*)
				if [ "$(echo $1 | grep '^-x')" ]; then
					mode="-x"
				else
					mode="--exit"
				fi
				if [ "$opt_x" -gt 0 ]; then
					echo "$mode: $sop_error"
					return 1
				fi
				fcount=$((fcount+1))
				export mslot$fcount=opt_x
				opt_x=$(($opt_x+1))
				if [ ! "$(echo $1 | sed 's/^'"$mode"'//')" ]; then
					if [ "$2" ]; then
						if [ ! "$(echo $2 | grep '^-')" ]; then
							opt_x_val=$2
							shift
						fi
					fi
				else
					opt_x_val=$(echo $1 | sed 's/^'"$mode"'//')
				fi
			;;
			*)
				if [ ! "$(echo $1 | sed 's/^-//')" ]; then
					echo "$1: $arg_error"
					return 1
				fi
				n=0
				for i in $(echo $1 | sed 's/.\{1\}/& /g'); do
					if [ "$i" != "-" ]; then
						break
					fi
					n=$(($n+1))
				done
				if [ "$n" -eq 1 ]; then
					if [ ! "$(echo $1 | sed 's/^-//; s/[0-9]*//g; s/\.//')" ]; then
						if [ "$opt_p" -gt 0 ]; then
							if [ "$mode" ]; then
								echo "$mode: $sop_error"
							else
								echo "-p: $sop_error"
							fi
							return 1
						fi
						fcount=$((fcount+1))
						export mslot$fcount=opt_p
						opt_p=$(($opt_p+1))
						if [ "$(echo $1 | sed 's/^-//' | grep '\.')" ]; then
							echo "-p: $nfp_error"
							return 1
						fi
						opt_p_val=$(echo $1 | sed 's/^-//')
					else
						for i in $(echo $1 | sed 's/^-//; s/.\{1\}/& /g'); do
							case $i in
								h)
									if [ "$opt_h" -gt 0 ]; then
										echo "-h: $sop_error"
										return 1
									fi
									fcount=$((fcount+1))
									export mslot$fcount=opt_h
									opt_h=$(($opt_h+1))
								;;
								k)
									if [ "$opt_k" -gt 0 ]; then
										echo "-k: $sop_error"
										return 1
									fi
									count=$((count+1))
									export fslot$count=opt_k
									opt_k=$(($opt_k+1))
								;;
								g)
									if [ "$opt_g" -gt 0 ]; then
										echo "-g: $sop_error"
										return 1
									fi
									count=$((count+1))
									export fslot$count=opt_g
									opt_g=$(($opt_g+1))
								;;
								m)
									if [ "$opt_m" -gt 0 ]; then
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
				elif [ "$n" -eq 2 ]; then
					if [ ! "$(echo $1 | sed 's/^--//')" ]; then
						echo "$1: $arg_error"
						return 1
					else
						for i in $(echo $1 | sed 's/^--//'); do
							case $i in
								help)
									if [ "$opt_h" -gt 0 ]; then
										echo "--help: $sop_error"
										return 1
									fi
									fcount=$((fcount+1))
									export mslot$fcount=opt_h
									opt_h=$(($opt_h+1))
								;;
								kernel)
									if [ "$opt_k" -gt 0 ]; then
										echo "--kernel: $sop_error"
										return 1
									fi
									count=$((count+1))
									export fslot$count=opt_k
									opt_k=$(($opt_k+1))
								;;
								grouping)
									if [ "$opt_g" -gt 0 ]; then
										echo "--grouping: $sop_error"
										return 1
									fi
									count=$((count+1))
									export fslot$count=opt_g
									opt_g=$(($opt_g+1))
								;;
								mediaserver)
									if [ "$opt_m" -gt 0 ]; then
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
		if [ "$opt_p_val" ]; then
			if [ "$opt_p_val" -gt 200 ] || [ "$opt_p_val" -lt 5 ]; then
				echo "-p: $lmt_error"
				return 1
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
	-k | --kernel) runs direct I/O call optimizer.
	-g | --grouping) launchs AMS process grouping utility.
	-m | --mediaserver) runs services optimizer.
	type -h or --help for more description.
"
}

# Main script

# Allow users to bypass root check when necessary.
if [ "$1" == bypass ]; then
	run_Superuser=no
	shift
fi
Roll_Down
Magic_Parser $@
Roll_Up

# End session.
return=$?
return $return

