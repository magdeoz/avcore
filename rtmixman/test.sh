
#Copyright (C) 2013  LENAROX@xda
#
#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.
#
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with this program.  If not, see <http://www.gnu.org/licenses/>.

set +e
#set -x

#start with cmd1.
cmd1=renice
cmd=1 #indicates only one cmd available for checking.

error=0
#start busybox applet generator 2.0
if [ ! "$(busybox --list)" ]; then
echo "busybox: not found, damnit."
error=$(($error+1))
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
for i in $(seq -s ' $slot' 0 $n); do
v=$(eval echo $i)
if [ "$v" != 0 ] && [ "$v" != "$busyboxloc" ]; then
echo -n ":$v"
fi
done)
fi
#it'll work if your busybox isn't that much of a crap and all.
if [ "$cmd" -lt 0 ]; then
cmd=0
fi
for i in $(seq -s ' $cmd' 0 $cmd); do
v=$(eval echo $i)
if [ "$v" != 0 ] && [ "$v" ]; then
if [ ! "$(busybox --list | grep $v)" ]; then
echo "required applets are not found, or missing!"
error=$(($error+1))
fi
n=0
if [ -e "$busyboxloc"/"$v" ]; then
n=$(($n+1))
fi
if [ "$n" -eq 0 ]; then
alias $i="busybox $i"
fi
fi
done
fi 2>/dev/null

custom_penable=0
custom_pvalue=0




usage()
{
for i in $(echo $0 | sed 's/\// /g'); do
done
echo "Usage: $i [OPTION] [VALUE]"
echo "		-p turns on options to set priority manually. defaulted to 19."
echo "		-e ends the process already running in background."
echo "		-h views this message."
echo "		--priority does the same thing as -p."
echo "		--exit does the same thing as -e"
echo "		--help does the same thing as -h."
}

while [ "$1" ]; do
case $1 in
-p | --priority )
custom_penable=$(($custom_penable+1))
if [ "$2" ]; then
custom_pvalue=$2
shift
else
echo "$1": no values have been entered.
usage
error=$(($error+1))
break
fi
;;
-e | --exit )


;;
-h | --help )
usage
return 0
;;
* )
echo "$1": invalid argument
usage
error=$(($error+1))
break
;;
esac
shift
done

if [ "$error" -gt 0 ]; then
return 1
else
return 0
fi

