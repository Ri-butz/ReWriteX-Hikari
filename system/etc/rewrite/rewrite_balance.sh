#!/system/bin/sh

# Enable Thermal
su -c start thermal-engine
su -c start vendor.thermal-engine

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

# Enable core control
echo "1" > /sys/devices/system/cpu/cpu0/core_ctl/enable

# Lpm
echo "25" > /sys/module/lpm_levels/parameters/bias_hyst

# Foreground
echo "0" > /dev/stune/foreground/schedtune.boost
echo "0" > /dev/stune/foreground/schedtune.sched_boost_no_override

# Top app
echo "0" > /dev/stune/top-app/schedtune.boost
echo "0" > /dev/stune/top-app/schedtune.sched_boost_no_override

# Gpu
MIN=$(cat /sys/class/kgsl/kgsl-3d0/min_pwrlevel)
echo "80" > /sys/class/kgsl/kgsl-3d0/idle_timer
echo "450" > /sys/class/kgsl/kgsl-3d0/pmqos_active_latency
echo "1" > /sys/class/kgsl/kgsl-3d0/throttling
echo "$MIN" > /sys/class/kgsl/kgsl-3d0/default_pwrlevel
echo "0" > /sys/class/kgsl/kgsl-3d0/force_no_nap
echo "0" > /sys/class/kgsl/kgsl-3d0/force_rail_on
echo "0" > /sys/class/kgsl/kgsl-3d0/force_bus_on
echo "0" > /sys/class/kgsl/kgsl-3d0/force_clk_on

# Entropy
echo "128" > /proc/sys/kernel/random/read_wakeup_threshold
echo "512" > /proc/sys/kernel/random/write_wakeup_threshold

# Report
sed -Ei 's/^description=(\[.*][[:space:]]*)?/description=[ 🥶 Balance Mode... ] /g' "/data/adb/modules/ReWrite/module.prop"
am start -a android.intent.action.MAIN -e toasttext "🥶 Balance Mode..." -n bellavita.toast/.MainActivity
