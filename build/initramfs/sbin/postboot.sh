#!/bin/sh
# Postboot script - for tweaks after the end of init.rc

# Fake init.d support via busybox
# busybox in /bin is used because it seems to be reliable
[ -d /system/etc/init.d ] && /bin/busybox run-parts /system/etc/init.d

# Reset internal storage readahead; may have been changed by some dumbfuck's init.d script
# 179:0 corresponds to mmcblk0. On SCH-I500, this is eMMC (/data etc.) and NOT /sdcard
echo 128 > /sys/devices/virtual/bdi/179:0/read_ahead_kb

# Set sdcard readahead on the correct device
# 4096 may be too high latency. 1024 is next fastest value, even better than 2048 or 3072
SDRA=/sys/devices/virtual/bdi/179:8/read_ahead_kb
[ $(cat $SDRA) -eq 128 ] && echo 1024 > $SDRA

# Remove /sbin/res after 30 minutes, in case it's needed after boot for some reason
sleep 1800; /bin/busybox rm -rf /sbin/res

# No need to include boot animation killer hack if the boot animation is named playlogos1
# or samsungani because the ROM kills either automatically
