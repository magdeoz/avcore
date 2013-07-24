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
