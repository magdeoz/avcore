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

main()
{
rtmixman_checkver=20130407
clear
echo "================================================"
sleep 2
while true; do
	if [ -e /system/etc/init.d/SS99RTMixManager ] && [ -e /system/etc/usrsettings ] && [ -e /system/etc/readme.html ]; then
		rtmixman_currentver=`getprop rtmixman_checkver`
		if [ "$rtmixman_currentver" -ge "$rtmixman_checkver" ] 2>/dev/null; then
			setprop rtmixman_inst null
			echo "you have the latest version $rtmixman_checkver of         "
			echo "                       ...this engine installed."
		elif [ "$rtmixman_currentver" -lt "$rtmixman_checkver" ] 2>/dev/null; then
			setprop rtmixman_inst wise
			echo "you have $rtmixman_currentver while this,                   "
			echo "               ...installer version is $rtmixman_checkver."
			echo "                                                "
			echo "you will not be given the install option unless you uninstall the old version first."
		elif [ "$rtmixman_currentver" == null ] 2>/dev/null; then
			setprop rtmixman_inst wise
			echo "this installer detected that it have failed to  "
			echo "complete its operations due to some error from  "
			echo "the last time you have installed.               "
			echo "                                                "
			echo "please contact the developer for help.          "
		else
			setprop rtmixman_inst wise
			echo "unknown version identified. uninstall first...  "
			echo "                           ...before installing."
		fi
		echo "uninstall(u), reboot(r), or quit(q):            "
		echo "                                  your choice..."
		read i
		case "$i" in
			u|U)
			unwise
			;;
			r|R)
			fastreboot
			;;
			q|Q)
			sleep 2
			echo "                                                "
			echo "exiting...                                      "
			exit
			;;
			*)
			echo "                                                "
			echo "user typed an invalid option, please try again. "
			sleep 2
			;;
		esac
	elif [ -e /system/xbin/rtmixman ] && [ -e /system/etc/usrsettings ] && [ -e /system/etc/readme.html ]; then
		rtmixman_currentver=`getprop rtmixman_checkver`
		if [ "$rtmixman_currentver" -ge "$rtmixman_checkver" ] 2>/dev/null; then
			setprop rtmixman_inst null
			echo "you have the latest version $rtmixman_checkver of         "
			echo "                       ...this engine installed."
		elif [ "$rtmixman_currentver" -lt "$rtmixman_checkver" ] 2>/dev/null; then
			setprop rtmixman_inst wise
			echo "you have $rtmixman_currentver while this,                   "
			echo "               ...installer version is $rtmixman_checkver."
			echo "you will not be given the install option unless you uninstall the old version first."
		elif [ "$rtmixman_currentver" == null ] 2>/dev/null; then
			setprop rtmixman_inst wise
			echo "this installer detected that it have failed to  "
			echo "complete its operations due to some error from  "
			echo "the last time you have installed.               "
			echo "                                                "
			echo "please contact the developer for help.          "
		else
			setprop rtmixman_inst null
			echo "you have an xbin version that is currently,     "
			echo "not running in memory. run it first before you  "
			echo "continue!                                       "
		fi
		echo "uninstall(u), reboot(r), or quit(q):            "
		echo "                                  your choice..."
		read i
		case "$i" in
			u|U)
			unwise
			;;
			r|R)
			fastreboot
			;;
			q|Q)
			sleep 2
			echo "                                                "
			echo "exiting...                                      "
			exit
			;;
			*)
			echo "                                                "
			echo "user typed an invalid option, please try again. "
			sleep 2
			;;
		esac
	else
		echo "install(i), reboot(r), or quit(q):              "
		echo "                                  your choice..."
		read i
		case "$i" in
			i|I)
			userinit
			;;
			r|R)
			fastreboot
			;;
			q|Q)
			sleep 2
			echo "                                                "
			echo "exiting...                                      "
			exit
			;;
			*)
			echo "                                                "
			echo "user typed an invalid option, please try again. "
			sleep 2
			;;
		esac
	fi
done
}

unwise()
{
sleep 2
while true; do
	echo "are you sure you wish to completely,            "
	echo "            ...remove it from your device?(y/n):"
	read i
	case "$i" in
		y|Y)
		break
		;;
		n|N)
		echo "                                                "
		echo "                                       canceled."
		sleep 2
		main
		;;
		*)
		echo "                                                "
		echo "user typed an invalid option, please try again. "
		sleep 2
		;;
	esac
done
echo "                                                "
echo "mounting required directories to uninstall...   "
sync; busybox mount -o remount,rw /
sync; busybox mount -o remount,rw rootfs
sync; busybox mount -o remount,rw /system
echo "performing uninstallation, please wait...       "
rm /system/etc/init.d/SS99RTMixManager 2>/dev/null
rm /system/xbin/rtmixman 2>/dev/null
rm /system/etc/usrsettings 2>/dev/null
rm /system/etc/readme.html 2>/dev/null
setprop rtmixman_checkver null
if [ -e "/system/etc/init.d/SS98enable_touchscreen" ] || [ -e "/system/etc/init.d/SS97Netweaks" ]; then
	while true; do
		echo "                                                "
		echo "would you like to erase all the previous version"
		echo "                  ...specific scripts, too?(y/n)"
		read i
		case "$i" in
			y|Y)
			echo "                                                "
			echo "removing old scripts...                         "
			rm /system/etc/init.d/SS97Netweaks 2>/dev/null
			rm /system/etc/init.d/SS98enable_touchscreen 2>/dev/null
			break
			;;
			n|N)
			echo "                                                "
			echo "                                       canceled."
			sleep 2
			break
			;;
			*)
			echo "                                                "
			echo "user typed an invalid option, please try again. "
			sleep 2
			;;
		esac
	done
fi
if [ -e "/system/etc/init.d/SS99RTMixManager" ] || [ -e "/system/etc/usrsettings" ] || [ -e "/system/etc/readme.html" ] || [ -e "/system/xbin/rtmixman" ]; then
	sleep 2
	echo "                                                "
	echo "failed to uninstall properly.:(                 "
	echo "       ...please contact the developer for help."
	sleep 7
	main
else
	echo "                                                "
	echo "                                        ...done!"
	sleep 2
	if [ "`getprop rtmixman_inst`" == wise ]; then
		setprop rtmixman_inst null
		while true; do
			echo "continue to installer?(y/n):                    "
			read i
			case "$i" in
				y|Y)
				sleep 2
				userinit
				;;
				n|N)
				sleep 2
				fastreboot
				;;
				*)
				echo "                                                "
				echo "user typed an invalid option, please try again. "
				sleep 2
				;;
			esac
		done
	elif [ "`getprop rtmixman_inst`" == null ]; then
		fastreboot
	else
		setprop rtmixman_inst null
		sleep 2
		echo "                                                "
		echo "failed to uninstall properly.:(                 "
		echo "       ...please contact the developer for help."
		sleep 7
		main
	fi
fi
}

fastreboot()
{
sleep 2
while true; do
	echo "                                                "
	echo "would you like to restart?(y/n):                "
	read i
	case "$i" in
		y|Y)
		sleep 2
		clear
		echo "restarting...                                   "
		reboot
		;;
		n|N)
		echo "                                                "
		echo "                                       canceled."
		sleep 2
		main
		;;
		*)
		echo "                                                "
		echo "user typed an invalid option, please try again. "
		sleep 2
		;;
	esac
done
}

userinit()
{
clear
echo "================================================"
sleep 2
echo "                                                "
echo "                   DISCLAIMER(DUN DUN DUUN...:p)"
sleep 2
echo "                                                "
echo "Copyright 2013 LENAROX@xda                      "
sleep 2
echo "                                                "
echo "Licensed under the Apache License, Version 2.0  "
echo "you may not use this file except in compliance  "
echo "with the License.                               "
sleep 2
echo "You may obtain a copy of the License at:        "
echo "                                                "
echo "   http://www.apache.org/licenses/LICENSE-2.0   "
sleep 2
echo "                                                "
echo "Unless required by applicable law or agreed to  "
echo "in writing, software distributed under the      "
echo "License is distributed on an "AS IS" BASIS,     "
echo "WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,   "
echo "either express or implied.                      "
sleep 2
echo "See the License for the specific language       "
echo "governing permissions and limitations under     "
echo "the License."
sleep 7
while true; do
	echo "                                                "
	echo "if you choose to accept, press (a).             "
	echo "if you want to return to main menu, press (d).  "
	read i
	case "$i" in
		a|A)
		echo "                                                "
		echo "                                       accepted."
		sleep 2
		break
		;;
		d|D)
		echo "                                                "
		echo "                                       declined."
		sleep 2
		main
		;;
		*)
		echo "                                                "
		echo "user typed an invalid option, please try again. "
		sleep 2
		;;
	esac
done
echo "                                                "
while true; do
	echo "                                                "
	echo "how would you like to install it?               "
	echo "   ...the (e)asy way, or the (h)ard(custom) way?"
	echo "you can always quit anytime with (q).           "
	read i
	case "$i" in
		e|E)
		echo "                                                "
		echo "typical mode activated.                         "
		sleep 2
		typical
		;;
		h|H)
		echo "                                                "
		echo "custom mode activated.                          "
		sleep 2
		custom
		;;
		q|Q)
		echo "                                                "
		echo "                                       canceled."
		sleep 2
		main
		;;
		*)
		echo "                                                "
		echo "user typed an invalid option, please try again. "
		sleep 2
		;;
	esac
done
}

typical()
{
clear
echo "================================================"
sleep 2
echo "gathering device information...                 "
if [ -d "/system/etc/init.d" ]; then
	setprop rtmixman_locations i
	echo "init.d selected.                                "
else
	setprop rtmixman_locations x
	echo "xbin selected.                                  "
fi
echo "                                                "
echo "typical mode                                    "
echo "               TABLE OF CONTENTS                "
sleep 2
echo "                                                "
echo "(g)amer package: I/O+MPEngine parts             "
echo "(m)ultitasking package: I/O+Core+MPEngine parts "
echo "(f)ull package: AP+I/O+Core+MPEngine parts      "
sleep 2
echo "                                                "
while true; do
	echo "which one would you like to install?(g/m/f)     "
	read i
	case "$i" in
		g|G)
		echo "packing up...                                   "
		setprop rtmixman_rsb 1
		setprop rtmixman_mpe 1
		sleep 2
		install
		;;
		m|M)
		echo "packing up...                                   "
		setprop rtmixman_rsb 1
		setprop rtmixman_rtmix 1
		setprop rtmixman_mpe 1
		sleep 2
		install
		;;
		f|F)
		echo "packing up...                                   "
		setprop rtmixman_sdvm 1
		setprop rtmixman_rsb 1
		setprop rtmixman_rtmix 1
		setprop rtmixman_mpe 1
		sleep 2
		install
		;;
		q|Q)
		setprop rtmixman_locations null
		echo "                                                "
		echo "                                       canceled."
		sleep 2
		main
		;;
		*)
		echo "                                                "
		echo "user typed an invalid option, please try again. "
		sleep 2
		;;
	esac
done
}

custom()
{
while true; do
	echo "where would you like to install?                "
	echo "                        ...(i)nit.d, or (x)bin?:"
	read i
	case "$i" in
		i|I)
		echo "                                                "
		echo "setting up init.d...                            "
		setprop rtmixman_locations i
		sleep 2
		break
		;;
		x|X)
		echo "                                                "
		echo "setting up xbin...                              "
		setprop rtmixman_locations x
		sleep 2
		echo "type 'rtmixman' in terminal emulator, whenever you wish to run this engine!"
		sleep 7
		break
		;;
		q|Q)
		echo "                                                "
		echo "                                       canceled."
		sleep 2
		main
		;;
		*)
		echo "                                                "
		echo "user typed an invalid option, please try again. "
		sleep 2
		;;
	esac
done
clear
echo "================================================"
sleep 2
echo "                                                "
echo "custom mode                                     "
echo "                LONG ASS CHARTS                 "
sleep 2
echo "                                                "
echo "AP boost                                        "
sleep 2
echo "                                                "
echo "-this part of the engine handles the Dalvik VM. "
echo "-fixes badly coded games to run a bit better.   "
sleep 2
while true; do
	echo "                                                "
	echo "would you like to apply?(y/n):                  "
	read i
	case "$i" in
		y|Y)
		echo "                                                "
		echo "enabled.                                        "
		setprop rtmixman_sdvm 1
		sleep 2
		break
		;;
		n|N)
		echo "                                                "
		echo "disabled.                                       "
		setprop rtmixman_sdvm 0
		sleep 2
		break
		;;
		q|Q)
		setprop rtmixman_locations null
		echo "                                                "
		echo "                                       canceled."
		sleep 2
		main
		;;
		*)
		echo "                                                "
		echo "user typed an invalid option, please try again. "
		sleep 2
		;;
	esac
done
echo "                                                "
echo "Rapid Storage Boost Technology 2.0 Unlocked     "
sleep 2
echo "                                                "
echo "-this part of the engine fixes the I/O.         "
echo "-needed for games with high I/O interactivity.  "
echo "-reminder: 'Unlocked' refers to some features,  "
echo "    ...that are modified or deleted to gain more"
echo "efficient performance of the original engine.   "
echo "-co-operates with AP boost                      "
echo "-uses realtimed settings.                       "
sleep 2
while true; do
	echo "                                                "
	echo "would you like to apply?(y/n):                  "
	read i
	case "$i" in
		y|Y)
		echo "                                                "
		echo "enabled.                                        "
		setprop rtmixman_rsb 1
		sleep 2
		break
		;;
		n|N)
		echo "                                                "
		echo "disabled.                                       "
		setprop rtmixman_rsb 0
		sleep 2
		break
		;;
		q|Q)
		setprop rtmixman_locations null
		setprop rtmixman_sdvm null
		echo "                                                "
		echo "                                       canceled."
		sleep 2
		main
		;;
		*)
		echo "                                                "
		echo "user typed an invalid option, please try again. "
		sleep 2
		;;
	esac
done
echo "                                                "
echo "Core Engine 2.2                                 "
sleep 2
echo "                                                "
echo "-this part of the engine handles the            "
echo "Android™ lowmemorykiller.                       "
echo "-it allows you to gain more free memory, while  "
echo "  ...avoiding launcher redraws at the same time."
echo "-NOTE: this engine may not be a good decision   "
echo "for most stock ROMS, which are having more than "
echo "           ...100mb RAM eating monster launchers"
echo "crawling inside.                                "
echo "-uses realtimed settings.                       "
sleep 2
while true; do
	echo "                                                "
	echo "would you like to apply?(y/n):                  "
	read i
	case "$i" in
		y|Y)
		echo "                                                "
		echo "enabled.                                        "
		setprop rtmixman_rtmix 1
		sleep 2
		break
		;;
		n|N)
		echo "                                                "
		echo "disabled.                                       "
		setprop rtmixman_rtmix 0
		sleep 2
		break
		;;
		q|Q)
		setprop rtmixman_locations null
		setprop rtmixman_sdvm null
		setprop rtmixman_rsb null
		echo "                                                "
		echo "                                       canceled."
		sleep 2
		main
		;;
		*)
		echo "                                                "
		echo "user typed an invalid option, please try again. "
		sleep 2
		;;
	esac
done
echo "                                                "
echo "MPEngine integrated                             "
sleep 2
echo "                                                "
echo "-this part of the engine dominates pretty much  "
echo "              ...any lags you see, one-by-one.:)"
echo "-some users reported that once this engine      "
echo "      ...starts to kick in, the device spits out"
echo "a massive gaming performance!                   "
echo "-uses realtimed settings.                       "
sleep 2
while true; do
	echo "                                                "
	echo "would you like to apply?(y/n):                  "
	read i
	case "$i" in
		y|Y)
		echo "                                                "
		echo "enabled.                                        "
		setprop rtmixman_mpe 1
		sleep 2
		break
		;;
		n|N)
		echo "                                                "
		echo "disabled.                                       "
		setprop rtmixman_mpe 0
		sleep 2
		break
		;;
		q|Q)
		setprop rtmixman_locations null
		setprop rtmixman_sdvm null
		setprop rtmixman_rsb null
		setprop rtmixman_rtmix null
		echo "                                                "
		echo "                                       canceled."
		sleep 2
		main
		;;
		*)
		echo "                                                "
		echo "user typed an invalid option, please try again. "
		sleep 2
		;;
	esac
done
echo "                                                "
echo "all set!                                        "
install
}

install()
{
rtmixman_checkver=20130407
sleep 2
echo "                                                "
echo "setup is installing RTMixManager $rtmixman_checkver...    "
echo "================================================"
sleep 2
echo "gathering setup information...                  "
if [ "`getprop rtmixman_locations`" == i ]; then
	rtmixman_locations=i
	setprop rtmixman_locations null
elif [ "`getprop rtmixman_locations`" == x ]; then
	rtmixman_locations=x
	setprop rtmixman_locations null
else
	setprop rtmixman_locations null
	setprop rtmixman_sdvm null
	setprop rtmixman_rsb null
	setprop rtmixman_rtmix null
	setprop rtmixman_mpe null
	sleep 2
	echo "                                                "
	echo "failed to install properly.:(                   "
	echo "       ...please contact the developer for help."
	sleep 7
	main
fi
if [ "`getprop rtmixman_sdvm`" == 1 ]; then
	rtmixman_sdvm=1
	setprop rtmixman_sdvm null
elif [ "`getprop rtmixman_sdvm`" == 0 ]; then
	rtmixman_sdvm=0
	setprop rtmixman_sdvm null
else
	setprop rtmixman_locations null
	setprop rtmixman_sdvm null
	setprop rtmixman_rsb null
	setprop rtmixman_rtmix null
	setprop rtmixman_mpe null
	sleep 2
	echo "                                                "
	echo "failed to install properly.:(                   "
	echo "       ...please contact the developer for help."
	sleep 7
	main
fi
if [ "`getprop rtmixman_rsb`" == 1 ]; then
	rtmixman_rsb=1
	setprop rtmixman_rsb null
elif [ "`getprop rtmixman_rsb`" == 0 ]; then
	rtmixman_rsb=0
	setprop rtmixman_rsb null
else
	setprop rtmixman_locations null
	setprop rtmixman_sdvm null
	setprop rtmixman_rsb null
	setprop rtmixman_rtmix null
	setprop rtmixman_mpe null
	sleep 2
	echo "                                                "
	echo "failed to install properly.:(                   "
	echo "       ...please contact the developer for help."
	sleep 7
	main
fi
if [ "`getprop rtmixman_rtmix`" == 1 ]; then
	rtmixman_rtmix=1
	setprop rtmixman_rtmix null
elif [ "`getprop rtmixman_rtmix`" == 0 ]; then
	rtmixman_rtmix=0
	setprop rtmixman_rtmix null
else
	setprop rtmixman_locations null
	setprop rtmixman_sdvm null
	setprop rtmixman_rsb null
	setprop rtmixman_rtmix null
	setprop rtmixman_mpe null
	sleep 2
	echo "                                                "
	echo "failed to install properly.:(                   "
	echo "       ...please contact the developer for help."
	sleep 7
	main
fi
if [ "`getprop rtmixman_mpe`" == 1 ]; then
	rtmixman_mpe=1
	setprop rtmixman_mpe null
elif [ "`getprop rtmixman_mpe`" == 0 ]; then
	rtmixman_mpe=0
	setprop rtmixman_mpe null
else
	setprop rtmixman_locations null
	setprop rtmixman_sdvm null
	setprop rtmixman_rsb null
	setprop rtmixman_rtmix null
	setprop rtmixman_mpe null
	sleep 2
	echo "                                                "
	echo "failed to install properly.:(                   "
	echo "       ...please contact the developer for help."
	sleep 7
	main
fi
if [ "$rtmixman_sdvm" == 1 ] || [ "$rtmixman_rsb" == 1 ] || [ "$rtmixman_rtmix" == 1 ] || [ "$rtmixman_mpe" == 1 ]; then
	sync; busybox mount -o remount,rw /
	sync; busybox mount -o remount,rw rootfs
	sync; busybox mount -o remount,rw /system
	if [ ! -d "/sqlite_stmt_journals" ]; then
		echo "installing required components...               "
		mkdir /sqlite_stmt_journals
	fi
	if [ -e "/mnt/sdcard/rtmixtemp.sh" ]; then
		echo "removing existing old temporary data...         "
		rm /mnt/sdcard/rtmixtemp*.sh 2>/dev/null
	fi
	echo "copying new files...                            "
	sleep 7
	setprop rtmixman_checkver null
cat >> /mnt/sdcard/rtmixtemp.sh <<EOF
#!/system/bin/sh
#RTMixManager™ version $rtmixman_checkver
#Copyright 2013 LENAROX@xda
#version check.
setprop rtmixman_checkver $rtmixman_checkver
#read "readme.html" for more info.

EOF
	if [ "$rtmixman_rsb" == 1 ] || [ "$rtmixman_rtmix" == 1 ] || [ "$rtmixman_mpe" == 1 ]; then
cat >> /mnt/sdcard/rtmixtemp2.sh <<EOF
usrsettings
package installed at `date`.

NOTE: do NOT set any invalid values in usrsettings.
NOTE2: do NOT set 0 on interval types of values.
reminder: values are applied in realtime.

EOF
	fi
	if [ "$rtmixman_locations" == i ]; then
		rtmixman_location_specific=/system/etc/init.d/SS99RTMixManager
	elif [ "$rtmixman_locations" == x ]; then
		rtmixman_location_specific=/system/xbin/rtmixman
	else
		sleep 2
		echo "                                                "
		echo "failed to install properly.:(                   "
		echo "       ...please contact the developer for help."
		sleep 7
		main
	fi
cat >> /mnt/sdcard/rtmixtemp3.sh <<EOF
readme.html<br>
package installed at `date`.<br>
<br>
RTMixManager™ version $rtmixman_checkver<br>
Copyright 2013 LENAROX@xda<br>
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
DISCLAIMER<br>
Copyright 2013 LENAROX@xda<br>
<br>
   Licensed under the Apache License, Version 2.0 (the "License");<br>
   you may not use this file except in compliance with the License.<br>
   You may obtain a copy of the License at<br>
<br>
       http://www.apache.org/licenses/LICENSE-2.0<br>
<br>
   Unless required by applicable law or agreed to in writing, software<br>
   distributed under the License is distributed on an "AS IS" BASIS,<br>
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.<br>
   See the License for the specific language governing permissions and<br>
   limitations under the License.<br>
<br>
Games & Others Compatibility List>><br>
================================================<br>
AP boost:<br>
-this part of the engine handles the Dalvik VM.<br>
-fixes badly coded games to run a bit better.<br>
<br>
Rapid Storage Boost Technology 2.0 Unlocked:<br>
-this part of the engine fixes the I/O.<br>
-needed for games with high I/O interactivity.<br>
-reminder: 'Unlocked' refers to some features that are modified or deleted to gain more efficient performance of the original engine.<br>
-co-operates with AP boost<br>
<br>
Core Engine 2.2:<br>
-this part of the engine handles the Android™ lowmemorykiller.<br>
-it allows you to gain more free memory, while avoiding launcher redraws at the same time.<br>
-NOTE: this engine may not be a good decision for most stock ROMS, which are having more than 100mb RAM eating monster launchers crawling inside.<br>
<br>
MPEngine integrated:<br>
-this part of the engine dominates pretty much any lags you see, one-by-one.:)<br>
-some users reported that once this engine starts to kick in, the device spits out a massive gaming performance!<br>
<br>
<br>
some of these features may not be working if you havent chose them in installer.<br>
<br>
Do NOT rename or move RTMixManager™ folders and files to other directory.<br>
engine files are put in each specified folder for better use.<br>
currently active directories for RTMixManager™ are:<br>
 $rtmixman_location_specific<br>
 /system/etc/usrsettings<br>
if you accidentally delete or corrupt a file that is listed in here, youre in a big trouble;)<br>
<br>
<br>
<b>important note:</b><br>
in this version, the logging system is now supported!<br>
you can checkout the log at /data/rtmixmanager.log directory:D(only if you're using an init.d method)<br>
<br>
brief usrsettings information<br>
================================================<br>
first,<br>
<br>
NOTE: do NOT set any invalid values in usrsettings.<br>
NOTE2: do NOT set 0 on interval types of values.<br>
reminder: values are applied in realtime.<br>
<br>
settings currently available(may differ if its not a full mode.)<br>
<br>
rsb_refresh_sec_interval<br>
-it sets rsb engine to cycle every 'n' seconds.<br>
-recommended to increase this value to save more battery.<br>
-decreasing down value is limited to 1.<br>
-default value is 4.<br>
<br>
core_refresh_sec_interval<br>
-it sets core engine to cycle every 'n' seconds.<br>
-recommended to leave this value default since it regenerates processes realtime.<br>
-decreasing down value is limited to 1.<br>
-default value is 4.<br>
<br>
core_minfree_limiter_strength<br>
-this one sets core engine aggressivity.<br>
-it has 3 options:<br>
0)multitasking(bit risky)<br>
1)balance(not yet solved)<br>
2)performance(lags may occur)<br>
-default value is 1.<br>
<br>
mpe9x_refresh_sec_interval<br>
-it sets mpe9x engine to cycle every 'n' seconds.<br>
-this one is also associated with the engine aggressivity.<br>
-recommended to increase this value to save more battery.<br>
-decreasing down value is limited to 2.<br>
-default value is 4.<br>
<br>
half_registered_ram_interval<br>
-it sets a limit of division by 'n' on realtime cachesize and freememory percentage.<br>
-recommended to increase this value to save more battery.<br>
-decreasing down value is limited to 1.<br>
-default value is 6.<br>
<br>
quarter_registered_ram_interval<br>
-it sets a limit of division by 'n' on calculated half_registered_ram_interval percentage.<br>
-recommended to decrease this value to flush harder only when needed.<br>
-decreasing down value is limited to 1.<br>
-default value is 2.<br>
<br>
enable_flush_timing<br>
-this one multiplies mpe9x_refresh_sec_interval by 2 internally.<br>
-it enables the dedicated engine to act like a conservative governor.<br>
-but there was some known problems that slowing down timing may lead to unintended lags,<br>
-and more battery consumption.<br>
-recommended to leave this value default(off).<br>
-default value is 0.<br>
<br>
following list shows installed engine parts:<br>
================================================<br>
EOF
	if [ "$rtmixman_locations" == i ]; then
cat >> /mnt/sdcard/rtmixtemp.sh <<EOF
#init.d mode.
exec > /dev/null 2>&1
if [ "\$1" != BG ]; then
	\$0 BG & exit 0
fi

#start logging.
(
echo "logging started on \`date\`"
echo "if you see nothing below, it means the script is working fine:)"

EOF
	elif [ "$rtmixman_locations" == x ]; then
cat >> /mnt/sdcard/rtmixtemp.sh <<EOF
#xbin mode.
echo "type 'rtmixman' in terminal emulator, whenever you wish to run this engine!"
echo "engine started on \`date\`"
echo "if you see nothing below, it means the script is working fine:)"

EOF
	else
		sleep 2
		echo "                                                "
		echo "failed to install properly.:(                   "
		echo "       ...please contact the developer for help."
		sleep 7
		main
	fi
	if [ "$rtmixman_sdvm" == 1 ]; then
cat >> /mnt/sdcard/rtmixtemp.sh <<EOF
#AP boost
MFK=\`cat /proc/sys/vm/min_free_kbytes\`
TOTALMEM=\`free | awk '{ print \$2 }' | sed -n 2p\`
REALTOTALMEM=\$((\$TOTALMEM-\$MFK))
STATIC=\$((\$REALTOTALMEM/6144))
if getprop | grep -q dalvik.vm.heapgrowthlimit; then
	setprop dalvik.vm.heapsize "\$STATIC"m
	setprop dalvik.vm.heapgrowthlimit "\$STATIC"m
	if [ "\$REALTOTALMEM" -le 524288 ]; then
		setprop dalvik.vm.heapstartsize 5m
	elif [ "\$REALTOTALMEM" -le 1048576 ]; then
		setprop dalvik.vm.heapstartsize 8m
	elif [ "\$REALTOTALMEM" -le 2097152 ]; then
		setprop dalvik.vm.heapstartsize 16m
	else
		setprop dalvik.vm.heapstartsize 16m
	fi
else
	setprop dalvik.vm.heapsize "\$STATIC"m
fi

EOF
cat >> /mnt/sdcard/rtmixtemp3.sh <<EOF
AP boost<br>
EOF
	elif [ "$rtmixman_sdvm" == 0 ]; then
		sleep 0
	else
		sleep 2
		echo "                                                "
		echo "failed to install properly.:(                   "
		echo "       ...please contact the developer for help."
		sleep 7
		main
	fi
	if [ "$rtmixman_rsb" == 1 ]; then
cat >> /mnt/sdcard/rtmixtemp.sh <<EOF
#Rapid Storage Boost Technology 2.0 Unlocked
(while true; do
	MFK=\`cat /proc/sys/vm/min_free_kbytes\`
	TOTALMEM=\`free | awk '{ print \$2 }' | sed -n 2p\`
	REALTOTALMEM=\$((\$TOTALMEM-\$MFK))
	if getprop | grep -q dalvik.vm.heapgrowthlimit; then
		dalvikvmheapgrowthlimit=\`getprop dalvik.vm.heapgrowthlimit | sed 's/m//'\`
		dalvik_ratio=\$((\$REALTOTALMEM/\$dalvikvmheapgrowthlimit))
		result=\$((102400/\$dalvik_ratio))
		if [ -e "/proc/sys/vm/dirty_ratio" ]; then
			if [ \`cat /proc/sys/vm/dirty_ratio\` != "\$result" ]; then
				echo "\$result" > /proc/sys/vm/dirty_ratio
			fi
		fi
		if [ -e "/proc/sys/vm/dirty_background_ratio" ]; then
			if [ \`cat /proc/sys/vm/dirty_background_ratio\` != "\$result" ]; then
				echo "\$result" > /proc/sys/vm/dirty_background_ratio
			fi
		fi
	else
		dalvikvmheapsize=\`getprop dalvik.vm.heapsize | sed 's/m//'\`
		dalvik_ratio=\$((\$REALTOTALMEM/\$dalvikvmheapsize))
		result=\$((102400/\$dalvik_ratio))
		if [ -e "/proc/sys/vm/dirty_ratio" ]; then
			if [ \`cat /proc/sys/vm/dirty_ratio\` != "\$result" ]; then
				echo "\$result" > /proc/sys/vm/dirty_ratio
			fi
		fi
		if [ -e "/proc/sys/vm/dirty_background_ratio" ]; then
			if [ \`cat /proc/sys/vm/dirty_background_ratio\` != "\$result" ]; then
				echo "\$result" > /proc/sys/vm/dirty_background_ratio
			fi
		fi
	fi
	LEASES=\`cat /proc/sys/fs/lease-break-time\`
	L2W=\$((\$LEASES*100))
	if [ -e "/proc/sys/vm/dirty_writeback_centisecs" ]; then
		if [ \`cat /proc/sys/vm/dirty_writeback_centisecs\` != "\$L2W" ]; then
			echo "\$L2W" > /proc/sys/vm/dirty_writeback_centisecs
		fi
	fi
	if [ -e "/proc/sys/vm/dirty_expire_centisecs" ]; then
		if [ \`cat /proc/sys/vm/dirty_expire_centisecs\` != "\$L2W" ]; then
			echo "\$L2W" > /proc/sys/vm/dirty_expire_centisecs
		fi
	fi
	rsb_refresh_sec_interval=\`cat /system/etc/usrsettings | grep rsb_refresh_sec_interval | sed 's/rsb_refresh_sec_interval=//'\`
	if [ "\$rsb_refresh_sec_interval" -le 0 ]; then
		rsb_refresh_sec_interval=4
	fi 2>/dev/null
	sleep \$rsb_refresh_sec_interval
done &)

EOF
		if [ -s "/mnt/sdcard/rtmixtemp2.sh" ]; then
cat >> /mnt/sdcard/rtmixtemp2.sh <<EOF
Rapid Storage Boost Technology 2.0 Unlocked
rsb_refresh_sec_interval=4

EOF
		fi
cat >> /mnt/sdcard/rtmixtemp3.sh <<EOF
Rapid Storage Boost Technology 2.0 Unlocked<br>
EOF
	elif [ "$rtmixman_rsb" == 0 ]; then
		sleep 0
	else
		sleep 2
		echo "                                                "
		echo "failed to install properly.:(                   "
		echo "       ...please contact the developer for help."
		sleep 7
		main
	fi
	if [ "$rtmixman_rtmix" == 1 ]; then
cat >> /mnt/sdcard/rtmixtemp.sh <<EOF
#Core Engine 2.2
#alternative to renice processes method.
setprop ENFORCE_PROCESS_LIMIT false
#RT-Styled engine.
(while true; do
	if [ -e "/sys/module/lowmemorykiller/parameters/adj" ]; then
		if [ "\`cat /proc/\`pgrep launcher\`/oom_adj\`" != -16 ] || [ "\`cat /proc/\`pgrep acore\`/oom_adj\`" != -12 ]; then
			echo "-16" > /proc/\`pgrep launcher\`/oom_adj
			echo "-12" > /proc/\`pgrep acore\`/oom_adj
			if [ \`cat /sys/module/lowmemorykiller/parameters/adj\` != 0,1,2,6,9,15 ]; then
				echo "0,1,2,6,9,15" > /sys/module/lowmemorykiller/parameters/adj
			fi
		fi 2>/dev/null
	fi
	core_minfree_limiter_strength=\`cat /system/etc/usrsettings | grep core_minfree_limiter_strength | sed 's/core_minfree_limiter_strength=//'\`
	MFK=\`cat /proc/sys/vm/min_free_kbytes\`
	TOTALMEM=\`free | awk '{ print \$2 }' | sed -n 2p\`
	REALTOTALMEM=\$((\$TOTALMEM-\$MFK))
	cachepage=\$((\$REALTOTALMEM/24))
	lowpage=\$((\$MFK/4))
	if [ -e "/sys/module/lowmemorykiller/parameters/minfree" ]; then
		if [ "\$core_minfree_limiter_strength" == 0 ]; then
			if [ \`cat /sys/module/lowmemorykiller/parameters/minfree\` != "\$lowpage,\$lowpage,\$cachepage,\$lowpage,\$lowpage,\$lowpage" ]; then
				echo "\$lowpage,\$lowpage,\$cachepage,\$lowpage,\$lowpage,\$lowpage" > /sys/module/lowmemorykiller/parameters/minfree
			fi
		elif [ "\$core_minfree_limiter_strength" == 1 ]; then
			if [ \`cat /sys/module/lowmemorykiller/parameters/minfree\` != "\$lowpage,\$lowpage,\$cachepage,\$lowpage,\$lowpage,\$cachepage" ]; then
				echo "\$lowpage,\$lowpage,\$cachepage,\$lowpage,\$lowpage,\$cachepage" > /sys/module/lowmemorykiller/parameters/minfree
			fi
		elif [ "\$core_minfree_limiter_strength" == 2 ]; then
			if [ \`cat /sys/module/lowmemorykiller/parameters/minfree\` != "\$lowpage,\$cachepage,\$cachepage,\$lowpage,\$lowpage,\$cachepage" ]; then
				echo "\$lowpage,\$cachepage,\$cachepage,\$lowpage,\$lowpage,\$cachepage" > /sys/module/lowmemorykiller/parameters/minfree
			fi
		else
			if [ \`cat /sys/module/lowmemorykiller/parameters/minfree\` != "\$lowpage,\$lowpage,\$cachepage,\$lowpage,\$lowpage,\$cachepage" ]; then
				echo "\$lowpage,\$lowpage,\$cachepage,\$lowpage,\$lowpage,\$cachepage" > /sys/module/lowmemorykiller/parameters/minfree
			fi
		fi 2>/dev/null
	fi
	core_refresh_sec_interval=\`cat /system/etc/usrsettings | grep core_refresh_sec_interval | sed 's/core_refresh_sec_interval=//'\`
	if [ "\$core_refresh_sec_interval" -le 0 ]; then
		core_refresh_sec_interval=4
	fi 2>/dev/null
	sleep \$core_refresh_sec_interval
done &)

EOF
		if [ -s "/mnt/sdcard/rtmixtemp2.sh" ]; then
cat >> /mnt/sdcard/rtmixtemp2.sh <<EOF
Core Engine 2.2
core_refresh_sec_interval=4
core_minfree_limiter_strength=1

EOF
		fi
cat >> /mnt/sdcard/rtmixtemp3.sh <<EOF
Core Engine 2.2<br>
EOF
	elif [ "$rtmixman_rtmix" == 0 ]; then
		sleep 0
	else
		sleep 2
		echo "                                                "
		echo "failed to install properly.:(                   "
		echo "       ...please contact the developer for help."
		sleep 7
		main
	fi
	if [ "$rtmixman_mpe" == 1 ]; then
cat >> /mnt/sdcard/rtmixtemp.sh <<EOF
#MPEngine integrated
#MPEngine 9X
(while true; do
	mpe9x_refresh_sec_interval=\`cat /system/etc/usrsettings | grep mpe9x_refresh_sec_interval | sed 's/mpe9x_refresh_sec_interval=//'\`
	if [ "\$mpe9x_refresh_sec_interval" -le 1 ]; then
		mpe9x_refresh_sec_interval=4
	fi 2>/dev/null
	SKIP=\$((\$mpe9x_refresh_sec_interval/2))
	SLUG=\$((\$mpe9x_refresh_sec_interval*2))
	MFK=\`cat /proc/sys/vm/min_free_kbytes\`
	FREEMEM=\`free | awk '{ print \$4 }' | sed -n 2p\`
	CACHESIZE=\`cat /proc/meminfo | grep Cached | awk '{print \$2}' | sed -n 1p\`
	TOTALMEM=\`free | awk '{ print \$2 }' | sed -n 2p\`
	REALTOTALMEM=\$((\$TOTALMEM-\$MFK))
	MEMINUSE=\$((\$CACHESIZE+\$FREEMEM))
	half_registered_ram_interval=\`cat /system/etc/usrsettings | grep half_registered_ram_interval | sed 's/half_registered_ram_interval=//'\`
	if [ "\$half_registered_ram_interval" -le 0 ]; then
		half_registered_ram_interval=6
	fi 2>/dev/null
	quarter_registered_ram_interval=\`cat /system/etc/usrsettings | grep quarter_registered_ram_interval | sed 's/quarter_registered_ram_interval=//'\`
	if [ "\$quarter_registered_ram_interval" -le 0 ]; then
		quarter_registered_ram_interval=2
	fi 2>/dev/null
	enable_flush_timing=\`cat /system/etc/usrsettings | grep enable_flush_timing | sed 's/enable_flush_timing=//'\`
	if [ "\$enable_flush_timing" != 0 ] && [ "\$enable_flush_timing" != 1 ]; then
		enable_flush_timing=0
	fi 2>/dev/null
	DEADLINE=\$((\$REALTOTALMEM-\$MEMINUSE))
	DEADEND=\$((\$DEADLINE/\$half_registered_ram_interval))
	DEADEND2=\$((\$DEADEND/\$quarter_registered_ram_interval))
	if [ "\$FREEMEM" -le "\$MFK" ]; then
		if [ "\$enable_flush_timing" == 0 ]; then
			busybox sync; echo "1" > /proc/sys/vm/drop_caches
			sleep \$SKIP
			busybox sync; echo "1" > /proc/sys/vm/drop_caches
			sleep \$SKIP
		elif [ "\$enable_flush_timing" == 1 ]; then
			busybox sync; echo "1" > /proc/sys/vm/drop_caches
			sleep \$SKIP
			busybox sync; echo "1" > /proc/sys/vm/drop_caches
			sleep \$SKIP
			busybox sync; echo "1" > /proc/sys/vm/drop_caches
			sleep \$SKIP
			busybox sync; echo "1" > /proc/sys/vm/drop_caches
			sleep \$SKIP
		else
			busybox sync; echo "1" > /proc/sys/vm/drop_caches
			sleep \$SKIP
			busybox sync; echo "1" > /proc/sys/vm/drop_caches
			sleep \$SKIP
		fi
	elif [ "\$FREEMEM" -gt "\$MFK" ] && [ "\$FREEMEM" -le "\$DEADEND2" ]; then
		if [ "\$enable_flush_timing" == 0 ]; then
			busybox sync; echo "1" > /proc/sys/vm/drop_caches
			sleep \$SKIP
			busybox sync; echo "1" > /proc/sys/vm/drop_caches
			sleep \$SKIP
		elif [ "\$enable_flush_timing" == 1 ]; then
			busybox sync; echo "1" > /proc/sys/vm/drop_caches
			sleep \$SKIP
			busybox sync; echo "1" > /proc/sys/vm/drop_caches
			sleep \$SKIP
			busybox sync; echo "1" > /proc/sys/vm/drop_caches
			sleep \$SKIP
			busybox sync; echo "1" > /proc/sys/vm/drop_caches
			sleep \$SKIP
		else
			busybox sync; echo "1" > /proc/sys/vm/drop_caches
			sleep \$SKIP
			busybox sync; echo "1" > /proc/sys/vm/drop_caches
			sleep \$SKIP
		fi
	elif [ "\$FREEMEM" -gt "\$DEADEND2" ] && [ "\$FREEMEM" -le "\$DEADEND" ]; then
		if [ "\$enable_flush_timing" == 0 ]; then
			busybox sync; echo "1" > /proc/sys/vm/drop_caches
			sleep \$mpe9x_refresh_sec_interval
		elif [ "\$enable_flush_timing" == 1 ]; then
			busybox sync; echo "1" > /proc/sys/vm/drop_caches
			sleep \$mpe9x_refresh_sec_interval
			busybox sync; echo "1" > /proc/sys/vm/drop_caches
			sleep \$mpe9x_refresh_sec_interval
		else
			busybox sync; echo "1" > /proc/sys/vm/drop_caches
			sleep \$mpe9x_refresh_sec_interval
		fi
	elif [ "\$FREEMEM" -gt "\$DEADEND" ] && [ "\$FREEMEM" -le "\$MEMINUSE" ]; then
		if [ "\$enable_flush_timing" == 0 ]; then
			sleep \$mpe9x_refresh_sec_interval
		elif [ "\$enable_flush_timing" == 1 ]; then
			sleep \$SLUG
		else
			sleep \$mpe9x_refresh_sec_interval
		fi
	else
		if [ "\$enable_flush_timing" == 0 ]; then
			sleep \$mpe9x_refresh_sec_interval
		elif [ "\$enable_flush_timing" == 1 ]; then
			sleep \$SLUG
		else
			sleep \$mpe9x_refresh_sec_interval
		fi
	fi
done &)

EOF
		if [ -s "/mnt/sdcard/rtmixtemp2.sh" ]; then
cat >> /mnt/sdcard/rtmixtemp2.sh <<EOF
MPEngine integrated
mpe9x_refresh_sec_interval=4
half_registered_ram_interval=6
quarter_registered_ram_interval=2
enable_flush_timing=0

EOF
		fi
cat >> /mnt/sdcard/rtmixtemp3.sh <<EOF
MPEngine integrated<br>
EOF
	elif [ "$rtmixman_mpe" == 0 ]; then
		sleep 0
	else
		sleep 2
		echo "                                                "
		echo "failed to install properly.:(                   "
		echo "       ...please contact the developer for help."
		sleep 7
		main
	fi
	if [ "$rtmixman_locations" == i ]; then
cat >> /mnt/sdcard/rtmixtemp.sh <<EOF
#finish logging.
) 2>&1 | tee /data/rtmixmanager.log

EOF
	elif [ "$rtmixman_locations" == x ]; then
		sleep 0
	else
		sleep 2
		echo "                                                "
		echo "failed to install properly.:(                   "
		echo "       ...please contact the developer for help."
		sleep 7
		main
	fi
cat >> /mnt/sdcard/rtmixtemp.sh <<EOF
#xda: http://forum.xda-developers.com/showthread.php?t=2076101
#matcl: http://matcl.com/?m=bbs&bid=imbeded&uid=130014
#droid-hive: http://droid-hive.com/index.php?/topic/1674-20130325ram-scriptinstallerdalvik-booster-lite-v2rtmixmanager%E2%84%A2/
#blog: http://blog.naver.com/hoholee12
#sourcecode: https://github.com/lenarox/rtmixproject
#email: hoholee12@naver.com
EOF
	if [ -s "/mnt/sdcard/rtmixtemp2.sh" ]; then
cat >> /mnt/sdcard/rtmixtemp2.sh <<EOF
xda: http://forum.xda-developers.com/showthread.php?t=2076101
matcl: http://matcl.com/?m=bbs&bid=imbeded&uid=130014
droid-hive: http://droid-hive.com/index.php?/topic/1674-20130325ram-scriptinstallerdalvik-booster-lite-v2rtmixmanager%E2%84%A2/
blog: http://blog.naver.com/hoholee12
sourcecode: https://github.com/lenarox/rtmixproject
email: hoholee12@naver.com
EOF
	fi
cat >> /mnt/sdcard/rtmixtemp3.sh <<EOF
<br>
xda: <a href="http://forum.xda-developers.com/showthread.php?t=2076101">http://forum.xda-developers.com/showthread.php?t=2076101</a><br>
matcl: <a href="http://matcl.com/?m=bbs&bid=imbeded&uid=130014">http://matcl.com/?m=bbs&bid=imbeded&uid=130014</a><br>
droid-hive: <a href="http://droid-hive.com/index.php?/topic/1674-20130325ram-scriptinstallerdalvik-booster-lite-v2rtmixmanager%E2%84%A2/">http://droid-hive.com/index.php?/topic/1674-20130325ram-scriptinstallerdalvik-booster-lite-v2rtmixmanager%E2%84%A2/</a><br>
blog: <a href="http://blog.naver.com/hoholee12">http://blog.naver.com/hoholee12</a><br>
sourcecode: <a href="https://github.com/lenarox/rtmixproject">https://github.com/lenarox/rtmixproject</a><br>
email: hoholee12@naver.com<br>
<br>
EOF
	if [ -s "/mnt/sdcard/rtmixtemp.sh" ]; then
		if [ "$rtmixman_locations" == i ]; then
			cp /mnt/sdcard/rtmixtemp.sh /system/etc/init.d/SS99RTMixManager
			chown 0.0 /system/etc/init.d/SS99RTMixManager
			chmod 777 /system/etc/init.d/SS99RTMixManager
		elif [ "$rtmixman_locations" == x ]; then
			cp /mnt/sdcard/rtmixtemp.sh /system/xbin/rtmixman
			chown 0.0 /system/xbin/rtmixman
			chmod 777 /system/xbin/rtmixman
		fi
	fi
	if [ -s "/mnt/sdcard/rtmixtemp2.sh" ]; then
		cp /mnt/sdcard/rtmixtemp2.sh /system/etc/usrsettings
		chown 0.0 /system/etc/usrsettings
		chmod 777 /system/etc/usrsettings
	fi
	if [ -s "/mnt/sdcard/rtmixtemp3.sh" ]; then
		cp /mnt/sdcard/rtmixtemp3.sh /system/etc/readme.html
		chown 0.0 /system/etc/readme.html
		chmod 777 /system/etc/readme.html
	fi
	if [ "$rtmixman_locations" == i ]; then
		rtmixman_location_specific=/system/etc/init.d/SS99RTMixManager
	elif [ "$rtmixman_locations" == x ]; then
		rtmixman_location_specific=/system/xbin/rtmixman
	else
		sleep 2
		echo "                                                "
		echo "failed to install properly.:(                   "
		echo "       ...please contact the developer for help."
		sleep 7
		main
	fi
	if [ -s "$rtmixman_location_specific" ] && [ -s "/system/etc/usrsettings" ] && [ -s "/system/etc/readme.html" ]; then
		setprop rtmixman_checkver $rtmixman_checkver
		echo "removing temporary backup...                    "
		rm /mnt/sdcard/rtmixtemp.sh 2>/dev/null
		rm /mnt/sdcard/rtmixtemp2.sh 2>/dev/null
		rm /mnt/sdcard/rtmixtemp3.sh 2>/dev/null
		rm -r /sqlite_stmt_journals 2>/dev/null
		echo "                                                "
		echo "                                       complete."
		sleep 2
		echo "                                                "
		echo "Android needs to be restarted,                  "
		echo "                     ...in order to take affect."
		sleep 2
		fastreboot
	else
		sleep 2
		echo "                                                "
		echo "failed to install properly.:(                   "
		echo "       ...please contact the developer for help."
		sleep 7
		main
	fi
else
	setprop rtmixman_locations null
	setprop rtmixman_sdvm null
	setprop rtmixman_rsb null
	setprop rtmixman_rtmix null
	setprop rtmixman_mpe null
	sleep 2
	echo "                                                "
	echo "there is no engine selected to install.         "
	while true; do
		echo "            ...(r)einstall, or return to (m)enu?"
		read i
		case "$i" in
			r|R)
			sleep 2
			userinit
			;;
			m|M)
			sleep 2
			main
			;;
			*)
			echo "                                                "
			echo "user typed an invalid option, please try again. "
			sleep 2
			;;
		esac
	done
fi
}

rtmixman_checkver=20130407
echo "RTMixManager™ version $rtmixman_checkver packages installer."
echo "Copyright 2013 LENAROX@xda"
sleep 2
echo ""
echo "this engine will solve any lags and crashes on games, heavy apps and so on."
echo "which most of the mid-range android gamers have always wanted;)"
echo "rock your RAM Manager like a Windows NT!!!(da well known BOSS of RAM Management), you know what i mean.:p"
echo "ATTENTION!!! this engine requires the latest busybox version FROM stericson, installed to run properly."
echo "reminder: this engine is designed to run in the background realtime(yeah, RT lol:p) with the android ram management,"
echo "therefore it should NOT be used with other script applications."
sleep 2
echo ""
echo "thanks to many xda devs who have helped me to develop better codes!"
echo "thanks to chainfire for touchscreen responsiveness tweak."
echo "thanks to shantam for Netweaks."
echo "thanks to professionals from stackoverflow.com who gave me some good advices!"
echo "thanks to mv style for lupus kernel script."
echo "thanks to zeppelinrox for the script design, and the bugfix!"
echo "thanks to gu5t3r for the bugfix:)"
sleep 2
echo ""
echo "dirty hack"
echo "http://www.gentoo-wiki.info/Gigabyte_GA-G33M-S2H"
echo "http://www.sysxperts.com/home/announce/vmdirtyratioandvmdirtybackgroundratio"
sleep 2
echo ""
echo "android lmk"
echo "http://dalinaum-kr.tumblr.com/post/4528344482/android-low-memory-killer"
sleep 2
echo ""
echo "do not steal this script installer or the script that is being installed by this installer."
echo "you must always ask me for any permission thats related to this script,"
echo "and give a credit by linking to this thread: http://forum.xda-developers.com/showthread.php?t=2076101"
sleep 7
if [ \`busybox id -u\` != 0 ]; then
	echo "you're not running this script as root!         "
	while true; do
		echo "continue?(y/n):                                 "
		read i
		case "$i" in
			y|Y)
			sleep 2
			main
			;;
			n|N)
			echo "                                                "
			echo "exiting...                                      "
			exit
			;;
			*)
			echo "                                                "
			echo "user typed an invalid option, please try again. "
			sleep 2
			;;
		esac
	done
else
	main
fi

#xda: http://forum.xda-developers.com/showthread.php?t=2076101
#matcl: http://matcl.com/?m=bbs&bid=imbeded&uid=130014
#droid-hive: http://droid-hive.com/index.php?/topic/1674-20130325ram-scriptinstallerdalvik-booster-lite-v2rtmixmanager%E2%84%A2/
#blog: http://blog.naver.com/hoholee12
#sourcecode: https://github.com/lenarox/rtmixproject
#email: hoholee12@naver.com
