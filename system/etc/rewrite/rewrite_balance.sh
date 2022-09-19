#!/system/bin/sh

SCHED_TASKS=10
SCHED_PERIOD=$((1 * 1000 * 1000))

# Enable Thermal
su -c start thermal-engine
su -c start vendor.thermal-engine

# Kernel parameters
echo "3" > /proc/sys/kernel/perf_cpu_time_max_percent
echo "$SCHED_PERIOD" > /proc/sys/kernel/sched_latency_ns
echo "$((SCHED_PERIOD / 2))" > /proc/sys/kernel/sched_wakeup_granularity_ns
echo "$((SCHED_PERIOD / SCHED_TASKS))" > /proc/sys/kernel/sched_min_granularity_ns
echo "5000000" > /proc/sys/kernel/sched_migration_cost_ns
echo "4" > /proc/sys/kernel/sched_nr_migrate
echo "1" > /proc/sys/kernel/sched_autogroup_enabled
echo "0" > /proc/sys/kernel/sched_tunable_scaling
echo "1" > /proc/sys/kernel/sched_child_runs_first

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

# Cpu tunables
for gov in /sys/devices/system/cpu/*/cpufreq
do
    echo "schedutil" > $gov/scaling_governor
    echo "0" > $gov/schedutil/up_rate_limit_us
    echo "0" > $gov/schedutil/down_rate_limit_us
    echo "85" > $gov/schedutil/hispeed_load
    echo "0" > $gov/schedutil/pl
done

# Lpm
echo "25" > /sys/module/lpm_levels/parameters/bias_hyst

# Top app stune boost
echo "0" > /dev/stune/top-app/schedtune.boost

# Gpu
MIN=$(cat /sys/class/kgsl/kgsl-3d0/min_pwrlevel)
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
