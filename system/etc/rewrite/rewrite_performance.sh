#!/system/bin/sh

# Disable Thermal
su -c stop thermal-engine
su -c stop vendor.thermal-engine

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

# Cpu tunables
for gov in /sys/devices/system/cpu/*/cpufreq
do
    echo "schedutil" > $gov/scaling_governor
    echo "0" > $gov/schedutil/up_rate_limit_us
    echo "0" > $gov/schedutil/down_rate_limit_us
    echo "85" > $gov/schedutil/hispeed_load
    echo "1" > $gov/schedutil/pl
done

# Lpm
echo "100" > /sys/module/lpm_levels/parameters/bias_hyst

# Top app stune boost
echo "70" > /dev/stune/top-app/schedtune.boost

# Gpu
echo "1000" > /sys/class/kgsl/kgsl-3d0/pmqos_active_latency
echo "0" > /sys/class/kgsl/kgsl-3d0/throttling
echo "2" > /sys/class/kgsl/kgsl-3d0/default_pwrlevel
echo "1" > /sys/class/kgsl/kgsl-3d0/force_no_nap
echo "1" > /sys/class/kgsl/kgsl-3d0/force_rail_on
echo "1" > /sys/class/kgsl/kgsl-3d0/force_bus_on
echo "1" > /sys/class/kgsl/kgsl-3d0/force_clk_on

# Entropy
echo "1024" > /proc/sys/kernel/random/read_wakeup_threshold
echo "2048" > /proc/sys/kernel/random/write_wakeup_threshold

# Report
sed -Ei 's/^description=(\[.*][[:space:]]*)?/description=[ 🥵 Performance Mode... ] /g' "/data/adb/modules/ReWrite/module.prop"
am start -a android.intent.action.MAIN -e toasttext "🥵 Performance Mode..." -n bellavita.toast/.MainActivity
