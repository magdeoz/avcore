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

oom_score_adj = (oom_adj * 1000) / 17
oom_adj = (oom_score_adj * 17) / 1000

oom_score_adj -> oom_adj 반올림



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
	for launcher in $(grep "<h\>" /data/system/appwidgets.xml | tr " " "\n" | grep pkg | sed 's/^pkg="//; s/"$//'); do
		launcher_pid=$(pgrep $launcher)
		if [ "$launcher_pid" ]; then
			break
		fi
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
if [ ! $found ]; then
echo "$file: is not a symlinked file"
return 1
fi
#link=$((count-1))
orig=$((count+1))
linked_file=$(ls -l $dir | grep $base | head -1 | awk '{print $'"$orig"'}')
echo "$linked_file"



