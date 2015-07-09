#!/system/bin/sh
#RTMixManager™ version 20130318 packages installer.
#developed by LENAROX.
#
#this engine will solve any lags and crashes on games, heavy apps and so on.
#which most of the mid-range android gamers have always wanted;)
#rock your RAM Manager like a Windows NT!!!(da well known BOSS of RAM Management), you know what i mean.:p
#ATTENTION!!! this engine requires the latest busybox version FROM stericson, installed to run properly.
#reminder: this engine is designed to run in the background realtime(yeah, RT lol:p) with the android ram management,
#therefore it should NOT be used with other script applications.
#
#thanks to many xda devs who have helped me to develop better codes!
#thanks to chainfire for touchscreen responsiveness tweak.
#thanks to shantam for Netweaks.
#thanks to professionals from stackoverflow.com who gave me some good advices!
#thanks to mv style for lupus kernel script.
#thanks to zeppelinrox for the script design, and the bugfix!
#thanks to hardcore for the remount tweak.
#
#do not steal this script installer or the script that is being installed by this installer.
#you must always ask me for any permission thats related to this script,
#and give a credit by linking to this thread: http://forum.xda-developers.com/showthread.php?t=2076101

install()
{
while true;
	do
		echo "mounting required directories to install...";
		echo "";
		sync; busybox mount -o remount,rw /;
		sync; busybox mount -o remount,rw /system;
		if [ -d "/sqlite_stmt_journals" ];
			then
				sleep 0;
		else
			mkdir /sqlite_stmt_journals;
		fi;
		if [ -d "/system/etc/init.d" ];
			then
				sleep 0;
		else
			mkdir /system/etc/init.d;
		fi;
		echo "done!";
		echo "";
		sleep 2;
		echo "where would you like to install? init.d(i), or xbin(x), or cancel(c):";
		read i
		case $i in
			i|I)
			echo "setting up init.d...";
			RTLOCATION=/system/etc/init.d/SS99RTMixManager;
			break;
			;;
			x|X)
			echo "setting up xbin...";
			sleep 2;
			echo "type rtmixman in terminal emulator whenever you wish to run the engine!";
			RTLOCATION=/system/xbin/rtmixman;
			break;
			;;
			c|C)
			echo "okay..o_O;;";
			sleep 2;
			main
			;;
			*)
			echo "";
			echo "user typed an invalid option, please try again.";
			sleep 2;
			;;
		esac
	done
sleep 2;
#clean all interruptable leftovers from last update.
echo "cleaning temporary backup...";
sleep 5;
rm /mnt/sdcard/rtmixtemp.sh 2>/dev/null;
rm /mnt/sdcard/rtmixtemp2.sh 2>/dev/null;
rm /mnt/sdcard/rtmixtemp3.sh 2>/dev/null;
rm /mnt/sdcard/rtmixtemp4.sh 2>/dev/null;
rm /mnt/sdcard/rtmixtemp5.sh 2>/dev/null;
echo "";
echo "RTMixManager™ version 20130318 packages installer.";
echo "developed by LENAROX.";
echo "reminder: be careful its still beta. my first complex script ever!";
echo "";
sleep 2;
echo "now, you will be given a series of questions, its a part of procedure, for installation!:)";
sleep 5;
clear;
sleep 2;
echo "STEP 1:";
echo "";
sleep 2;
echo "=====other scripts==============================";
sleep 2;
while true;
	do
		echo "would you like to install Netweaks script by shantam? Y or N.";
		read i
		case $i in
			y|Y)
			echo "installing...";
			sleep 5;
cat >> /mnt/sdcard/rtmixtemp4.sh <<EOF
#!/system/bin/sh

echo "0" > /proc/sys/net/ipv4/conf/all/accept_redirects;
echo "0" > /proc/sys/net/ipv4/conf/all/secure_redirects;
echo "0" > /proc/sys/net/ipv4/conf/all/accept_source_route;
echo "1" > /proc/sys/net/ipv4/conf/all/rp_filter;
echo "0" > /proc/sys/net/ipv4/conf/default/accept_redirects;
echo "0" > /proc/sys/net/ipv4/conf/default/secure_redirects;
echo "0" > /proc/sys/net/ipv4/conf/default/accept_source_route;
echo "1" > /proc/sys/net/ipv4/conf/default/rp_filter;
echo "1" > /proc/sys/net/ipv4/tcp_fack;
echo "cubic" > /proc/sys/net/ipv4/tcp_congestion_control ;
echo "1" > /proc/sys/net/ipv4/tcp_syncookies;
echo "2" > /proc/sys/net/ipv4/ipv4.tcp_synack_retries;
echo "2" > /proc/sys/net/ipv4/tcp_syn_retries;
echo "1024" > /proc/sys/net/ipv4/tcp_max_syn_backlog;
echo "16384" > /proc/sys/net/ipv4/tcp_max_tw_buckets;
echo "1" > /proc/sys/net/ipv4/icmp_echo_ignore_all;
echo "1" > /proc/sys/net/ipv4/icmp_ignore_bogus_error_responses;
echo "1" > /proc/sys/net/ipv4/tcp_no_metrics_save;
echo "1800" > /proc/sys/net/ipv4/tcp_keepalive_time;
echo "0" > /proc/sys/net/ipv4/ip_forward;
echo "0" > /proc/sys/net/ipv4/tcp_timestamps;
echo "1" > /proc/sys/net/ipv4/tcp_tw_reuse;
echo "1" > /proc/sys/net/ipv4/tcp_sack;
echo "1" > /proc/sys/net/ipv4/tcp_tw_recycle;
echo "1" > /proc/sys/net/ipv4/tcp_window_scaling;
echo "5" > /proc/sys/net/ipv4/tcp_keepalive_probes;
echo "30" > /proc/sys/net/ipv4/tcp_keepalive_intvl;
echo "15" > /proc/sys/net/ipv4/tcp_fin_timeout;
echo "1" > /proc/sys/net/ipv4/tcp_rfc1337; 
echo "1" > /proc/sys/net/ipv4/tcp_workaround_signed_windows;
echo "1" > /proc/sys/net/ipv4/tcp_low_latency;
echo "0" > /proc/sys/net/ipv4/ip_no_pmtu_disc;
echo "1" > /proc/sys/net/ipv4/tcp_mtu_probing;
echo "2" > /proc/sys/net/ipv4/tcp_frto;
echo "2" > /proc/sys/net/ipv4/tcp_frto_response;
echo "404480" > /proc/sys/net/core/wmem_max;
echo "404480" > /proc/sys/net/core/rmem_max;
echo "256960" > /proc/sys/net/core/rmem_default;
echo "256960" > /proc/sys/net/core/wmem_default;
echo "4096,16384,404480" > /proc/sys/net/ipv4/tcp_wmem;
echo "4096,87380,404480" > /proc/sys/net/ipv4/tcp_rmem; 

EOF
			cp /mnt/sdcard/rtmixtemp4.sh /system/etc/init.d/SS97Netweaks
			chown 0.0 /system/etc/init.d/SS97Netweaks
			chmod 777 /system/etc/init.d/SS97Netweaks
			echo "";
			echo "done!";
			sleep 2;
			break;
			;;
			n|N)
			echo "skipped."
			sleep 2;
			break;
			;;
			*)
			echo "";
			echo "user typed an invalid option, please try again.";
			sleep 2;
			;;
		esac
	done
echo "next,"
sleep 2;
while true;
	do
		echo "would you like to install responsive tounchscreen script by chainfire? Y or N.";
		read i
		case $i in
			y|Y)
			echo "installing...";
			sleep 5;
cat >> /mnt/sdcard/rtmixtemp5.sh <<EOF
#!/system/bin/sh
#Touchscreen
#Configure touchscreen sensitivity
#Sensitive(Chainfire)

echo 7035 > /sys/class/touch/switch/set_touchscreen;
echo 8002 > /sys/class/touch/switch/set_touchscreen;
echo 11000 > /sys/class/touch/switch/set_touchscreen;
echo 13060 > /sys/class/touch/switch/set_touchscreen;
echo 14005 > /sys/class/touch/switch/set_touchscreen;
EOF
			cp /mnt/sdcard/rtmixtemp5.sh /system/etc/init.d/SS98enable_touchscreen
			chown 0.0 /system/etc/init.d/SS98enable_touchscreen
			chmod 777 /system/etc/init.d/SS98enable_touchscreen
			echo "";
			echo "done!";
			sleep 2;
			break;
			;;
			n|N)
			echo "skipped.";
			sleep 2;
			break;
			;;
			*)
			echo "";
			echo "user typed an invalid option, please try again.";
			sleep 2;
			;;
		esac
	done
sleep 2;
echo "step 1 complete.";
sleep 5;
clear;
sleep 2;
echo "STEP 2:";
sleep 2;
echo "";
echo "======my script, my rules=======================";
sleep 2;
echo "now, this is the real thing you've been waiting here.";
sleep 2;
echo "";
echo "calm down your mind, and read carefully while proceeding!!!";
sleep 2;
echo "";
echo "if you're ready, lets start!":
sleep 2;
echo "";
echo "";
echo "-Rapid Storage Boost(RSB)™ Technology";
sleep 2;
echo "";
echo "this enables wide I/O to make every single processes get faster access to flash drives(mmc).";
sleep 2;
echo "because this techniquely disables sync between processes and an I/O(for purpose),";
sleep 2;
echo "loading applications may take some time.(maybe you can use an upcomming addon to solve it.)";
sleep 2;
echo "this technology fixes lots of games such as sound stutter loops, loading hang, and so on. definitely recommended for gamers.";
echo "NOTE: this engine creates a usrsettings file on /etc/init.d directory.";
sleep 2;
echo "";
while true;
	do
		echo "would you like to apply?, Y or N.";
		read i
		case $i in
			y|Y)
			sleep 2;
			rsb=1
			echo "okay, enabled!";
			break;
			;;
			n|N)
			sleep 2;
			rsb=0
			echo "oh, why?:(";
			break;
			;;
			*)
			echo "";
			echo "user typed an invalid option, please try again.";
			sleep 2;
			;;
		esac
	done
sleep 2;
if [ $rsb == 1 ];
	then
		echo "-RSB™ Technology Addon";
		sleep 2;
		echo "";
		echo "this sets a balanced writeback value. great for battery, but not yet confirmed for performance.";
		sleep 2;
		echo "";
		while true;
			do
				echo "would you like to apply?, Y or N.";
				read i
				case $i in
					y|Y)
					sleep 2;
					rsbadd=1
					echo "okay, enabled!";
					break;
					;;
					n|N)
					sleep 2;
					rsbadd=0
					echo "okay. it seems you don't want more battery life, eh?";
					break;
					;;
					*)
					echo "";
					echo "user typed an invalid option, please try again.";
					sleep 2;
					;;
				esac
			done
		echo "";
else
	sleep 0;
fi;
sleep 2;
echo "-RTMixManager™ Engine";
sleep 2;
echo "";
echo "features lowmem Mix-up Enhancement(NDPA) calculation.=> Multitasking and Performance both enhanced.";
sleep 2;
echo "a main feature of rtmixmanager: it controls android memory manager directly.";
echo "NOTE: this engine creates a usrsettings file on /etc/init.d directory.";
sleep 2;
echo "";
while true;
	do
		echo "would you like to apply?, Y or N.";
		read i
		case $i in
			y|Y)
			sleep 2;
			rtmix=1
			echo "okay, enabled!";
			break;
			;;
			n|N)
			sleep 2;
			rtmix=0
			echo "why? do you use other scripts? is that why you're not gonna use this god engine?";
			break;
			;;
			*)
			echo "";
			echo "user typed an invalid option, please try again.";
			sleep 2;
			;;
		esac
	done
echo "";
sleep 2;
echo "-Shadow compiler™";
sleep 2;
echo "";
echo "transforms Android's Dalvik VM Compiler to give you the feeling of using a real PC! ie. Windows(R) NT. another ie. Native compiler!!!";
sleep 2;
echo "another main feature of rtmixmanager. co-operates with RSB™ Technology.";
sleep 2;
echo "it optimizes all processes that they dont get to interrupt themselves with GC. PERMANENTLY disables lags in both UI and sound system.";
sleep 2;
echo "caution: this may give various FCs on apps for some ROMs.";
sleep 2;
echo "";
while true;
	do
		echo "would you like to apply?, Y or N.";
		read i
		case $i in
			y|Y)
			sleep 2;
			sdvm=1
			echo "okay, enabled!";
			break;
			;;
			n|N)
			sleep 2;
			sdvm=0
			echo "seems plausible that you would want to disable this.";
			break;
			;;
			*)
			echo "";
			echo "user typed an invalid option, please try again.";
			sleep 2;
			;;
		esac
	done
echo "";
sleep 2;
echo "-MPEngine™ integrated";
sleep 2;
echo "";
echo "Finally, at last but not least, MPEngine™9!=> frees up ram right away when the game reaches cachelimit pressure,";
echo "to avoid Not Enough Free Space lags.";
sleep 2;
echo "this is also a main feature of rtmixmanager. co-operates with RTMixManager™ Engine.(usrsettings)";
sleep 2;
echo "reminder: sometimes this may give some phones fail to boot because they don't support loop scripts, use xbin instead.";
echo "NOTE: this engine creates a usrsettings file on /etc/init.d directory.";
sleep 2;
echo "";
while true;
	do
		echo "would you like to apply?, Y or N.";
		read i
		case $i in
			y|Y)
			sleep 2;
			mpe=1
			echo "okay, enabled!";
			break;
			;;
			n|N)
			sleep 2;
			mpe=0
			echo "hmm...okay:( btw, you can use xbin mode anytime if you want this feature!";
			break;
			;;
			*)
			echo "";
			echo "user typed an invalid option, please try again.";
			sleep 2;
			;;
		esac
	done
echo "all setup informations have been retrieved,"
sleep 2;
echo "and now its ready to be stored into your device!";
sleep 2;
echo "now installing RTMixManager™ version 20130318...";
sleep 7;
cat >> /mnt/sdcard/rtmixtemp.sh <<EOF
#!/system/bin/sh
#RTMixManager™ version 20130318
#developed by LENAROX
#version check.
setprop rtmixman_checkver 20130318
#this engine will solve any lags and crashes on games, heavy apps and so on.
#which most of the mid-range android gamers have always wanted;)
#rock your RAM Manager like a Windows NT!!!(da well known BOSS of RAM Management), you know what i mean.:p
#ATTENTION!!! this engine requires the latest busybox version FROM stericson, installed to run properly.
#reminder: this engine is designed to run in the background with the android ram management,
#therefore it should NOT be used with other script applications.
#thanks to many xda devs who have helped me to develop better codes.
#this engine is based on 512mb RAM as a base and will begin to change values realtime(yeah, RT).
#you can modify values with usrsettings to tune your device for your own needs.
#you can always check which games are now playable through readme.txt!

EOF
cat >> /mnt/sdcard/rtmixtemp2.sh <<EOF
usrsettings
package installed in `date`.

NOTE: Do NOT set any false values in usrsettings.

EOF
cat >> /mnt/sdcard/rtmixtemp3.sh <<EOF
readme.html<br>
package installed in `date`.<br>
<br>
RTMixManager™ version 20130318<br>
developed by LENAROX.<br>
<br>
this engine will solve any lags and crashes on games, heavy apps and so on.<br>
which most of the mid-range android gamers have always wanted;)<br>
rock your RAM Manager like a Windows NT!!!(da well known BOSS of RAM Management), you know what i mean.:p<br>
ATTENTION!!! this engine requires the latest busybox version FROM stericson, installed to run properly.<br>
reminder: this engine is designed to run in the background realtime(yeah, RT lol:p) with the android ram management,<br>
therefore it should NOT be used with other script applications.<br>
<br>
thanks to many xda devs who have helped me to develop better codes!<br>
thanks to chainfire for touchscreen responsiveness tweak.<br>
thanks to shantam for Netweaks.<br>
thanks to professionals from stackoverflow.com who gave me some good advices!<br>
thanks to mv style for lupus kernel script.<br>
thanks to zeppelinrox for the script design, and the bugfix!<br>
thanks to hardcore for the remount tweak.<br>
<br>
<b>do not steal this script installer or the script that is being installed by this installer.<br>
you must always ask me for any permission thats related to this script,
and give a credit by linking to this thread <a href="http://forum.xda-developers.com/showthread.php?t=2076101">here</a>.</b><br>
<br>
Games & Others Compatibility List>><br>
================================================<br>
increase nr_requests to make I/O have more space to load up.=> fixes Max Payne Mobile main menu hangs.<br>
disable leases to gain faster access to the filesystem.=> faster I/O.<br>
increase touchscreen detection to sync every 90 frames per second.=> smoothens UI.<br>
lowmem Mix-up Enhancement(NDPA) calculation.=> Multitasking and Performance both enhanced.<br>
(default values on usrsettings are the currently recommended settings, confirmed with Temple Run too.)<br>
transform Dalvik VM Compiler to act like Windows NT.=> the most interesting one.<br>
it optimizes all processes that they dont get to interrupt themselves with GC.<br>
Dalvik Booster.=> forces Max Payne Mobile to resist a bit longer before getting owned by GC.<br>
Also, Need For Speed Mostwanted loadscreen hangs and Max Payne Mobile stuttery sounds are gone with this one.<br>
pre-calculated vm options(hardcoded)=> helps lots of I/O interactive games which are getting into trouble with overflowing I/O,<br>
such as Grand Theft Auto III 10Year-Anniversary Edition.<br>
live entropy Equalizer.=> some says this increases I/O performance alot.<br>
Finally, at last but not least, MPEngine™9!=> frees up ram right away when the game reaches cachelimit pressure,<br>
to avoid "not enough free space" lags. also confirmed with Grand Theft Auto III 10Year-Anniversary Edition.<br>
<br>
some of these features may not be working if you havent chose them in installer.<br>
<br>
Do NOT rename or move RTMixManager™ folders and files to other directory.<br>
engine files are put in each specified folder for better use.<br>
currently active directories for RTMixManager™ are:<br>
 $RTLOCATION <br>
 /system/etc/usrsettings<br>
if you accidentally delete or corrupt a file that is listed in here, youre in a big trouble;)<br>
<br>
following list shows installed engine parts:<br>
================================================<br>
EOF
if [ $rsb == 1 ];
	then
cat >> /mnt/sdcard/rtmixtemp.sh <<EOF
#Rapid Storage Boost(RSB)™ Technology
#no delay for mmc drives.
for k in \$(busybox mount | grep relatime | cut -d " " -f3);
	do
		sync; busybox mount -o remount,noatime,nodiratime \$k;
	done
#disable leases to gain faster access to the filesystem.
if [ -e /proc/sys/fs/leases-enable ];
	then
		echo 0 > /proc/sys/fs/leases-enable;
fi;
#fix page-cluster size.
#calculator coming soon.(128kb default)
if [ -e /proc/sys/vm/page-cluster ];
	then
		echo 5 > /proc/sys/vm/page-cluster;
fi;
#kernel vm options.(half-hardcoded)
#you don't need both options as they will conflict each other for any reason.
#i'll go with dirty_writeback_centisecs as a main pdflush option.
#fixes Max Payne Mobile hangs/freezes.
#try to avoid being flushed with dirty_ratio,
#or allow to flush only a little by adding a -1 to dirty_background_ratio.
VALUE4=\`cat /system/etc/usrsettings | grep VALUE4 | awk '{print \$2}' | sed -n 1p\`;
background=\$((\$VALUE4-1));
if [ \$VALUE4 -gt 95 ];
	then
		if [ -e /proc/sys/vm/dirty_ratio ];
			then
				echo 95 > /proc/sys/vm/dirty_ratio;
		fi;
		if [ -e /proc/sys/vm/dirty_background_ratio ];
			then
				echo 94 > /proc/sys/vm/dirty_background_ratio;
		fi;
elif [ \$VALUE4 -lt 5 ];
	then
		if [ -e /proc/sys/vm/dirty_ratio ];
			then
				echo 5 > /proc/sys/vm/dirty_ratio;
		fi;
		if [ -e /proc/sys/vm/dirty_background_ratio ];
			then
				echo 4 > /proc/sys/vm/dirty_background_ratio;
		fi;
else
	if [ -e /proc/sys/vm/dirty_ratio ];
		then
			echo \$VALUE4 > /proc/sys/vm/dirty_ratio;
	fi;
	if [ -e /proc/sys/vm/dirty_background_ratio ];
		then
			echo \$background > /proc/sys/vm/dirty_background_ratio;
	fi;
fi;
#kernel default.
if [ -e /proc/sys/vm/dirty_writeback_centisecs ];
	then
		echo 500 > /proc/sys/vm/dirty_writeback_centisecs;
fi;
#do not leave any trails behind to get flushed by dirty_ratio.
if [ -e /proc/sys/vm/dirty_expire_centisecs ];
	then
		echo 0 > /proc/sys/vm/dirty_expire_centisecs;
fi;

EOF
cat >> /mnt/sdcard/rtmixtemp2.sh <<EOF
Rapid Storage Boost(RSB)™ Technology
range: limited from 5 to 95.
do NOT touch this, unless you want to use it for debugging.
VALUE4 95

EOF
cat >> /mnt/sdcard/rtmixtemp3.sh <<EOF
Rapid Storage Boost(RSB)™ Technology installed.<br>
EOF
elif [ $rsb == 0 ];
	then
cat >> /mnt/sdcard/rtmixtemp3.sh <<EOF
Rapid Storage Boost(RSB)™ Technology not installed.<br>
EOF
fi;
if [ $rsbadd == 1 ];
	then
cat >> /mnt/sdcard/rtmixtemp.sh <<EOF
#RSB™ Technology Addon
#optimized writeback time for more battery, and stable results.
if [ -e /proc/sys/vm/dirty_writeback_centisecs ];
	then
		echo 1500 > /proc/sys/vm/dirty_writeback_centisecs;
fi;

EOF
cat >> /mnt/sdcard/rtmixtemp3.sh <<EOF
RSB™ Technology Addon installed.<br>
EOF
elif [ $rsbadd == 0 ];
	then
cat >> /mnt/sdcard/rtmixtemp3.sh <<EOF
RSB™ Technology Addon not installed.<br>
EOF
else
cat >> /mnt/sdcard/rtmixtemp3.sh <<EOF
RSB™ Technology Addon not installed.<br>
EOF
fi;
if [ $rtmix == 1 ];
	then
cat >> /mnt/sdcard/rtmixtemp.sh <<EOF
#RTMixManager™ Engine
#major adj parameter groups: -16,-12,0,1,2,4,6,7,8,9,10,11.
#background app adj parameter changes to 7 or 8 by default.
VALUE6=\`cat /system/etc/usrsettings | grep VALUE6 | awk '{print \$2}' | sed -n 1p\`;
if [ \$VALUE6 == 1 ];
	then
		if [ -e /sys/module/lowmemorykiller/parameters/adj ];
			then
				echo 1,2,4,6,7,8 > /sys/module/lowmemorykiller/parameters/adj;
		fi;
elif [ \$VALUE6 == 2 ];
	then
		if [ -e /sys/module/lowmemorykiller/parameters/adj ];
			then
				echo 0,1,2,4,6,7 > /sys/module/lowmemorykiller/parameters/adj;
		fi;
elif [ \$VALUE6 == 3 ];
	then
		if [ -e /sys/module/lowmemorykiller/parameters/adj ];
			then
				echo 2,4,6,7,8,9 > /sys/module/lowmemorykiller/parameters/adj;
		fi;
else
	echo "a false value has been encountered in usrsettings.";
fi;
#retrieve current adj parameter settings.
adj1=\`awk -F , '{print $1}' /sys/module/lowmemorykiller/parameters/adj\`;
adj2=\`awk -F , '{print $2}' /sys/module/lowmemorykiller/parameters/adj\`;
adj3=\`awk -F , '{print $3}' /sys/module/lowmemorykiller/parameters/adj\`;
adj4=\`awk -F , '{print $4}' /sys/module/lowmemorykiller/parameters/adj\`;
adj5=\`awk -F , '{print $5}' /sys/module/lowmemorykiller/parameters/adj\`;
adj6=\`awk -F , '{print $6}' /sys/module/lowmemorykiller/parameters/adj\`;
TOTALMEM=\`free | awk '{ print \$2 }' | sed -n 2p\`;
#avoid all-level termination bug by adding 1 page to each level.
adp=\$((\$TOTALMEM/24));
acp=\$((\$adp+1));
cps=\$((\$acp+1));
dpsg=\$((\$cps+1));
eps=\$((\$dpsg+1));
fpsg=\$((\$eps+1));
#i call this: a straight flush.
if [ -e /sys/module/lowmemorykiller/parameters/minfree ];
	then
		echo \$adp,\$acp,\$cps,\$dpsg,\$eps,\$fpsg > /sys/module/lowmemorykiller/parameters/minfree;
fi;

EOF
cat >> /mnt/sdcard/rtmixtemp2.sh <<EOF
RTMixManager™ Engine
value 1 is balanced.
value 2 is focused on performance.
value 3 is focused on multitasking.
choose what you desire the best!
VALUE6 1

EOF
cat >> /mnt/sdcard/rtmixtemp3.sh <<EOF
RTMixManager™ Engine installed.<br>
EOF
elif [ $rtmix == 0 ];
	then
cat >> /mnt/sdcard/rtmixtemp3.sh <<EOF
RTMixManager™ Engine not installed.<br>
EOF
fi;
if [ $sdvm == 1 ];
	then
cat >> /mnt/sdcard/rtmixtemp.sh <<EOF
#Shadow compiler™
#optimize all processes to be perfect.("whoops" errors may occur)
setprop ENFORCE_PROCESS_LIMIT false
setprop dalvik.vm.dexopt-flags v=a,o=a,m=y

EOF
cat >> /mnt/sdcard/rtmixtemp3.sh <<EOF
Shadow compiler™ installed.<br>
EOF
elif [ $sdvm == 0 ];
	then
cat >> /mnt/sdcard/rtmixtemp3.sh <<EOF
Shadow compiler™ not installed.<br>
EOF
fi;
if [ $mpe == 1 ];
	then
cat >> /mnt/sdcard/rtmixtemp.sh <<EOF
#MPEngine™ integrated
#if you're running this engine on terminal emulator, keep that terminal running in the background.

(while true;
	do
		VALUE7=\`cat /system/etc/usrsettings | grep VALUE7 | awk '{print \$2}' | sed -n 1p\`;
		SKIP=\$((\$VALUE7/2));
		MFK=\`cat /proc/sys/vm/min_free_kbytes\`;
		FREEMEM=\`free | awk '{ print \$4 }' | sed -n 2p\`;
		CACHESIZE=\`cat /proc/meminfo | grep Cached | awk '{print \$2}' | sed -n 1p\`;
		TOTALMEM=\`free | awk '{ print \$2 }' | sed -n 2p\`;
		REALTOTALMEM=\$((\$TOTALMEM-\$MFK));
		MEMINUSE=\$((\$CACHESIZE+\$FREEMEM));
		VALUE8=\`cat /system/etc/usrsettings | grep VALUE8 | awk '{print \$2}' | sed -n 1p\`;
		VALUE9=\`cat /system/etc/usrsettings | grep VALUE9 | awk '{print \$2}' | sed -n 1p\`;
		DEADLINE=\$((\$REALTOTALMEM-\$MEMINUSE));
		DEADEND=\$((\$DEADLINE/\$VALUE8));
		DEADEND2=\$((\$DEADEND/\$VALUE9));
		if [ \$FREEMEM -le \$MFK ];
			then
				busybox sync; echo 1 > /proc/sys/vm/drop_caches;
				sleep \$SKIP;
				busybox sync; echo 1 > /proc/sys/vm/drop_caches;
				sleep \$SKIP;
				busybox sync; echo 1 > /proc/sys/vm/drop_caches;
				sleep \$SKIP;
				busybox sync; echo 1 > /proc/sys/vm/drop_caches;
				sleep \$SKIP;
		elif [ \$FREEMEM -gt \$MFK -a \$FREEMEM -le \$DEADEND2 ];
			then
				busybox sync; echo 1 > /proc/sys/vm/drop_caches;
				sleep \$SKIP;
				busybox sync; echo 1 > /proc/sys/vm/drop_caches;
				sleep \$SKIP;
		elif [ \$FREEMEM -gt \$DEADEND2 -a \$FREEMEM -le \$DEADEND ];
			then
				busybox sync; echo 1 > /proc/sys/vm/drop_caches;
				sleep \$VALUE7;
		elif [ \$FREEMEM -gt \$DEADEND -a \$FREEMEM -le \$MEMINUSE ];
			then
				sleep \$VALUE7;
		else
			sleep \$VALUE7;
		fi;
	done &);

EOF
cat >> /mnt/sdcard/rtmixtemp2.sh <<EOF
MPEngine™ integrated
NOTE: values are applied in realtime.
sleep timer(sec).
this value sets how much time will the engine wake up to flush page caches.
VALUE7 4

MPEngine™9.
increase the values for more battery life.
decrease the values for more performance.
setting a value to "0" is not supported.
VALUE8 6
VALUE9 2

EOF
cat >> /mnt/sdcard/rtmixtemp3.sh <<EOF
MPEngine™ integrated installed.<br>
EOF
elif [ $mpe == 0 ];
	then
cat >> /mnt/sdcard/rtmixtemp3.sh <<EOF
MPEngine™ integrated not installed.<br>
EOF
fi;
echo "finalizing product...";
#leNAROX mark.
cat >> /mnt/sdcard/rtmixtemp.sh <<EOF
#go to http://forum.xda-developers.com/showthread.php?t=2076101 for more info.
#my e-mail: hoholee12@naver.com
EOF
#transfer temp files into system directory.
cp /mnt/sdcard/rtmixtemp.sh $RTLOCATION
chown 0.0 $RTLOCATION
chmod 777 $RTLOCATION
#le mark if the file exists.
if [ -e /mnt/sdcard/rtmixtemp2.sh ];
	then
cat >> /mnt/sdcard/rtmixtemp2.sh <<EOF
#go to http://forum.xda-developers.com/showthread.php?t=2076101 for more info.
#my e-mail: hoholee12@naver.com
EOF
fi;
cp /mnt/sdcard/rtmixtemp2.sh /system/etc/usrsettings
chown 0.0 /system/etc/usrsettings
chmod 777 /system/etc/usrsettings
cat >> /mnt/sdcard/rtmixtemp3.sh <<EOF
<br>
#go to http://forum.xda-developers.com/showthread.php?t=2076101 for more info.<br>
#my e-mail: hoholee12@naver.com<br>
<br>
EOF
cp /mnt/sdcard/rtmixtemp3.sh /system/etc/readme.html
chown 0.0 /system/etc/readme.html
chmod 777 /system/etc/readme.html
if [ -s /system/etc/init.d/SS99RTMixManager -o -s /system/etc/usrsettings -o -s /system/etc/readme.html -o -s /system/xbin/rtmixman -o -s /system/etc/init.d/SS98enable_touchscreen -o -s /system/etc/init.d/SS97Netweaks ];
	then
		#version check.
		setprop rtmixman_checkver 20130318
		echo "all done, complished!!!";
		sleep 2;
		echo "now, you must reboot to take affect!";
		sleep 2;
		fastreboot
else
	sleep 2;
	echo "failed to install properly:(, please contact the developer for help.";
	sleep 5;
	main
fi;
}

unwise()
{
sleep 2;
echo "";
echo "really uninstall? are you sure?(y/n):";
read i
case $i in
	y|Y)
	echo "";
	clear;
	echo "mounting required directories to uninstall...";
	echo "";
	sync; busybox mount -o remount,rw /;
	sync; busybox mount -o remount,rw /system;
	echo "performing uninstallation, please wait...";
	echo "";
	rm /system/etc/init.d/SS97Netweaks 2>/dev/null;
	rm /system/etc/init.d/SS98enable_touchscreen 2>/dev/null;
	rm /system/etc/init.d/SS99RTMixManager 2>/dev/null;
	rm /system/xbin/rtmixman 2>/dev/null;
	rm /system/etc/usrsettings 2>/dev/null;
	rm /system/etc/readme.html 2>/dev/null;
	echo "done!";
	fastreboot
	;;
	n|N)
	echo "";
	echo "canceled.";
	sleep 2;
	main
	;;
	*)
	echo "";
	echo "user typed an invalid option, please try again.";
	sleep 2;
	unwise
	;;
esac
}

fastreboot()
{
sleep 2;
echo "";
echo "would you like to reboot?(y/n):";
read i
case $i in
	y|Y)
	echo "";
	clear;
	sleep 2;
	echo "rebooting...";
	reboot;
	;;
	n|N)
	echo "";
	echo "canceled.";
	sleep 2;
	main
	;;
	*)
	echo "";
	echo "user typed an invalid option, please try again.";
	sleep 2;
	fastreboot
	;;
esac
}

main()
{
clear;
sleep 2;
echo "================================================";
if [ -s /system/etc/init.d/SS99RTMixManager -o -s /system/etc/usrsettings -o -s /system/etc/readme.html -o -s /system/xbin/rtmixman -o -s /system/etc/init.d/SS98enable_touchscreen -o -s /system/etc/init.d/SS97Netweaks ];
	then
		checkver=`getprop rtmixman_checkver`;
		if [ $checkver -ge 20130318 ];
			then
				echo "you already have the latest version $checkver of this engine installed.";
		elif [ $checkver -lt 20130318 ];
			then
				echo "you have $checkver while this installer version is 20130318."
				echo "you will not be given the install option unless you uninstall the old version first.";
		else
			echo "unknown version identified. uninstall first before installing.";
		fi;
		echo "uninstall(u), reboot(r), quit(q):";
		echo "your choice...";
		read i
		case $i in
			u|U)
			unwise
			;;
			r|R)
			fastreboot
			;;
			q|Q)
			echo "exiting...";
			exit;
			;;
			*)
			echo "";
			echo "user typed an invalid option, please try again.";
			sleep 2;
			main
			;;
		esac
else
	echo "install(i), reboot(r), quit(q):";
	echo "your choice...";
	read i
	case $i in
		i|I)
		install
		;;
		r|R)
		fastreboot
		;;
		q|Q)
		echo "exiting...";
		exit;
		;;
		*)
		echo "";
		echo "user typed an invalid option, please try again.";
		sleep 2;
		main
		;;
	esac
fi;
}

echo "RTMixManager™ version 20130318 packages installer.";
echo "developed by LENAROX.";
echo "";
sleep 2;
echo "this engine will solve any lags and crashes on games, heavy apps and so on.";
sleep 2;
echo "which most of the mid-range android gamers have always wanted;)";
sleep 2;
echo "rock your RAM Manager like a Windows NT!!!(da well known BOSS of RAM Management), you know what i mean.:p";
sleep 2;
echo "ATTENTION!!! this engine requires the latest busybox version FROM stericson, installed to run properly.";
sleep 2;
echo "reminder: this engine is designed to run in the background with the android ram management,";
sleep 2;
echo "therefore it should NOT be used with other script applications.";
sleep 2;
echo "thanks to many xda devs who have helped me to develop better codes.";
sleep 2;
echo "this engine is based on 512mb RAM as a base and will begin to change values realtime(yeah, RT).";
sleep 2;
echo "you can modify values with usrsettings to tune your device for your own needs.";
sleep 2;
echo "you can always check which games are now playable through readme.txt!";
sleep 5;
main

#go to http://forum.xda-developers.com/showthread.php?t=2076101 for more info.
#my e-mail: hoholee12@naver.com
