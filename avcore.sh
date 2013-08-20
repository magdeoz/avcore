CLIPPER_VERSION=0.0.4
# Copyright (C) 2013  LENAROX@xda
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
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Changelogs:
# 0.0.1 - first release
#       - updated Busybox Applet Generator to 2.2.
# 0.0.2 - fixed lots of buggy stuff, thanks to defiant07 for a ton of help.:)
# 0.0.3 - removed 'help' regex, due to unsupported regex patterns on most shells.
#       - removed Priority_Info for bash compatibility.
#       - implemented in-order execution on secondary opts.
#       - some new engines were implemented for demonstration.
# 0.0.4 - created another independent in-order execution for main opts.
#       - new -t function added.
#       - fcount missing error fixed.
#       - multiple error message bug fixed.
#       - fixed some bugs on -p function.
#       - updated Busybox Applet Generator to 2.3.
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
cmd2=ionice
cmd= # It notifies the generator how many cmds are available for check. Leave it as blank.
# This feature might not be compatible with some other multi-call binaries.
Busybox_Applet_Generator()
{
	if [ ! "$(busybox)" ]; then
		echo "Failed to locate busybox!"
		return 1
	fi
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
				echo "Required applets are missing!"
				return 1
			fi
			if [ ! -e "$busyboxloc"/"$v" ]; then
				alias $i="busybox $i"
			fi
		else
			break
		fi
	done
}

# Check Superuser.
Superuser()
{
	if [ "$(id -u)" != 0 ] && [ "$(id -u)" != root ]; then
		echo "Permission denied, are you root?"
		return 1
	fi
}

# Session behaviour
Roll_Down()
{
	if [ "$run_Busybox_Applet_Generator" ] && [ "$run_Busybox_Applet_Generator" == yes ]; then
		Busybox_Applet_Generator
		if [ "$?" -ne 0 ]; then
			exit 1
		fi
	fi
	if [ "$run_Superuser" ] && [ "$run_Superuser" == yes ]; then
		Superuser
		if [ "$?" -ne 0 ]; then
			exit 1
		fi
	fi
}

# Master priority control set
opt_p()
{
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
	else
		if [ "$opt_p_val" -gt 200 ]; then
			opt_p_val=200
		elif [ "$opt_p_val" -lt 5 ]; then
			opt_p_val=5
		fi
	fi
}

# Master sync control set
opt_t()
{
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
opt_h()
{
	echo "SOME BASIC STUFF THAT YOU SHOULD KNOW:
	-h or --help views this message.
	-x or --exit does not work in this current version.
	more options are coming soon to later versions.

HOW TO USE -p:
	-p or --priority is a master priority control set.
	it is only used for setting a custom value on options such as -k and -g.
	so, if -p is not entered while running them, default values will encounter.
	custom values are limited from 0% to 200%.(percentage)

	for example, if you want to set 84 as a custom value,
	you can type: -p 84, -p84, --priority 84, --priority84, or even -84.('-' is a reserved mark ONLY for -p)
	unlike -k or -g, -p option needs to be written independently
	from other options like so: -p84 -hxkgm, or -h -k -p84 -g -x -m.
	
	reminder: -p must be input independently from other options.
	these will not work or likely to give out syntax errors: -hxkgmp84, or -hxkgpm84.
	
HOW TO USE -t:
	-t is a new feature implemented to 0.0.4 to keep track of timing between each commands.
	its usage is basically same as -p.
	reminder: -[value] argument won't work on -t.

OTHER OPTIONS:
	-k or --kernel is a kernel driver management utility.
	it will tune your kernel driver processes to save more resources,
	and try to give more of those to the poor ones.

	-g or --grouping is a AMS process grouping utility.
	AMS stands for: Activity Manager Service.
	its an unfinished product, therefore no more description for now.

	-m or -mediaserver lets you to control the overall resource usage of server processes.
	these server processes are your primary source of all lags and battery drains.

CLIPPER VERSION $CLIPPER_VERSION
Copyright (C) 2013  LENAROX@xda
"
	skip=1
}

# End of the line
opt_x()
{
	echo "not available."
	return=1
	skip=1
}

# Kernel driver management utility
opt_k()
{
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
	renice_val=$(echo $kernel_priority | awk '{printf "%.0f\n", 20-$1/5}')
	renice_val2=$(echo $driver_priority | awk '{printf "%.0f\n", 20-$1/5}')
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

# KDMU support
Priority_Killer()
{
	renice 19 $$
	ionice -c2 -n7 -p$$
	while true; do
		if [ "$(ps | awk '/[0-9]/&&!/]|\/*bin\/|\/init|_server/' | wc -l)" -gt $(($(cut -d " " -f 19 /proc/$(pgrep zygote)/stat)+21)) ]; then
			least=0
			pid=0
			for i in $(pgrep ""); do
				if [ $least == 0 ] || [ $pid == 0 ]; then
					least=$(cat /proc/$i/oom_score)
					pid=$i
				else
					now=$(cat /proc/$i/oom_score)
					if [ $least -lt $now ]; then
						least=$now
						pid=$i
					fi
				fi
			done
			kill -9 $pid
		fi | sleep 5
	done
}

# AMS process grouping utility
opt_g()
{
	if [ "$(pgrep system_server)" ]; then
		echo "-g: this options is only executable via init process."
		Usage
		return=1
	else
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
			priority=200
		fi
		renice_val=$(echo $priority | awk '{printf "%.0f\n", 20-$1/5}')
		inverted_val=$((renice_val*-1-1))
		echo "waiting for zygote..."
		while true; do
			zygote=$(pgrep zygote)
			if [ "$zygote" ]; then
				renice $renice_val $zygote
				echo "waiting for system_server..."
				while true; do
					system_server=$(pgrep system_server)
					if [ "$system_server" ]; then
						if [ "$(cut -d " " -f 19 /proc/$system_server/stat)" -eq "$renice_val" ]; then
							renice $inverted_val $zygote
						else
							return=1
						fi
						break
					fi
					sleep 1
				done
				break
			fi
			sleep 1
		done
		if [ "$return" -eq 1 ]; then
			echo "Manager was not able to continue the progress, due to a critical error."
		else
			echo "system_server hijacking complete! ready to rock:D"
			echo -n "cpulimit was set to "
			if [ "$default" -eq 1 ]; then
				echo "default by $priority%"
			else
				echo "$priority%"
			fi
			echo
			echo "AMS process grouping utility started on $(date)"
			Priority_Killer &
		fi
	fi
}

# Server process optimization
opt_m()
{
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
		priority=50
	fi
	for i in $(sed 's/,/ /g; s/^0//' /sys/module/lowmemorykiller/parameters/adj); do
		if [ "$i" -gt 15 ]; then
			oom_score_adj=1
		else
			oom_score_adj=0
		fi
	done
	error=0
	renice_val=$(echo $priority | awk '{printf "%.0f\n", 20-$1/5}')
	echo "looking for server processes..."
	for i in $(pgrep ""); do
		if [ "$oom_score_adj" -eq 1 ]; then
			if [ "$(cat /proc/$i/oom_score_adj)" -eq -705 ]; then
				renice $renice_val $i
			fi
		else
			if [ "$(cat /proc/$i/oom_adj)" -eq -12 ]; then
				renice $renice_val $i
			fi
		fi
	done
	echo "final checking..."
	for i in $(pgrep ""); do
		if [ "$oom_score_adj" -eq 1 ]; then
			if [ "$(cat /proc/$i/oom_score_adj)" -eq -705 ]; then
				if [ "$(cut -d " " -f 19 /proc/$i/stat)" -eq $renice_val ]; then
					cat /proc/$i/comm
					echo " was successfully optimized."
				else
					error=$((error+1))
					cat /proc/$i/comm
					echo " was failed to be optimized."
				fi
			fi
		else
			if [ "$(cat /proc/$i/oom_adj)" -eq -12 ]; then
				if [ "$(cut -d " " -f 19 /proc/$i/stat)" -eq $renice_val ]; then
					cat /proc/$i/comm
					echo " was successfully optimized."
				else
					error=$((error+1))
					cat /proc/$i/comm
					echo " was failed to be optimized."
				fi
			fi
		fi
	done
	if [ "$error" -gt 0 ]; then
		echo "total $error errors were found."
		return=1
	else
		echo "server process optimization complete!"
	fi
	echo -n "cpulimit was set to "
	if [ "$default" -eq 1 ]; then
		echo "default by $priority%"
	else
		echo "$priority%"
	fi
	echo
	echo "server process optimizer last run on $(date)"
}

# Advanced in-order execution
Roll_Up()
{
	if [ "$?" -eq 0 ]; then
		return=0
		skip=0
		for i in $(seq -s ' $mslot' 0 6 | sed 's/^0//'); do
			v=$(eval echo $i)
			if [ "$v" ]; then
				return=0
				$v
				if [ "$return" -eq 1 ] || [ "$skip" -eq 1 ]; then
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
			else
				break
			fi
		done
		return $return
	else
		Usage
		return 1
	fi
}

# Parse user input.
Magic_Parser()
{
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

	# Extra instructions that doesn't need export
	opt_p_val=0
	opt_t_val=0

	# Error messages
	sop_error=$(echo 'same operation not permitted')
	val_error=$(echo 'requires a value')
	int_error=$(echo 'requires an integer number as a value')
	arg_error=$(echo 'invalid argument')
	req_error=$(echo 'expects a correspondable argument')
	
	if [ ! "$1" ]; then
		return 1
	fi
	while [ "$1" ]; do
		case $1 in
			-p* | --priority* )
				if [ "$(echo $1 | grep "^-p")" ]; then
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
					if [ "$(echo $opt_p_val | grep "^-")" ]; then
						echo "$mode: $val_error"
						return 1
					else
						if [ "$(echo $opt_p_val | sed 's/[0-9]//g')" ]; then
							echo "$mode: $int_error"
							return 1
						fi
					fi
					shift
				else
					if [ "$(echo $1 | sed 's/^'"$mode"'//; s/[0-9]//g')" ]; then
						echo "$mode: $int_error"
						return 1
					fi
					opt_p_val=$(echo $1 | sed 's/^'"$mode"'//')
				fi
			;;
			-t* | --time* )
				if [ "$(echo $1 | grep "^-t")" ]; then
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
					if [ "$(echo $opt_t_val | grep "^-")" ]; then
						echo "$mode: $val_error"
						return 1
					else
						if [ "$(echo $opt_t_val | sed 's/[0-9]//g')" ]; then
							echo "$mode: $int_error"
							return 1
						fi
					fi
					shift
				else
					if [ "$(echo $1 | sed 's/^'"$mode"'//; s/[0-9]//g')" ]; then
						echo "$mode: $int_error"
						return 1
					fi
					opt_t_val=$(echo $1 | sed 's/^'"$mode"'//')
				fi
			;;
			* )
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
					if [ ! "$(echo $1 | sed 's/^-//; s/[0-9]//g')" ]; then
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
						opt_p_val=$(echo $1 | sed 's/^-//')
					else
						for i in $(echo $1 | sed 's/^-//; s/.\{1\}/& /g'); do
							if [ "$i" == h ]; then
								if [ "$opt_h" -gt 0 ]; then
									echo "-h: $sop_error"
									return 1
								fi
								fcount=$((fcount+1))
								export mslot$fcount=opt_h
								opt_h=$(($opt_h+1))
							elif [ "$i" == x ]; then
								if [ "$opt_x" -gt 0 ]; then
									echo "-x: $sop_error"
									return 1
								fi
								fcount=$((fcount+1))
								export mslot$fcount=opt_x
								opt_x=$(($opt_x+1))
							elif [ "$i" == k ]; then
								if [ "$opt_k" -gt 0 ]; then
									echo "-k: $sop_error"
									return 1
								fi
								count=$((count+1))
								export fslot$count=opt_k
								opt_k=$(($opt_k+1))
							elif [ "$i" == g ]; then
								if [ "$opt_g" -gt 0 ]; then
									echo "-g: $sop_error"
									return 1
								fi
								count=$((count+1))
								export fslot$count=opt_g
								opt_g=$(($opt_g+1))
							elif [ "$i" == m ]; then
								if [ "$opt_m" -gt 0 ]; then
									echo "-m: $sop_error"
									return 1
								fi
								count=$((count+1))
								export fslot$count=opt_m
								opt_m=$(($opt_m+1))
							else
								echo "$1: $arg_error"
								return 1
							fi
						done
					fi
				elif [ "$n" -eq 2 ]; then
					for i in $(echo $1 | sed 's/^--//'); do
						if [ "$i" == help ]; then
							if [ "$opt_h" -gt 0 ]; then
								echo "--help: $sop_error"
								return 1
							fi
							fcount=$((fcount+1))
							export mslot$fcount=opt_h
							opt_h=$(($opt_h+1))
						elif [ "$i" == exit ]; then
							if [ "$opt_x" -gt 0 ]; then
								echo "--exit: $sop_error"
								return 1
							fi
							fcount=$((fcount+1))
							export mslot$fcount=opt_x
							opt_x=$(($opt_x+1))
						elif [ "$i" == kernel ]; then
							if [ "$opt_k" -gt 0 ]; then
								echo "--kernel: $sop_error"
								return 1
							fi
							count=$((count+1))
							export fslot$count=opt_k
							opt_k=$(($opt_k+1))
						elif [ "$i" == grouping ]; then
							if [ "$opt_g" -gt 0 ]; then
								echo "--grouping: $sop_error"
								return 1
							fi
							count=$((count+1))
							export fslot$count=opt_g
							opt_g=$(($opt_g+1))
						elif [ "$i" == mediaserver ]; then
							if [ "$opt_m" -gt 0 ]; then
								echo "--mediaserver: $sop_error"
								return 1
							fi
							count=$((count+1))
							export fslot$count=opt_m
							opt_m=$(($opt_m+1))
						else
							echo "$1: $arg_error"
							return 1
						fi
					done
				else
					echo "$1: $arg_error"
					return 1
				fi
			;;
		esac
		shift
	done
}

# Yet, this is still considered as one of the error messages.
Usage()
{
	echo "Usage: $(basename $0) -hxkgm -p [VALUE] -t [VALUE]
	-p | --priority) for master priority control set.
	-t | --time) for master sync control set.
	-x | --exit) ends the spawned process.
	-k | --kernel) runs kernel driver management utility.
	-g | --grouping) launchs AMS process grouping utility.
	-m | --mediaserver) runs server process optimization.
	type -h or --help for more description.
"
}

# Main script
Roll_Down
Magic_Parser $@
Roll_Up

# End session.
exit $?

