# chklnk.sh
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
# 0.0.2 - permission error support added.
#       - revamped return command.
set +e
# Busybox Applet Generator 2.3
# You can type in any commands you would want it to check.
# It will start by checking from cmd1, and its limit is up to cmd224.
cmd1=dirname
cmd2=basename
cmd3=ls
cmd4=grep
cmd5=head
cmd6=awk
cmd=6 # It notifies the generator how many cmds are available for check. Leave it as blank.
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
Busybox_Applet_Generator
return=$?
if [ "$return" != 0 ]; then
	exit $return
fi

# Main script
if [ ! "$1" ]; then
	exit 1
fi
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
exit 0

