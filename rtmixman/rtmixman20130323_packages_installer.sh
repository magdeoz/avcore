#!/system/bin/sh
#RTMixManager™ packages installer.
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
#thanks to gu5t3r for the bugfix:)
#
##dirty hack
#http://www.gentoo-wiki.info/Gigabyte_GA-G33M-S2H
#http://www.sysxperts.com/home/announce/vmdirtyratioandvmdirtybackgroundratio
#
##android lmk
#http://dalinaum-kr.tumblr.com/post/4528344482/android-low-memory-killer
#
#do not steal this script installer or the script that is being installed by this installer.
#you must always ask me for any permission thats related to this script,
#and give a credit by linking to this thread: http://forum.xda-developers.com/showthread.php?t=2076101

install()
{
#version identifier.
currentver=20130323
while true;
	do
		echo "mounting required directories to install...";
		sync; busybox mount -o remount,rw /;
		sync; busybox mount -o remount,rw /system;
		if [ -d "/sqlite_stmt_journals" ];
			then
				sleep 0;
		else
			echo "";
			echo "creating temporary required directory...";
			mkdir /sqlite_stmt_journals;
		fi;
		if [ -d "/system/etc/init.d" ];
			then
				sleep 0;
		else
			echo "";
			echo "creating temporary init.d folder...";
			mkdir /system/etc/init.d;
		fi;
		echo "";
		echo "done!";
		sleep 2;
		echo "";
		echo "where would you like to install? init.d(i), xbin(x), or cancel(c):";
		read i
		case $i in
			i|I)
			echo "setting up init.d...";
			RTLOCATION=/system/etc/init.d/SS99RTMixManager;
			setprop rtmixman_inst i
			break;
			;;
			x|X)
			echo "setting up xbin...";
			sleep 2;
			echo "type rtmixman in terminal emulator whenever you wish to run the engine!";
			RTLOCATION=/system/xbin/rtmixman;
			setprop rtmixman_inst x
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
echo "";
#clean all leftovers from the last update.
if [ -s /mnt/sdcard/rtmixtemp.sh -o -s /mnt/sdcard/rtmixtemp2.sh -o -s /mnt/sdcard/rtmixtemp3.sh -o -s /mnt/sdcard/rtmixtemp4.sh -o -s /mnt/sdcard/rtmixtemp5.sh ];
	then
		echo "cleaning temporary backup...";
		rm /mnt/sdcard/rtmixtemp.sh 2>/dev/null;
		rm /mnt/sdcard/rtmixtemp2.sh 2>/dev/null;
		rm /mnt/sdcard/rtmixtemp3.sh 2>/dev/null;
		rm /mnt/sdcard/rtmixtemp4.sh 2>/dev/null;
		rm /mnt/sdcard/rtmixtemp5.sh 2>/dev/null;
else
	sleep 0;
fi;
echo "";
echo "RTMixManager™ version $currentver packages installer.";
echo "developed by LENAROX.";
sleep 2;
echo "";
while true;
	do
		echo "which mode would you like to continue with?:";
		echo "PRESS (c), THAT'S AN ORDER!";
		echo "(t)ypical mode is coming soon!";
		read i
		case $i in
			t|T)
			sleep 2;
			echo "starting installation, please wait...";
			sleep 7;
			custom
			;;
			c|C)
			sleep 2;
			echo "starting installation, please wait...";
			sleep 7;
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
echo "custom mode."
sleep 2;
echo "";
echo "now, you will be given a series of questions, its a part of procedure, for installation!:)";
sleep 2;
echo "remember to always give careful attention for what you're doing!";
sleep 7;
clear;
sleep 2;
echo "STEP 1:";
sleep 2;
echo "";
echo "====exclusive scripts===========================";
sleep 2;
echo "";
echo "";
while true;
	do
		echo "would you like to install Netweaks script by shantam?(y/n):";
		read i
		case $i in
			y|Y)
			echo "installing...";
			sleep 2;
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
echo "";
echo "next,"
sleep 2;
echo "";
echo "";
while true;
	do
		echo "would you like to install responsive tounchscreen script by chainfire?(y/n):";
		read i
		case $i in
			y|Y)
			echo "installing...";
			sleep 2;
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
echo "";
echo "step 1 complete.";
sleep 7;
clear;
sleep 2;
echo "STEP 2:";
sleep 2;
echo "";
echo "======my scripts, my rules======================";
sleep 2;
echo "now, this is the real thing you've been waiting here.";
sleep 2;
echo "";
echo "calm down your mind, and read carefully before proceeding!!!";
sleep 2;
echo "";
echo "if you're ready, lets start!":
sleep 2;
echo "";
echo "";
echo "-Rapid Storage Boost(RSB)™ Technology";
sleep 2;
echo "";
echo "this enables wise I/O to make every single processes get better access to flash drives(mmc).";
sleep 2;
echo "fixes Max Payne Mobile main menu hanging problem.";
sleep 2;
echo "disable leases to gain faster access(better responsiveness) to the filesystem.";
sleep 2;
echo "pre-calculated vm options helps lots of I/O interactive games which are getting into trouble with overflowing I/O,";
sleep 2;
echo "such as Grand Theft Auto III 10Year-Anniversary Edition.";
sleep 2;
echo "this technology fixes lots of games such as sound stutter loops, loading hang, and so on. definitely recommended for gamers.";
sleep 2;
echo "";
echo "NOTE: this engine creates a usrsettings file on /system/etc directory.";
sleep 2;
echo "";
while true;
	do
		echo "would you like to apply?(y/n):";
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
			echo "disabled, just to let you know: you have disabled the third SPECIAL part of this script...";
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
echo "";
echo "";
echo "-RTMixManager™ Engine 2.0";
sleep 2;
echo "";
echo "features lowmem Mix-up Enhancement(NDPA) calculation.=> Multitasking and Performance both enhanced.";
sleep 2;
echo "a main feature of rtmixmanager: it controls android memory manager directly.";
sleep 2;
echo "it allows you to gain more free memory, much faster when needed.";
sleep 2;
echo "";
echo "NOTE: this engine creates a usrsettings file on /system/etc directory.";
sleep 2;
echo "";
while true;
	do
		echo "would you like to apply?(y/n):";
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
			echo "disabled, just to let you know: you have disabled the second SPECIAL part of this script...";
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
echo "";
echo "";
echo "-Shadow compiler™";
sleep 2;
echo "";
echo "it optimizes all dalvik vm bytecodes to perform as much powerful as a native code.";
sleep 2;
echo "therefore, it permanently disables lags in both UI and sound system:D";
sleep 2;
echo "forces Max Payne Mobile to resist a bit longer before getting owned by GC.";
sleep 2;
echo "also, Need For Speed Mostwanted loadscreen hangs and Max Payne Mobile stuttery sounds are fixed!"
sleep 2;
echo "";
echo "caution: this may give various FCs on apps for some ROMs. i prefer NOT to use it.";
sleep 2;
echo "";
while true;
	do
		echo "would you like to apply?(y/n):";
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
			echo "disabled.";
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
echo "";
echo "";
echo "-MPEngine™ integrated";
sleep 2;
echo "";
echo "the holy replacement of the linux default pdflush(dirty data)";
sleep 2;
echo "this dominates most of the lags you see, one by one.";
sleep 2;
echo "some users reported that once this engine starts to kick in, the phone spits out a massive gaming performance!";
sleep 2;
echo "";
echo "NOTE: this engine creates a usrsettings file on /system/etc directory.";
sleep 2;
echo "";
while true;
	do
		echo "would you like to apply?(y/n):";
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
			echo "disabled, just to let you know: you have disabled the most SPECIAL part of this script...";
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
echo "all setup information has been collected."
sleep 2;
echo "";
echo "installing RTMixManager™ components...";
sleep 7;
cat >> /mnt/sdcard/rtmixtemp.sh <<EOF
#!/system/bin/sh
#RTMixManager™ version $currentver
#developed by LENAROX
#version check.
setprop rtmixman_checkver $currentver
#this engine will solve any lags and crashes on games, heavy apps and so on.
#which most of the mid-range android gamers have always wanted;)
#rock your RAM Manager like a Windows NT!!!(da well known BOSS of RAM Management), you know what i mean.:p
#ATTENTION!!! this engine requires the latest busybox version FROM stericson, installed to run properly.
#reminder: this engine is designed to run in the background with the android ram management,
#therefore it should NOT be used with other script applications.
#
#thanks to many xda devs who have helped me to develop better codes!
#thanks to chainfire for touchscreen responsiveness tweak.
#thanks to shantam for Netweaks.
#thanks to professionals from stackoverflow.com who gave me some good advices!
#thanks to mv style for lupus kernel script.
#thanks to zeppelinrox for the script design, and the bugfix!
#thanks to gu5t3r for the bugfix:)
#
##dirty hack
#http://www.gentoo-wiki.info/Gigabyte_GA-G33M-S2H
#http://www.sysxperts.com/home/announce/vmdirtyratioandvmdirtybackgroundratio
#
##android lmk
#http://dalinaum-kr.tumblr.com/post/4528344482/android-low-memory-killer
#
#you can modify values with usrsettings to tune your device for your own needs.
#you can always check which games are now playable through readme.txt!

EOF
inst=`getprop rtmixman_inst`
if [ $inst == i ];
	then
		setprop rtmixman_inst null
cat >> /mnt/sdcard/rtmixtemp.sh <<EOF
#re-run the script in the background.
exec > /dev/null 2>&1
if [ "\$1" != "BG" ]; then \$0 BG & exit 0; fi

EOF
elif [ $inst == x ];
	then
		setprop rtmixman_inst null
		sleep 0;
else
	sleep 2;
	setprop rtmixman_checkver null
	setprop rtmixman_inst null
	echo "failed to install properly:(, please contact the developer for help.";
	sleep 7;
	main
fi;
	
cat >> /mnt/sdcard/rtmixtemp2.sh <<EOF
usrsettings
package installed in `date`.

NOTE: Do NOT set any false values in usrsettings.

EOF
cat >> /mnt/sdcard/rtmixtemp3.sh <<EOF
readme.html<br>
package installed in `date`.<br>
<br>
RTMixManager™ version $currentver<br>
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
thanks to gu5t3r for the bugfix:)<br>
<br>
dirty hack<br>
<a href="http://www.gentoo-wiki.info/Gigabyte_GA-G33M-S2H">http://www.gentoo-wiki.info/Gigabyte_GA-G33M-S2H</a><br>
<a href="http://www.sysxperts.com/home/announce/vmdirtyratioandvmdirtybackgroundratio">http://www.sysxperts.com/home/announce/vmdirtyratioandvmdirtybackgroundratio</a><br>
<br>
android lmk<br>
<a href="http://dalinaum-kr.tumblr.com/post/4528344482/android-low-memory-killer">http://dalinaum-kr.tumblr.com/post/4528344482/android-low-memory-killer</a><br>
<br>
<b>do not steal this script installer or the script that is being installed by this installer.<br>
you must always ask me for any permission thats related to this script,
and give a credit by linking to this thread <a href="http://forum.xda-developers.com/showthread.php?t=2076101">here</a>.</b><br>
<br>
Games & Others Compatibility List>><br>
================================================<br>
Rapid Storage Boost(RSB)™ Technology:<br>
-fixes Max Payne Mobile main menu hangs.<br>
-disable leases to gain faster access(better responsiveness) to the filesystem.<br>
-pre-calculated vm options helps lots of I/O interactive games which are getting into trouble with overflowing I/O,<br>
-such as Grand Theft Auto III 10Year-Anniversary Edition.<br>
<br>
RTMixManager™ Engine 2.0:<br>
-lowmem Mix-up Enhancement(NDPA) calculation.=> Multitasking and Performance both enhanced.<br>
-it allows you to gain more free memory, much faster when needed.<br>
<br>
Shadow compiler™:<br>
-it optimizes all dalvik vm bytecodes to perform as much powerful as a native code.<br>
-forces Max Payne Mobile to resist a bit longer before getting owned by GC.<br>
-also, Need For Speed Mostwanted loadscreen hangs and Max Payne Mobile stuttery sounds are fixed!<br>
<br>
MPEngine™ integrated:<br>
-the holy replacement of the linux default pdflush(dirty data)<br>
-this dominates most of the lags you see, one by one.<br>
-some users reported that once this engine starts to kick in, the phone spits out a massive gaming performance!<br>
<br>
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
#you don't need both options of controlling the dirty data, as they will conflict each other for any reason.
#i'll go with dirty_writeback_centisecs as a main pdflush option.(unless you want mpengine to handle it)
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
#disable leases to gain faster access to the filesystem.
if [ -e /proc/sys/fs/leases-enable ];
	then
		echo 0 > /proc/sys/fs/leases-enable;
fi;
#we're also gonna push this into the writeback parameter.
LEASES=\`cat /proc/sys/fs/lease-break-time\`;
L2W=\$((\$LEASES*100));
if [ -e /proc/sys/vm/dirty_writeback_centisecs ];
	then
		echo \$L2W > /proc/sys/vm/dirty_writeback_centisecs;
fi;
#don't let the dirty_ratio handle the dirty data.
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
if [ $rtmix == 1 ];
	then
cat >> /mnt/sdcard/rtmixtemp.sh <<EOF
#RTMixManager™ Engine 2.0
#replaced with renice command which is very complex as hell.
setprop ENFORCE_PROCESS_LIMIT false
#major adj parameter groups: -16, -12, 0, 1, 2, 4, 6, 7, 8, 9, 10, 11, and 14.
#background app adj parameter changes to 7 or 8 by default.
VALUE6=\`cat /system/etc/usrsettings | grep VALUE6 | awk '{print \$2}' | sed -n 1p\`;
if [ \$VALUE6 == 1 ];
	then
		if [ -s /sys/module/lowmemorykiller/parameters/adj ];
			then
				echo 1,2,4,6,7,8 > /sys/module/lowmemorykiller/parameters/adj;
		fi;
elif [ \$VALUE6 == 2 ];
	then
		if [ -s /sys/module/lowmemorykiller/parameters/adj ];
			then
				echo 0,1,2,4,6,7 > /sys/module/lowmemorykiller/parameters/adj;
		fi;
elif [ \$VALUE6 == 3 ];
	then
		if [ -s /sys/module/lowmemorykiller/parameters/adj ];
			then
				echo 2,4,6,7,8,9 > /sys/module/lowmemorykiller/parameters/adj;
		fi;
else
	echo "a false value has been encountered in usrsettings.";
fi;
#retrieve current adj parameter settings.
adj1=\`awk -F , '{print \$1}' /sys/module/lowmemorykiller/parameters/adj\`;
adj2=\`awk -F , '{print \$2}' /sys/module/lowmemorykiller/parameters/adj\`;
adj3=\`awk -F , '{print \$3}' /sys/module/lowmemorykiller/parameters/adj\`;
adj4=\`awk -F , '{print \$4}' /sys/module/lowmemorykiller/parameters/adj\`;
adj5=\`awk -F , '{print \$5}' /sys/module/lowmemorykiller/parameters/adj\`;
adj6=\`awk -F , '{print \$6}' /sys/module/lowmemorykiller/parameters/adj\`;
TOTALMEM=\`free | awk '{ print \$2 }' | sed -n 2p\`;
totalpage=\$((\$TOTALMEM/4));
MFK=\`cat /proc/sys/vm/min_free_kbytes\`;
mfkpage=\$((\$MFK/4));
#avoid all-level termination bug by adding 1 page to each level.
adp=\$((\$totalpage/6));
acp=\$((\$adp+1));
cps=\$((\$acp+1));
dpsg=\$((\$cps+1));
eps=\$((\$dpsg+1));
fpsg=\$((\$eps+1));
#try to block service apps from being terminated. with straight flush technology!
if [ \$adj1 == 1 ];
	then
		if [ -e /sys/module/lowmemorykiller/parameters/minfree ];
			then
				echo \$mfkpage,\$acp,\$cps,\$dpsg,\$eps,\$fpsg > /sys/module/lowmemorykiller/parameters/minfree;
		fi;
elif [ \$adj2 == 1 ];
	then
		if [ -e /sys/module/lowmemorykiller/parameters/minfree ];
			then
				echo 0,\$mfkpage,\$cps,\$dpsg,\$eps,\$fpsg > /sys/module/lowmemorykiller/parameters/minfree;
		fi;
elif [ \$adj3 == 1 ];
	then
		if [ -e /sys/module/lowmemorykiller/parameters/minfree ];
			then
				echo 0,0,\$mfkpage,\$dpsg,\$eps,\$fpsg > /sys/module/lowmemorykiller/parameters/minfree;
		fi;
elif [ \$adj4 == 1 ];
	then
		if [ -e /sys/module/lowmemorykiller/parameters/minfree ];
			then
				echo 0,0,0,\$mfkpage,\$eps,\$fpsg > /sys/module/lowmemorykiller/parameters/minfree;
		fi;
elif [ \$adj5 == 1 ];
	then
		if [ -e /sys/module/lowmemorykiller/parameters/minfree ];
			then
				echo 0,0,0,0,\$mfkpage,\$fpsg > /sys/module/lowmemorykiller/parameters/minfree;
		fi;
elif [ \$adj6 == 1 ];
	then
		if [ -e /sys/module/lowmemorykiller/parameters/minfree ];
			then
				echo 0,0,0,0,0,\$mfkpage > /sys/module/lowmemorykiller/parameters/minfree;
		fi;
else
	if [ -e /sys/module/lowmemorykiller/parameters/minfree ];
		then
			echo \$adp,\$acp,\$cps,\$dpsg,\$eps,\$fpsg > /sys/module/lowmemorykiller/parameters/minfree;
	fi;
fi;
#assuming that android.process.media is already locked in memory:

(while true;
	do
		sleep 30;
		acore=\`pidof android.process.acore\`
		echo -12 > /proc/\$acore/oom_adj;
	done &);

EOF
cat >> /mnt/sdcard/rtmixtemp2.sh <<EOF
RTMixManager™ Engine
value 1 is balanced.
value 2 is focused on performance.
value 3 is focused on multitasking.
choose what you desire the most!
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
setprop dalvik.vm.dexopt-flags v=a,o=a

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
#if you're running this engine on a terminal emulator, keep that terminal running in the background.
#permenantly disable periodic writeback, so that we can make the mpengine to handle everything.
if [ -e /proc/sys/vm/dirty_writeback_centisecs ];
	then
		echo 27640520 > /proc/sys/vm/dirty_writeback_centisecs;
fi;
#don't let the dirty_ratio handle the dirty data.
if [ -e /proc/sys/vm/dirty_expire_centisecs ];
	then
		echo 0 > /proc/sys/vm/dirty_expire_centisecs;
fi;
#MPEngine™9X

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

MPEngine™9X.
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
		setprop rtmixman_checkver $currentver
		echo "all done!";
		sleep 2;
		echo "now, you must reboot your device to take affect!";
		sleep 2;
		fastreboot
else
	sleep 2;
	setprop rtmixman_checkver null
	echo "failed to install properly:(, please contact the developer for help.";
	sleep 7;
	main
fi;
}

custom()
{
#version identifier.
currentver=20130323
inst=`getprop rtmixman_inst`
if [ $inst == i ];
	then
		RTLOCATION=/system/etc/init.d/SS99RTMixManager;
		setprop rtmixman_inst null
elif [ $inst == x ];
	then
		RTLOCATION=/system/xbin/rtmixman;
		setprop rtmixman_inst null
fi;
echo "";
echo "typical mode.";
sleep 2;
echo "";
while true;
	do
		echo "choose one option to view their descriptions & install:";
		echo "";
		echo "          1)gamer mode";
		echo "          2)didntisaythisplaceisunderconstruction...";
		echo "          3)Y U HAD TO PRESS IT???";
		echo "          ";
		sleep 2;
		echo "returning to menu in...";
		sleep 1;
		echo "3";
		sleep 1;
		echo "2";
		sleep 1;
		echo "1";
		sleep 1;
		clear;
		echo "rage quit:p";
		sleep 0;
		main
	done
}

unwise()
{
sleep 2;
echo "";
echo "are you sure you wish to uninstall it from your device?(y/n):";
read i
case $i in
	y|Y)
	sleep 0;
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
echo "";
clear;
echo "mounting required directories to uninstall...";
sync; busybox mount -o remount,rw /;
sync; busybox mount -o remount,rw /system;
echo "";
echo "performing uninstallation, please wait...";
rm /system/etc/init.d/SS97Netweaks 2>/dev/null;
rm /system/etc/init.d/SS98enable_touchscreen 2>/dev/null;
rm /system/etc/init.d/SS99RTMixManager 2>/dev/null;
rm /system/xbin/rtmixman 2>/dev/null;
rm /system/etc/usrsettings 2>/dev/null;
rm /system/etc/readme.html 2>/dev/null;
echo "";
if [ -s /system/etc/init.d/SS99RTMixManager -o -s /system/etc/usrsettings -o -s /system/etc/readme.html -o -s /system/xbin/rtmixman -o -s /system/etc/init.d/SS98enable_touchscreen -o -s /system/etc/init.d/SS97Netweaks ];
	then
		sleep 2;
		echo "failed to uninstall properly:(, please contact the developer for help.";
		sleep 7;
		main
else
	echo "done!";
	sleep 2;
	inst=`getprop rtmixman_inst`
	if [ $inst == wise ];
		then
			setprop rtmixman_inst null
			while true;
				do
					echo "continue to installer?(y/n):";
					read i
					case $i in
						y|Y)
						sleep 2;
						install
						;;
						n|N)
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
	elif [ $inst != wise ];
		then
			setprop rtmixman_inst null
			fastreboot
	else
		setprop rtmixman_inst null
		fastreboot
	fi;
fi;

}

fastreboot()
{
sleep 2;
echo "";
echo "would you like to reboot your device?(y/n):";
read i
case $i in
	y|Y)
	sleep 2;
	clear;
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
#version identifier.
currentver=20130323
clear;
sleep 2;
echo "================================================";
if [ -s /system/etc/init.d/SS99RTMixManager -o -s /system/etc/usrsettings -o -s /system/etc/readme.html -o -s /system/etc/init.d/SS98enable_touchscreen -o -s /system/etc/init.d/SS97Netweaks ];
	then
		checkver=`getprop rtmixman_checkver`;
		if [ $checkver -ge $currentver ];
			then
				setprop rtmixman_inst null
				echo "you already have the latest version $checkver of this engine installed.";
		elif [ $checkver -lt $currentver ];
			then
				setprop rtmixman_inst wise
				echo "you have $checkver while this installer version is $currentver."
				echo "you will not be given the install option unless you uninstall the old version first.";
		elif [ $checkver == null ];
			then
				setprop rtmixman_inst wise
				echo "this installer detected that it have failed to complete its operations due to some error the last time you have installed.";
				echo "please contact the developer for help.";
		else
			setprop rtmixman_inst wise
			echo "unknown version identified. uninstall first before installing.";
		fi;
		echo "uninstall(u), reboot(r), or quit(q):";
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
			sleep 2;
			echo "";
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
elif [ -s /system/xbin/rtmixman -o -s /system/etc/usrsettings -o -s /system/etc/readme.html -o -s /system/etc/init.d/SS98enable_touchscreen -o -s /system/etc/init.d/SS97Netweaks ];
	then
		checkver=`getprop rtmixman_checkver`;
		if [ $checkver -ge $currentver ];
			then
				setprop rtmixman_inst null
				echo "you already have the latest version $checkver of this engine installed.";
		elif [ $checkver -lt $currentver ];
			then
				setprop rtmixman_inst wise
				echo "you have $checkver while this installer version is $currentver."
				echo "you will not be given the install option unless you uninstall the old version first.";
		elif [ $checkver == null ];
			then
				setprop rtmixman_inst wise
				echo "this installer detected that it have failed to complete its operations due to some error the last time you have installed.";
				echo "please contact the developer for help.";
		else
			setprop rtmixman_inst null
			echo "you have an xbin version that is currently not running in memory. run it first before you continue!";
		fi;
		echo "uninstall(u), reboot(r), or quit(q):";
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
			sleep 2;
			echo "";
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
	echo "install(i), reboot(r), or quit(q):";
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
		sleep 2;
		echo "";
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

#version identifier.
currentver=20130323
echo "RTMixManager™ version $currentver packages installer.";
echo "developed by LENAROX.";
sleep 2;
echo "";
echo "this engine will solve any lags and crashes on games, heavy apps and so on.";
echo "which most of the mid-range android gamers have always wanted;)";
echo "rock your RAM Manager like a Windows NT!!!(da well known BOSS of RAM Management), you know what i mean.:p";
echo "ATTENTION!!! this engine requires the latest busybox version FROM stericson, installed to run properly.";
echo "reminder: this engine is designed to run in the background realtime(yeah, RT lol:p) with the android ram management,";
echo "therefore it should NOT be used with other script applications.";
sleep 2;
echo "";
echo "thanks to many xda devs who have helped me to develop better codes!";
echo "thanks to chainfire for touchscreen responsiveness tweak.";
echo "thanks to shantam for Netweaks.";
echo "thanks to professionals from stackoverflow.com who gave me some good advices!";
echo "thanks to mv style for lupus kernel script.";
echo "thanks to zeppelinrox for the script design, and the bugfix!";
echo "thanks to gu5t3r for the bugfix:)";
sleep 2;
echo "";
echo "dirty hack";
echo "http://www.gentoo-wiki.info/Gigabyte_GA-G33M-S2H";
echo "http://www.sysxperts.com/home/announce/vmdirtyratioandvmdirtybackgroundratio";
sleep 2;
echo "";
echo "android lmk";
echo "http://dalinaum-kr.tumblr.com/post/4528344482/android-low-memory-killer";
sleep 2;
echo "";
echo "do not steal this script installer or the script that is being installed by this installer.";
echo "you must always ask me for any permission thats related to this script,";
echo "and give a credit by linking to this thread: http://forum.xda-developers.com/showthread.php?t=2076101";
sleep 7;
main

#go to http://forum.xda-developers.com/showthread.php?t=2076101 for more info.
#my e-mail: hoholee12@naver.com
