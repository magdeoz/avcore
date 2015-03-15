# boostdemo.sh
#
# Copyright (C) 2013-2014  hoholee12@naver.com
#
# Everyone is permitted to copy and distribute verbatim copies
# of this code, but changing it is not allowed.
#
zygote=$(pgrep zygote)
renice 19 $zygote
for i in $(pgrep "")



renice 19 $$
busybox ionice -c2 -n7 -p$$
divide_ram=3
while true; do
if [ $(($(grep -i '^MemFree:' /proc/meminfo | grep -o '[0-9]*')+$(grep -i '^Cached:' /proc/meminfo | grep -o '[0-9]*'))) -le $(($(grep -i '^MemTotal:' /proc/meminfo | grep -o '[0-9]*')/$divide_ram)) ]; then
least=0
pid=0
for i in $(pgrep ""); do
if [ $least == 0 ] || [ $pid == 0 ]; then
least=$(cat /proc/$i/oom_score)
pid=$i
else
if [ $least -lt $(cat /proc/$i/oom_score) ]; then
least=$(cat /proc/$i/oom_score)
pid=$i
fi
fi
done
kill -9 $pid
fi
sleep 1
done 2>/dev/null






renice -n19 -p$$
ionice -c2 -n7 -p$$
while true; do
if [ $(pgrep zygote) ]; then
if [ -e /proc/$(pgrep zygote)/oom_score_adj ];then
adjscore=1000
adj=$(echo "\$(cat /proc/\$i/oom_score_adj)")
else
adjscore=15
adj=$(echo "\$(cat /proc/\$i/oom_adj)")
fi
fifth=0
for i in $(pgrep ""); do
if [ "$(grep -i "^PPid:" /proc/$i/status | grep -o '[0-9]*')" == "$(pgrep zygote)" ]; then
fifth_adj=$(eval echo $adj)
if [ "$fifth_adj" -gt "$fifth" ] && [ "$fifth_adj" -lt "$adjscore" ]; then
fifth=$fifth_adj
fi
fi
done
fourth=0
for i in $(pgrep ""); do
if [ "$(grep -i "^PPid:" /proc/$i/status | grep -o '[0-9]*')" == "$(pgrep zygote)" ]; then
fourth_adj=$(eval echo $adj)
if [ "$fourth_adj" -gt "$fourth" ] && [ "$fourth_adj" -lt "$fifth" ]; then
fourth=$fourth_adj
fi
fi
done
third=0
for i in $(pgrep ""); do
if [ "$(grep -i "^PPid:" /proc/$i/status | grep -o '[0-9]*')" == "$(pgrep zygote)" ]; then
third_adj=$(eval echo $adj)
if [ "$third_adj" -gt "$third" ] && [ "$third_adj" -lt "$fourth" ]; then
third=$third_adj
fi
fi
done
second=0
for i in $(pgrep ""); do
if [ "$(grep -i "^PPid:" /proc/$i/status | grep -o '[0-9]*')" == "$(pgrep zygote)" ]; then
second_adj=$(eval echo $adj)
if [ "$second_adj" -gt "$second" ] && [ "$second_adj" -lt "$third" ]; then
second=$second_adj
fi
fi
done
first=0
for i in $(pgrep ""); do
if [ "$(grep -i "^PPid:" /proc/$i/status | grep -o '[0-9]*')" == "$(pgrep zygote)" ]; then
first_adj=$(eval echo $adj)
if [ "$first_adj" -gt "$first" ] && [ "$first_adj" -lt "$second" ]; then
first=$first_adj
fi
fi
done
adj_result=$(echo "$first,$second,$third,$fourth,$fifth,$adjscore")
if [ "$adj_result" != "$(cat /sys/module/lowmemorykiller/parameters/adj)" ]; then
echo $adj_result > /sys/module/lowmemorykiller/parameters/adj
fi
minfree=$(($(grep -i '^MemTotal:' /proc/meminfo | grep -o '[0-9]*')/32))
minfree_result=$(echo "$minfree,$minfree,$minfree,$minfree,$minfree,$minfree")
if [ "$minfree_result" != "$(cat /sys/module/lowmemorykiller/parameters/minfree)" ]; then
echo "$minfree_result" > /sys/module/lowmemorykiller/parameters/minfree
fi
fi
sleep 5
done


oom_adj -> oom_score_adj 내림

oom_score_adj = (oom_adj * 1000) / 15
oom_adj = (oom_score_adj * 15) / 1000

oom_score_adj -> oom_adj 반올림

HIDDEN_APP_MAX_ADJ = 1000

HIDDEN_APP_MIN_ADJ = 529

BACKUP_APP_ADJ = 235

PERCEPTIBLE_APP_ADJ = 117  // ex) background music playback

VISIBLE_APP_ADJ = 58

FOREGROUND_APP_ADJ = 0

d.process.acore -12
ndroid.systemui -12
ndroid.contacts -12
d.process.media -12


-16 -12 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
0    1  2 3 4 5 6 7 0 1 2 3 4   5  6  7  3  3


zygote (launcher) highest
rest normal(0)




page cache = disk cache that is already written to disk, and can be removed from system memory.
dirty data = disk cache that is not yet written to disk.
dentry = directory cache
inode = index cache

RECIPE
-dirty=Memtotal or 0
-dirty_background=(Memfree+Cached)-Mapped or read_ahead_kb
-flush everything once triggered.
-no periodic pdflush.


dirty data = buffer + disk cache
1024kb = 768kb + 256kb

renice value
-5 to 4

#########################################################important!!!#########################################################

# AMS grouping manager
launchseq(){
	while true; do
		for launcher in $(grep "<h\>" /data/system/appwidgets.xml | tr " " "\n" | grep pkg | sed 's/^pkg="//; s/"$//'); do
			launcher_pid=$(pgrep $launcher)
			if [ "$launcher_pid" ]; then
				break
			fi
		done
		if [ "$launcher_pid" ]; then
			break
		fi
		sleep 1
	done
	launcher_adj=$(cat /proc/$launcher_pid/oom_adj)
	heapalloc=$(($(getprop | grep dalvik.vm.heapsize | sed 's/\[dalvik.vm.heapsize]: \[//; s/m]//')*1024))
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

#chklnk
if [ ! $1 ]; then
return 1
fi
file=$1
dir=$(dirname $file)
base=$(basename $file)
if [ ! -e $file ] && [ ! -d $file ]; then
echo "$file: not found"
return 1
fi
count=0
for i in $(ls -l $dir | grep $base | head -1); do
count=$((count+1))
if [ $i == "->" ]; then
found=y
break
fi
done
if [ ! $found ] || [ $file == "/" ]; then
echo "$file: is not a symlink"
return 1
fi
#link=$((count-1))
orig=$((count+1))
linked_file=$(ls -l $dir | grep $base | head -1 | awk '{print $'"$orig"'}')
echo "$linked_file"


#2014 new project

#identifier
for i in $(find /proc/[0-9]*/task -maxdepth 1 | grep 'task/'); do
	echo -n 'comm: '
	cat $i/comm
	echo -n 'wchan: '
	cat $i/wchan
	echo
	chrt -p $(basename $i)
	echo
done

#prototype
renice 19 $$
while true; do
	for i in $(find /proc/[0-9]*/task -maxdepth 1 | grep 'task/'); do
		if [ $(grep sys_rt_sigtimedwait $i/wchan) 2>/dev/null ]; then
			chrt -f -p 99 $(basename $i)
		fi
		if [ $(grep sys_epoll_wait $i/wchan) 2>/dev/null ]; then
			chrt -r -p 1 $(basename $i)
		fi
	done
	sleep 10
done

let "z=5**3" #makes z equal 125.

local i adj mode score tested final n
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

#saved process IDs
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




-Combined dalvik/vm/Thread.c and -frameworks/base/include/utils/threads.h
Thread.priority ,   Java name    , Android property name              , Unix priority
1                  MIN_PRIORITY   ANDROID_PRIORITY_LOWEST,               19
2                                 ANDROID_PRIORITY_BACKGROUND + 6        16
3                                 ANDROID_PRIORITY_BACKGROUND + 3        13
4                                 ANDROID_PRIORITY_BACKGROUND            10
5                  NORM_PRIORITY  ANDROID_PRIORITY_NORMAL                 0
6                                 ANDROID_PRIORITY_NORMAL - 2            -2
7                                 ANDROID_PRIORITY_NORMAL - 4            -4
8                                 ANDROID_PRIORITY_URGENT_DISPLAY + 3    -5
9                                 ANDROID_PRIORITY_URGENT_DISPLAY + 2    -6
10                 MAX_PRIORITY   ANDROID_PRIORITY_URGENT_DISPLAY        -8

frameworks/base/include/utils/threads.h
    ANDROID_PRIORITY_LOWEST         =  19,

    /* use for background tasks */
    ANDROID_PRIORITY_BACKGROUND     =  10,

    /* most threads run at normal priority */
    ANDROID_PRIORITY_NORMAL         =   0,

    /* threads currently running a UI that the user is interacting with */
    ANDROID_PRIORITY_FOREGROUND     =  -2,

    /* the main UI thread has a slightly more favorable priority */
    ANDROID_PRIORITY_DISPLAY        =  -4,
    /* ui service treads might want to run at a urgent display (uncommon) */
    ANDROID_PRIORITY_URGENT_DISPLAY =  -8,

    /* all normal audio threads */
    ANDROID_PRIORITY_AUDIO          = -16,

    /* service audio threads (uncommon) */
    ANDROID_PRIORITY_URGENT_AUDIO   = -19,

    /* should never be used in practice. regular process might not
     * be allowed to use this level */
    ANDROID_PRIORITY_HIGHEST        = -20,

    ANDROID_PRIORITY_DEFAULT        = ANDROID_PRIORITY_NORMAL,
    ANDROID_PRIORITY_MORE_FAVORABLE = -1,
    ANDROID_PRIORITY_LESS_FAVORABLE = +1,
	
	
	
	
	#!/bin/bash
# ==============================================================
# CPU limit daemon - set PID's max. percentage CPU consumptions
# ==============================================================

# Variables
CPU_LIMIT=20       	# Maximum percentage CPU consumption by each PID
DAEMON_INTERVAL=3  	# Daemon check interval in seconds
BLACK_PROCESSES_LIST=   # Limit only processes defined in this variable. If variable is empty (default) all violating processes are limited.
WHITE_PROCESSES_LIST=   # Limit all processes except processes defined in this variable. If variable is empty (default) all violating processes are limited.

# Check if one of the variables BLACK_PROCESSES_LIST or WHITE_PROCESSES_LIST is defined.
if [[ -n "$BLACK_PROCESSES_LIST" &&  -n "$WHITE_PROCESSES_LIST" ]] ; then    # If both variables are defined then error is produced.
   echo "At least one or both of the variables BLACK_PROCESSES_LIST or WHITE_PROCESSES_LIST must be empty."
   exit 1
elif [[ -n "$BLACK_PROCESSES_LIST" ]] ; then                                 # If this variable is non-empty then set NEW_PIDS_COMMAND variable to bellow command
   NEW_PIDS_COMMAND="top -b -n1 -c | grep -E '$BLACK_PROCESSES_LIST' | gawk '\$9>CPU_LIMIT {print \$1}' CPU_LIMIT=$CPU_LIMIT"
elif [[ -n "$WHITE_PROCESSES_LIST" ]] ; then                                 # If this variable is non-empty then set NEW_PIDS_COMMAND variable to bellow command
   NEW_PIDS_COMMAND="top -b -n1 -c | gawk 'NR>6' | grep -E -v '$WHITE_PROCESSES_LIST' | gawk '\$9>CPU_LIMIT {print \$1}' CPU_LIMIT=$CPU_LIMIT"
else
   NEW_PIDS_COMMAND="top -b -n1 -c | gawk 'NR>6 && \$9>CPU_LIMIT {print \$1}' CPU_LIMIT=$CPU_LIMIT"
fi

# Search and limit violating PIDs
while sleep $DAEMON_INTERVAL
do
   NEW_PIDS=$(eval "$NEW_PIDS_COMMAND")                                                                    # Violating PIDs
   LIMITED_PIDS=$(ps -eo args | gawk '$1=="cpulimit" {print $3}')                                          # Already limited PIDs
   QUEUE_PIDS=$(comm -23 <(echo "$NEW_PIDS" | sort -u) <(echo "$LIMITED_PIDS" | sort -u) | grep -v '^$')   # PIDs in queue

   for i in $QUEUE_PIDS
   do
       cpulimit -p $i -l $CPU_LIMIT -z &   # Limit new violating processes
   done
done





#!/bin/bash
#
# Process control
#
# This shell-script watch that <process> doesn't pass the <limit> of % cpu usage
# If it does, the script kills that process and finish
#
# For linux kernel 2.6.x
# v.0.1 sept-2007
#
# Author: Miguel Ángel Molina Molina
# Licence: GPL v.2

# Parameter check
# [debug] parameter is optional and can be anything. If it exists, the script produces output to the screen for debugging purposes.
if [ $# -lt 2 -o $# -gt 3 ];
then
  echo "Usage: `basename $0` <process> <limit> [debug]"
  exit -1
fi

# [debug] exists?
if [ $# -eq 3 ];
then
  debug="yes"
else
  debug=""
fi

procpid=`pidof $1`
typeset -i limit=$2

# process existence check
if [ -z "$procpid" ];
then
  echo "Process: $1 doesn't exists"
  exit -1
fi

# limit check
if [ $limit -lt 1 -o $limit -gt 99 ];
then
  echo "Limit must be between 1 and 99"
  exit -1
fi

typeset -i hits=0

while [ 1 ]
do
  # Get usage cpu time
  typeset -i cputime=`cat /proc/uptime | cut -f1 -d " " | sed 's/\.//'`
  # process pid check
  if [ ! -f /proc/${procpid}/stat ];
  then
    echo "Process doesn't exists: ${procpid}"
    exit -1
  fi
  # Get process usage cpu time
  typeset -i proctime=`cat /proc/${procpid}/stat | awk '{t = $14 + $15;print t}'`
  # wait 5 seconds
  sleep 5
  # get usage cpu time, again
  typeset -i cputime2=`cat /proc/uptime | cut -f1 -d " " | sed 's/\.//'`
  # get process usage cpu time, again
  typeset -i proctime2=`cat /proc/${procpid}/stat | awk '{t = $14 + $15;print t}'`
  # calculate process usage cpu time over total usage cpu time as percentage
  typeset -i cpu=$((($proctime2-$proctime)*100/($cputime2-$cputime)))
  [ ! -z $debug ] && echo "Process $1, with pid: $procpid, is wasting: $cpu% of cpu"
  # limit exceed check
  if [ $cpu -gt $limit ];
  then
    # Count the excess
    let hits+=1
    if [ $hits = 1 ];
    then
      times="time"
    else
      times="times"
    fi
    [ ! -z $debug ] && echo "Process $1 has exceeded the limit: $limit ($cpu) $hits $times ..."
    # If hits are greater than 10, kill the process
    if [ $hits -gt 10 ];
    then
      echo -n "Killing process: $procpid ... "
      kill $procpid
      # wait until process die
      sleep 1
      # check if process has died
      if [ -z "`pidof $1`" ];
      then
        echo "Done."
      else
        echo "Can't kill the process."
      fi
      echo "Finished."
      exit 0
    fi
  else
   # if no limit exceed, reset hit counter
   let hits=0
  fi
done




#!/usr/bin/env bash

# calculate the cpu usage of a single process
# jvehent oct.2013

[ -z $1 ] && echo "usage: $0 <pid>"

sfile=/proc/$1/stat
if [ ! -r $sfile ]; then echo "pid $1 not found in /proc" ; exit 1; fi

proctime=$(cat $sfile|awk '{print $14}')
totaltime=$(grep '^cpu ' /proc/stat |awk '{sum=$2+$3+$4+$5+$6+$7+$8+$9+$10; print sum}')

echo "time                        ratio      cpu%"

while [ 1 ]; do
    sleep 1
    prevproctime=$proctime
    prevtotaltime=$totaltime
    proctime=$(cat $sfile|awk '{print $14}')
    totaltime=$(grep '^cpu ' /proc/stat |awk '{sum=$2+$3+$4+$5+$6+$7+$8+$9+$10; print sum}')
    ratio=$(echo "scale=2;($proctime - $prevproctime) / ($totaltime - $prevtotaltime)"|bc -l)
    echo "$(date --rfc-3339=seconds);  $ratio;      $(echo "$ratio*100"|bc -l)"
done



prev_total=0
prev_idle=0
while true; do
cpu=`cat /proc/stat | head -n1 | sed 's/cpu  //'`
user=`echo $cpu | awk '{print $1}'`
system=`echo $cpu | awk '{print $2}'`
nice=`echo $cpu | awk '{print $3}'`
idle=`echo $cpu | awk '{print $4}'`
wait=`echo $cpu | awk '{print $5}'`
irq=`echo $cpu | awk '{print $6}'`
srq=`echo $cpu | awk '{print $7}'`
zero=`echo $cpu | awk '{print $8}'`
total=$(($user+$system+$nice+$idle+$wait+$irq+$srq+$zero))
diff_idle=$(($idle-$prev_idle))
diff_total=$(($total-$prev_total))
usage=$(($((1000*$(($diff_total-$diff_idle))/$diff_total+5))/10))
 FREEMEM=`free | awk '{ print $4 }' | sed -n 2p`
CACHESIZE=`cat /proc/meminfo | grep Cached | awk '{print $2}' | sed -n 1p`
TOTALMEM=`free | awk '{ print $2 }' | sed -n 2p`
MEMINUSE=$(($TOTALMEM-$CACHESIZE-$FREEMEM))
usemb=$(($MEMINUSE/1024))
totalmb=$(($TOTALMEM/1024)) 
clear
echo "CPU usage: $usage%"
echo "RAM usage: $usemb/$totalmb MB"
 prev_total=$total
prev_idle=$idle 
sleep 1
done 


###test

process=launch
suddencharge=900
sleep=1
nice=19

function task(){
stat=$(cat /proc/$1/task/$2/stat)
rm=${stat#*)}
last_prio=$(echo $rm | cut -d' ' -f17)
proctime=$(echo $rm | cut -d' ' -f12)
while true
do
	prev_proctime=$proctime
	stat=$(cat /proc/$1/task/$2/stat)
	rm=${stat#*)}
	proctime=$(echo $rm | cut -d' ' -f12)
	buffer=$(echo $proctime $prev_proctime $4 | awk '{printf "%d\n", ($1-$2)/$3}')
	if [[ "$buffer" -gt "$3" ]]; then
		renice $5 $2
	else
		renice $last_prio $2
	fi
	sleep $4
done
}

function fork(){
until [[ "$(pgrep $1)" ]]; do sleep 1; done
pid=$(pgrep $1)
if [[ "$(ls /proc/$pid/task)" ]]; then
	for i in $(ls /proc/$pid/task)
	do
		task $pid $i $2 $3 $4 &
	done
fi 2>/dev/null
}

fork $process $suddencharge $sleep $nice


#process manager
limit=50
niceness=1
secs=1

renice 19 $$
while [[ "$(cat /sys/power/wait_for_fb_wake)" ]]; do
	IFS='\n'
	i=$(busybox top -n1 | grep 'app\.\|org\.\|com\.' | sed 's/N\|<//g' | awk '{print $1,$8}' | cut -d'.' -f1)
	j=$(echo $i | wc -l)
	unset IFS
	for loop in $(seq 1 $j); do
		IFS='\n'
		a=$(echo $i | head -n$loop | tail -n1)
		if [[ "$(echo $a | awk '{print $2}')" -gt "$limit" ]]; then
			renice $niceness $(echo $a | awk '{print $1}')
		fi
	done & sleep $secs
done

#mediaserver boost
renice 19 $$
while true; do
	a=$(busybox top -n1 | grep mediaserver | sed 's/N\|<//g' | awk '{print $8}' | cut -d'.' -f1 & sleep 1)
	kill -9 $pid 2>/dev/null
	if [[ "$a" -gt 1 ]]; then
		while true; do
			true
		done & pid=$!
	fi
done


