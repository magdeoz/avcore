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
# Busybox Applet Generator(BAG) 2.1(important for Android devices)
run_BAG=yes
# Check Superuser.
run_Superuser=yes

# Busybox Applet Generator(BAG) 2.1
# You can type in any commands you would want it to check.
# It will start by checking from cmd1, and its limit is up to cmd224.
cmd1=renice
cmd2=ionice
# This feature might not be compatible with some other multi-call binaries.
BAG()
{
if [ ! "$(busybox --list)" ]; then
	echo "Failed to locate busybox!"
	return 1
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
	if [ "$cmd" -lt 0 ]; then
		cmd=0
	fi
	for i in $(seq -s ' $cmd' 0 224 | sed 's/^0//'); do
		v=$(eval echo $i)
		if [ "$v" ]; then
			if [ ! "$(busybox --list | grep $v)" ]; then
				echo "Required applets are missing!"
				return 1
			fi
			n=0
			if [ -e "$busyboxloc"/"$v" ]; then
				n=$(($n+1))
			fi
			if [ "$n" -eq 0 ]; then
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
	if [ "$run_Superuser" ] && [ "$run_Superuser" == yes ]; then
		Superuser
	fi
	if [ "$?" -ne 0 ]; then
		exit $?
	fi
}

## Following is a user editable area.

# Put your engine stuffs here.
Roll_Up()
{
	if [ "$?" -eq 0 ]; then
		if [ "$opt_p" -eq 1 ]; then
			echo "priority: $opt_p_val" 
		fi
		if [ "$opt_x" -eq 1 ]; then
			echo test confirmed
		fi
		if [ "$opt_h" -eq 1 ]; then
			Usage
		fi
	else
		Usage
	fi
}

# Put your extra options for your engine here.
Magic_Parser()
{
	opt_p=0
	opt_p_val=0
	opt_x=0
	opt_h=0
	while [ "$1" ]; do
		case $1 in
			-p* | --priority* )
				if [ "$(echo $1 | grep -w "^-p.*")" ]; then
					mode="-p"
				else
					mode="--priority"
				fi
				if [ "$opt_p" -gt 0 ]; then
					echo "$mode": same operation not permitted
					return 1
				fi
				opt_p=$(($opt_p+1))
				if [ ! "$(echo $1 | sed 's/^'"$mode"'//')" ]; then
					if [ "$2" ]; then
						opt_p_val=$2
					else
						echo "$mode": requires a value
						return 1
					fi
					if [ "$(echo $opt_p_val | grep "^-")" ]; then
						echo "$mode": requires a value
						return 1
					else
						if [ "$(echo $opt_p_val | tr -d "0-9")" ]; then
							echo "$mode": requires an integer number as a value
							return 1
						fi
					fi
					shift
				else
					if [ "$(echo $1 | sed 's/^'"$mode"'//' | tr -d "0-9")" ]; then
						echo "$mode": requires an integer number as a value
						return 1
					fi
					opt_p_val=$(echo $1 | sed 's/^'"$mode"'//')
				fi
			;;
			* )
				if [ ! "$(echo $1 | sed 's/^-//')" ]; then
					echo "$1": invalid argument
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
					if [ ! "$(echo $1 | sed 's/^-//' | tr -d "0-9")" ]; then
						if [ "$opt_p" -gt 0 ]; then
							if [ "$mode" ]; then
								echo "$mode": same operation not permitted
							else
								echo "-p": same operation not permitted
							fi
							return 1
						fi
						opt_p=$(($opt_p+1))
						opt_p_val=$(echo $1 | sed 's/^-//')
					else
						for i in $(echo $1 | sed 's/^-//' | sed 's/.\{1\}/& /g'); do
							if [ "$i" == x ]; then
								if [ "$opt_x" -gt 0 ]; then
									echo "-x": same operation not permitted
									return 1
								fi
								opt_x=$(($opt_x+1))
							elif [ "$i" == h ]; then
								if [ "$opt_h" -gt 0 ]; then
									echo "-h": same operation not permitted
									return 1
								fi
								opt_h=$(($opt_h+1))
							else
								echo "$1": invalid argument
								return 1
							fi
						done
					fi
				elif [ "$n" -eq 2 ]; then
					for i in $(echo $1 | sed 's/^--//'); do
						if [ "$i" == exit ]; then
							if [ "$opt_x" -gt 0 ]; then
								echo "--exit": same operation not permitted
								return 1
							fi
							opt_x=$(($opt_x+1))
						elif [ "$i" == help ]; then
							if [ "$opt_h" -gt 0 ]; then
								echo "--help": same operation not permitted
								return 1
							fi
							opt_h=$(($opt_h+1))
						else
							echo "$1": invalid argument
							return 1
						fi
					done
				else
					echo "$1": invalid argument
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
	cat <<EOF
Usage: $(basename $0) -hx -p [VALUE]
	-p turns on options to set priority manually. defaulted to 19.
	-x ends the process already running in background.
	-h views this message.
	--priority does the same thing as -p.
	--exit does the same thing as -x.
	--help does the same thing as -h.
EOF
}

## Aaand, you're good to go!

# Main script
Roll_Down
Magic_Parser $@
Roll_Up

# End session.
exit $?
