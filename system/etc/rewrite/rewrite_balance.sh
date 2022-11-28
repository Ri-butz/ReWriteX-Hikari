#!/system/bin/sh

# Enable Thermal
start thermal-engine
start vendor.thermal-engine

# Core Control
##cpuset
echo "0-5" > /dev/cpuset/foreground/cpus
echo "0-5" > /dev/cpuset/top-app/cpus
echo "0-5" > /dev/cpuset/camera-daemon/cpus
echo "0-5" > /dev/cpuset/restricted/cpus
echo "0-3" > /dev/cpuset/audio-app/cpus
echo "0-3" > /dev/cpuset/background/cpus
echo "0-3" > /dev/cpuset/system-background/cpus
##little
chmod 644 /sys/devices/system/cpu/cpu0/online
echo "1" > /sys/devices/system/cpu/cpu0/online
chmod 444 /sys/devices/system/cpu/cpu0/online
chmod 644 /sys/devices/system/cpu/cpu1/online
echo "1" > /sys/devices/system/cpu/cpu1/online
chmod 444 /sys/devices/system/cpu/cpu1/online
chmod 644 /sys/devices/system/cpu/cpu2/online
echo "1" > /sys/devices/system/cpu/cpu2/online
chmod 444 /sys/devices/system/cpu/cpu2/online
chmod 644 /sys/devices/system/cpu/cpu3/online
echo "1" > /sys/devices/system/cpu/cpu3/online
chmod 444 /sys/devices/system/cpu/cpu3/online
##big
chmod 644 /sys/devices/system/cpu/cpu4/online
echo "1" > /sys/devices/system/cpu/cpu4/online
chmod 444 /sys/devices/system/cpu/cpu4/online
chmod 644 /sys/devices/system/cpu/cpu5/online
echo "1" > /sys/devices/system/cpu/cpu5/online
chmod 444 /sys/devices/system/cpu/cpu5/online
chmod 644 /sys/devices/system/cpu/cpu6/online
echo "0" > /sys/devices/system/cpu/cpu6/online
chmod 444 /sys/devices/system/cpu/cpu6/online
chmod 644 /sys/devices/system/cpu/cpu7/online
echo "0" > /sys/devices/system/cpu/cpu7/online
chmod 444 /sys/devices/system/cpu/cpu7/online

# Cpu power limit
for cpl in /sys/devices/system/cpu/cpu*/cpufreq/schedutil
do
  echo "1" > $cpl/pl
done

# Core ctl
for cctl in /sys/devices/system/cpu/*/core_ctl
do
  chmod 666 $cctl/enable
  echo 1 > $cctl/enable
  chmod 444 $cctl/enable
done

# Top app
echo "0" > /dev/stune/top-app/schedtune.boost
echo "0" > /dev/stune/top-app/schedtune.sched_boost_no_override

# GPU settings
for gpu in /sys/class/kgsl/kgsl-3d0
do
  echo "1" > $gpu/throttling
  echo "1" > $gpu/bus_split
  echo "0" > $gpu/force_clk_on
  echo "0" > $gpu/force_bus_on
  echo "0" > $gpu/force_rail_on
  echo "0" > $gpu/force_no_nap
  echo "16" > $gpu/devfreq/polling_interval
  echo "80" > $gpu/idle_timer
done

# Sched boost
echo "0" > /proc/sys/kernel/sched_boost

# Fs
echo "50" > /proc/sys/fs/lease-break-time

# Entropy
echo "128" > /proc/sys/kernel/random/read_wakeup_threshold
echo "1024" > /proc/sys/kernel/random/write_wakeup_threshold

# Report
sed -Ei 's/^description=(\[.*][[:space:]]*)?/description=[ ❄️ Balance Mode... ] /g' "/data/adb/modules/ReWrite/module.prop"
am start -a android.intent.action.MAIN -e toasttext "❄️ Balance Mode..." -n bellavita.toast/.MainActivity
