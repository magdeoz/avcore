CLIPPER_VERSION=0.0.3
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
set +e
# Un-comment out the following line to enable debugging.
#set -x

# Custom settings for session behaviour: say 'yes' to enable, 'no' to disable.
# Busybox Applet Generator(BAG) 2.2(important for Android devices)
run_BAG=yes
# Check Superuser.
run_Superuser=yes

# Busybox Applet Generator(BAG) 2.2
# You can type in any commands you would want it to check.
# It will start by checking from cmd1, and its limit is up to cmd224.
cmd1=renice
cmd2=ionice
cmd= # It notifies the generator how many cmds are available for check. Leave it as blank.
# This feature might not be compatible with some other multi-call binaries.
BAG()
{
if [ ! "$(busybox --list)" ]; then
	if [ "$(busybox)" ]; then
		echo "Your busybox is outdated!"
		return 1
	else
		echo "Failed to locate busybox!"
		return 1
	fi
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
			if [ ! "$(busybox --list | grep $v)" ]; then
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
fi 2>/dev/null
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
	if [ "$run_BAG" ] && [ "$run_BAG" == yes ]; then
		BAG
	fi
	if [ "$?" -ne 0 ]; then
		exit 1
	fi
	if [ "$run_Superuser" ] && [ "$run_Superuser" == yes ]; then
		Superuser
	fi
	if [ "$?" -ne 0 ]; then
		exit 1
	fi
}

## Following is a user editable area.

opt_p()
{
	count=0
	for i in $(env | grep "^opt.*" | grep -v "opt_p" | grep -v "opt_h" | grep -v "opt_x" ); do
		if [ "${i#*=}" == 1 ]; then
			count=$((count+1))
		fi
	done
	if [ "$count" -eq 0 ]; then
		echo "-p: none of the actions were selected to be applied."
		Usage
		return=1
	fi
}

opt_h()
{
	echo "SOME BASIC STUFF THAT YOU SHOULD KNOW:
	-h or --help views this message.
	-x or --exit does not work in this current version.
	more options are coming soon to later versions.

HOW TO USE -p:
	-p or --priority is a master priority set.
	it is only used for setting a custom value on options such as -k and -g.
	so, if -p is not entered while running them, don't worry.
	they use their own default settings built in.;)
	custom values are limited from 0% to 200%.(percentage)

	for example, if you want to set 84 as a custom value,
	you can type: -p 84, -p84, --priority 84, --priority84, or even -84.
	unlike -k or -g, -p option needs to be written independently
	from other options like so: -p84 -hxkgm, or -h -k -p84 -g -x -m.
	these will not work: -hxkgmp84, or -hxkgpm84.

OTHER OPTIONS:
	-k or --kernel is a kernel driver management utility.
	it will tune your kernel driver processes to save more resources,
	and try to give more of those to the poor ones.

	-g or --grouping is a AMS process grouping utility.
	AMS stands for: Activity Manager Service.
	its an unfinished product, therefore no more description for now.

	-m or -mediaserver lets you to control the resource usage of media scanner.
	this 'media scanner' process is your primary source of all lags and battery drains.
	so why not control this thing for our benefits?

CLIPPER VERSION $CLIPPER_VERSION
Copyright (C) 2013  LENAROX@xda
"
}

opt_x()
{
	echo "not available."
	return=1
}

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
	echo "checking for kernel drivers..."
	for i in $(pgrep "" | grep -v $(pgrep zygote)); do
		if [ "$(grep -i "^PPid:" /proc/$i/status | grep -o [0-9]* | grep "^2$")" ]; then
			if [ "$(grep "^worker_thread$" /proc/$i/wchan)" ]; then
				renice $renice_val $i
			fi
		elif [ "$(grep -i "^PPid:" /proc/$i/status | grep -o [0-9]* | grep "^1$")" ]; then
			if [ ! "$(grep "^binder_thread_read$" /proc/$i/wchan)" ]; then
				renice $renice_val2 $i
			fi
		fi
	done
	echo "final looping..."
	for i in $(pgrep "" | grep -v $(pgrep zygote)); do
		if [ "$(grep -i "^PPid:" /proc/$i/status | grep -o [0-9]* | grep "^2$")" ]; then
			if [ "$(grep "^worker_thread$" /proc/$i/wchan)" ]; then
				if [ "$(cut -d " " -f 19 /proc/$i/stat)" -eq "$renice_val" ]; then
					noerror=$(($noerror+1))
				else
					error=$(($error+1))
				fi
			fi
		elif [ "$(grep -i "^PPid:" /proc/$i/status | grep -o [0-9]* | grep "^1$")" ]; then
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
	renice_val=$(echo $priority | awk '{printf "%.0f\n", 20-$1/5}')
	echo "waiting for mediaserver..."
	while true; do
		mediaserver=$(pgrep android.process.media)
		if [ "$mediaserver" ]; then
			renice $renice_val $mediaserver
			if [ "$(cut -d " " -f 19 /proc/$mediaserver/stat)" -ne "$renice_val" ]; then
				return=1
			fi
			break
		fi
		sleep 1
	done
	if [ "$return" -eq 1 ]; then
		echo "Manager was not able to continue the progress, due to a critical error."
	else
		echo "mediaserver optimization complete!"
		echo -n "cpulimit was set to "
		if [ "$default" -eq 1 ]; then
			echo "default by $priority%"
		else
			echo "$priority%"
		fi
		echo
		echo "mediaserver optimizer last run on $(date)"
	fi
}

# Put your engine stuffs here.
Roll_Up()
{
	if [ "$?" -eq 0 ]; then
		return=0
		if [ "$opt_p" -eq 1 ]; then
			opt_p
		fi
		if [ "$opt_h" -eq 1 ]; then
			opt_h
		fi
		if [ "$opt_x" -eq 1 ]; then
			opt_x
		fi
		if [ "$opt_k" -eq 1 ]; then
			opt_k
		fi
		if [ "$opt_g" -eq 1 ]; then
			opt_g
		fi
		if [ "$opt_m" -eq 1 ]; then
			opt_m
		fi
		return $return
	else
		Usage
		return 1
	fi
}

# Put your extra options for your engine here.
Magic_Parser()
{
	# We export main instructions to memory for later check.
	export opt_p=0
	export opt_h=0
	export opt_x=0
	export opt_k=0
	export opt_g=0
	export opt_m=0

	# Extra instructions that doesn't need export
	opt_p_val=0

	# Error messages
	sop_error=$(echo 'same operation not permitted')
	val_error=$(echo 'requires a value')
	int_error=$(echo 'requires an integer number as a value')
	arg_error=$(echo 'invalid argument')
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
						opt_p=$(($opt_p+1))
						opt_p_val=$(echo $1 | sed 's/^-//')
					else
						for i in $(echo $1 | sed 's/^-//; s/.\{1\}/& /g'); do
							if [ "$i" == h ]; then
								if [ "$opt_h" -gt 0 ]; then
									echo "-h: $sop_error"
									return 1
								fi
								opt_h=$(($opt_h+1))
							elif [ "$i" == x ]; then
								if [ "$opt_x" -gt 0 ]; then
									echo "-x: $sop_error"
									return 1
								fi
								opt_x=$(($opt_x+1))
							elif [ "$i" == k ]; then
								if [ "$opt_k" -gt 0 ]; then
									echo "-k: $sop_error"
									return 1
								fi
								opt_k=$(($opt_k+1))
							elif [ "$i" == g ]; then
								if [ "$opt_g" -gt 0 ]; then
									echo "-g: $sop_error"
									return 1
								fi
								opt_g=$(($opt_g+1))
							elif [ "$i" == m ]; then
								if [ "$opt_m" -gt 0 ]; then
									echo "-m: $sop_error"
									return 1
								fi
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
							opt_h=$(($opt_h+1))
						elif [ "$i" == exit ]; then
							if [ "$opt_x" -gt 0 ]; then
								echo "--exit: $sop_error"
								return 1
							fi
							opt_x=$(($opt_x+1))
						elif [ "$i" == kernel ]; then
							if [ "$opt_k" -gt 0 ]; then
								echo "--kernel: $sop_error"
								return 1
							fi
							opt_k=$(($opt_k+1))
						elif [ "$i" == grouping ]; then
							if [ "$opt_g" -gt 0 ]; then
								echo "--grouping: $sop_error"
								return 1
							fi
							opt_g=$(($opt_g+1))
						elif [ "$i" == mediaserver ]; then
							if [ "$opt_m" -gt 0 ]; then
								echo "--mediaserver: $sop_error"
								return 1
							fi
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

# Customize Usage for your own needs.
Usage()
{
	echo "Usage: $(basename $0) -hxkgm -p [VALUE]
	-p | --priority) master priority set
	-x | --exit) ends the process already running in background.
	-k | --kernel) run kernel driver management utility
	-g | --grouping) launch AMS process grouping utility
	-m | --mediaserver) mediaserver optimizer
	type -h or --help for more description.
"
}

## Aaand, you're good to go!

# Main script
Roll_Down
Magic_Parser $@
Roll_Up

# End session.
exit $?

