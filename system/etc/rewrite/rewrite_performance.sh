#!/system/bin/sh

# Disable Thermal
stop thermal-engine
stop vendor.thermal-engine

# Core Control
##cpuset
echo "0-7" > /dev/cpuset/foreground/cpus
echo "0-7" > /dev/cpuset/top-app/cpus
echo "0-7" > /dev/cpuset/camera-daemon/cpus
echo "0-7" > /dev/cpuset/restricted/cpus
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
echo "1" > /sys/devices/system/cpu/cpu6/online
chmod 444 /sys/devices/system/cpu/cpu6/online
chmod 644 /sys/devices/system/cpu/cpu7/online
echo "1" > /sys/devices/system/cpu/cpu7/online
chmod 444 /sys/devices/system/cpu/cpu7/online

# Disable Core ctl / hotplug
for cctl in /sys/devices/system/cpu/*/core_ctl ; do
    chmod 666 $cctl/enable
	echo 0 > $cctl/enable
	chmod 444 $cctl/enable
done

# Lpm
echo "100" > /sys/module/lpm_levels/parameters/bias_hyst

# Foreground
echo "70" > /dev/stune/foreground/schedtune.boost
echo "1" > /dev/stune/foreground/schedtune.sched_boost_no_override

# Top app
echo "70" > /dev/stune/top-app/schedtune.boost
echo "1" > /dev/stune/top-app/schedtune.sched_boost_no_override

# Gpu
echo "120000" > /sys/class/kgsl/kgsl-3d0/idle_timer
echo "1000" > /sys/class/kgsl/kgsl-3d0/pmqos_active_latency
echo "0" > /sys/class/kgsl/kgsl-3d0/throttling
echo "2" > /sys/class/kgsl/kgsl-3d0/default_pwrlevel
echo "1" > /sys/class/kgsl/kgsl-3d0/force_no_nap
echo "1" > /sys/class/kgsl/kgsl-3d0/force_rail_on
echo "1" > /sys/class/kgsl/kgsl-3d0/force_bus_on
echo "1" > /sys/class/kgsl/kgsl-3d0/force_clk_on

# Entropy
echo "512" > /proc/sys/kernel/random/read_wakeup_threshold
echo "2048" > /proc/sys/kernel/random/write_wakeup_threshold

# Report
sed -Ei 's/^description=(\[.*][[:space:]]*)?/description=[ 🥵 Performance Mode... ] /g' "/data/adb/modules/ReWrite/module.prop"
am start -a android.intent.action.MAIN -e toasttext "🥵 Performance Mode..." -n bellavita.toast/.MainActivity
