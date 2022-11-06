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
echo "1-2" > /dev/cpuset/audio-app/cpus
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
##Little
for little in /sys/devices/system/cpu/cpu[0,1,2,3]/cpufreq
do
  echo "1" > $little/schedutil/pl
done
##Big
for big in /sys/devices/system/cpu/cpu[4,5,6,7]/cpufreq
do
  echo "1" > $big/schedutil/pl
done

# Enable Core control
for cctl in /sys/devices/system/cpu/*/core_ctl
do
  chmod 666 $cctl/enable
  echo 1 > $cctl/enable
  chmod 444 $cctl/enable
done

# Top app
echo "0" > /dev/stune/top-app/schedtune.boost
echo "0" > /dev/stune/top-app/schedtune.sched_boost_no_override

# Gpu
MIN=$(cat /sys/class/kgsl/kgsl-3d0/min_pwrlevel)
echo "1000" > /sys/class/kgsl/kgsl-3d0/idle_timer
echo "$MIN" > /sys/class/kgsl/kgsl-3d0/default_pwrlevel
echo "1" > /sys/class/kgsl/kgsl-3d0/throttling
echo "1" > /sys/class/kgsl/kgsl-3d0/bus_split
echo "0" > /sys/class/kgsl/kgsl-3d0/force_no_nap
echo "0" > /sys/class/kgsl/kgsl-3d0/force_rail_on
echo "0" > /sys/class/kgsl/kgsl-3d0/force_bus_on
echo "0" > /sys/class/kgsl/kgsl-3d0/force_clk_on

# Entropy
echo "128" > /proc/sys/kernel/random/read_wakeup_threshold
echo "1024" > /proc/sys/kernel/random/write_wakeup_threshold

# Report
sed -Ei 's/^description=(\[.*][[:space:]]*)?/description=[ 🥶 Balance Mode... ] /g' "/data/adb/modules/ReWrite/module.prop"
am start -a android.intent.action.MAIN -e toasttext "🥶 Balance Mode..." -n bellavita.toast/.MainActivity
