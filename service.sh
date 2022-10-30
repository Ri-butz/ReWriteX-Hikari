#!/system/bin/sh
# Do NOT assume where your module will be located.
# ALWAYS use $MODDIR if you need to know where this script
# and module is placed.
# This will make sure your module will still work
# if Magisk change its mount point in the future
MODDIR=${0%/*}

# Sleep some time to make sure init is completed
sleep 30
# Enable all tweak
sed -Ei 's/^description=(\[.*][[:space:]]*)?/description=[ 🚴 Apply tweaks please wait... ] /g' "/data/adb/modules/ReWrite/module.prop"
su -lp 2000 -c "cmd notification post -S bigtext -t 'Re-WriteX' tag '🚴 Apply tweaks please wait...'" >/dev/null 2>&1

# AVC denial fix
magiskpolicy --live 'allow untrusted_app proc_net_tcp_udp file {read write open getattr}'
magiskpolicy --live 'allow untrusted_app app_data_file file {read write open getattr execute execute_no_trans}'

# Schedutil as default governor
for gov in /sys/devices/system/cpu/*/cpufreq
do
    echo "schedutil" > $gov/scaling_governor
    echo "0" > $gov/schedutil/up_rate_limit_us
    echo "0" > $gov/schedutil/down_rate_limit_us
    echo "90" > $gov/schedutil/hispeed_load
done

# Kernel parameters
SCHED_TASKS=8
SCHED_PERIOD=$((4 * 1000 * 1000))
echo "15" > /proc/sys/kernel/perf_cpu_time_max_percent
echo "$SCHED_PERIOD" > /proc/sys/kernel/sched_latency_ns
echo "$((SCHED_PERIOD / 2))" > /proc/sys/kernel/sched_wakeup_granularity_ns
echo "$((SCHED_PERIOD / SCHED_TASKS))" > /proc/sys/kernel/sched_min_granularity_ns
echo "5000000" > /proc/sys/kernel/sched_migration_cost_ns
echo "32" > /proc/sys/kernel/sched_nr_migrate
echo "1" > /proc/sys/kernel/sched_autogroup_enabled
echo "0" > /proc/sys/kernel/sched_tunable_scaling
echo "1" > /proc/sys/kernel/sched_child_runs_first
echo "0" > /proc/sys/kernel/timer_migration
echo "0" > /proc/sys/kernel/sched_schedstats

# Lpm
echo "0" > /sys/module/lpm_levels/parameters/lpm_prediction
echo "0" > /sys/module/lpm_levels/parameters/sleep_disabled

# Disable kernel panic
echo "0" > /proc/sys/kernel/panic
echo "0" > /proc/sys/kernel/panic_on_oops
echo "0" > /proc/sys/kernel/panic_on_warn
echo "0" > /sys/module/kernel/parameters/panic
echo "0" > /sys/module/kernel/parameters/panic_on_warn
echo "0" > /sys/module/kernel/parameters/pause_on_oops

# Disable Fsync
chmod 666 /sys/module/sync/parameters/fsync_enable
chown root /sys/module/sync/parameters/fsync_enable
echo "N" > /sys/module/sync/parameters/fsync_enable

# Disable CRC
echo "0" > /sys/module/mmc_core/parameters/use_spi_crc

# Cpu Efficient
echo "Y" > /sys/module/workqueue/parameters/power_efficient

# Disable cpu input boost
echo "0" > /sys/module/cpu_boost/parameters/sched_boost_on_input
echo "0:0" > /sys/module/cpu_boost/parameters/input_boost_freq
echo "1:0" > /sys/module/cpu_boost/parameters/input_boost_freq
echo "2:0" > /sys/module/cpu_boost/parameters/input_boost_freq
echo "3:0" > /sys/module/cpu_boost/parameters/input_boost_freq
echo "4:0" > /sys/module/cpu_boost/parameters/input_boost_freq
echo "5:0" > /sys/module/cpu_boost/parameters/input_boost_freq
echo "6:0" > /sys/module/cpu_boost/parameters/input_boost_freq
echo "7:0" > /sys/module/cpu_boost/parameters/input_boost_freq

# Stune boost
echo "1" > /dev/stune/schedtune.sched_boost_enabled
echo "0" > /dev/stune/schedtune.boost
echo "0" > /dev/stune/schedtune.sched_boost_no_override
echo "0" > /dev/stune/schedtune.prefer_idle
echo "0" > /dev/stune/schedtune.colocate
echo "0" > /dev/stune/cgroup.clone_children
echo "0" > /dev/stune/cgroup.sane_behavior
for stune in /dev/stune/*; do
    echo "1" > $stune/schedtune.sched_boost_enabled
    echo "0" > $stune/schedtune.boost
    echo "0" > $stune/schedtune.sched_boost_no_override
    echo "0" > $stune/schedtune.prefer_idle
    echo "0" > $stune/schedtune.colocate
    echo "0" > $stune/cgroup.clone_children
done
#Lower Schedtune on background as it will consume quite a lot of power.
echo "1" > /dev/stune/background/schedtune.prefer_idle

# Disable Ramdumps
if [ -d "/sys/module/subsystem_restart/parameters" ]; then
    echo "0" > /sys/module/subsystem_restart/parameters/enable_ramdumps
    echo "0" > /sys/module/subsystem_restart/parameters/enable_mini_ramdumps
fi

# Disable Adreno snapshot crashdumper
echo "0" > /sys/class/kgsl/kgsl-3d0/snapshot/snapshot_crashdumper

# Zram
ZRAMSIZE=0
swapoff /dev/block/zram0 > /dev/null 2>&1
echo "1" > /sys/block/zram0/reset
echo "0" > /sys/block/zram0/disksize
echo "$ZRAMSIZE" > /sys/block/zram0/disksize
mkswap /dev/block/zram0 > /dev/null 2>&1
swapon /dev/block/zram0 > /dev/null 2>&1

# Virtual memory tweaks
stop perfd
echo "10" > /proc/sys/vm/dirty_background_ratio
echo "30" > /proc/sys/vm/dirty_ratio
echo "3000" > /proc/sys/vm/dirty_expire_centisecs
echo "3000" > /proc/sys/vm/dirty_writeback_centisecs
echo "750" > /proc/sys/vm/extfrag_threshold
echo "80" > /proc/sys/vm/swappiness
echo "0" > /proc/sys/vm/page-cluster
echo "0" > /proc/sys/vm/oom_kill_allocating_task
echo "20" > /proc/sys/vm/vfs_cache_pressure
echo "20" > /proc/sys/vm/stat_interval
echo "8192" > /proc/sys/vm/min_free_kbytes
start perfd

# LMK
echo "0" > /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk
chmod 666 /sys/module/lowmemorykiller/parameters/minfree
chown root /sys/module/lowmemorykiller/parameters/minfree
echo "14535,29070,43605,58112,72675,87210" > /sys/module/lowmemorykiller/parameters/minfree
echo "33280" > /sys/module/lowmemorykiller/parameters/vmpressure_file_min

# I/O scheduler optimized
# all sd, sda, sdb, etc.
for queue in /sys/block/sd*/queue
do
    echo "cfq" > $queue/scheduler
    echo "0" > $queue/iostats
    echo "0" > $queue/add_random
    echo "0" > $queue/nomerges
    echo "64" > $queue/nr_requests
    echo "1" > $queue/rq_affinity
    echo "128" > $queue/read_ahead_kb
    echo "0" > $queue/iosched/slice_idle
    echo "0" > $queue/iosched/slice_idle_us
    echo "0" > $queue/iosched/group_idle
    echo "0" > $queue/iosched/group_idle_us
    echo "1" > $queue/iosched/low_latency
    echo "100" > $queue/iosched/target_latency
    echo "100000" > $queue/iosched/target_latency_us
done

# Max Processing
[ $(getprop ro.build.version.release) -gt 9 ] && device_config put activity_manager max_phantom_processes 32 ; device_config put activity_manager max_cached_processes 64 || settings put global activity_manager_constants max_cached_processes=64

# Fstrim
fstrim -v /data
fstrim -v /system
fstrim -v /cache
fstrim -v /vendor
fstrim -v /product

# Unity Big.Little trick by lybxlpsv 
nohup sh $MODDIR/script/unitytrick > /dev/null &

# Doze mode
#dumpsysdeviceidle
# Without deep doze

# Guide: $1 - task_name | $2 - "cpuset" or "stune" | $3 - cgroup_name
change_task_cgroup() {
    local ps_ret
    ps_ret="$(ps -Ao pid,args)"
    for temp_pid in $(echo "$ps_ret" | grep "$1" | awk '{print $1}'); do
        for temp_tid in $(ls "/proc/$temp_pid/task/"); do
            write "/dev/$2/$3/tasks" "$temp_tid"
        done
    done
}

# Guide: $1 - task_name | $2 - nice (relative to 120)
change_task_nice() {
    local ps_ret
    ps_ret="$(ps -Ao pid,args)"
    for temp_pid in $(echo "$ps_ret" | grep "$1" | awk '{print $1}'); do
        for temp_tid in $(ls "/proc/$temp_pid/task/"); do
            renice -n "$2" -p "$temp_tid"
        done
    done
}

# Better rendering speed
change_task_cgroup "surfaceflinger" "top-app" "cpuset"
change_task_cgroup "surfaceflinger" "foreground" "stune"
change_task_cgroup "android.hardware.graphics.composer" "top-app" "cpuset"
change_task_cgroup "android.hardware.graphics.composer" "foreground" "stune"
change_task_nice "surfaceflinger" "-15"
change_task_nice "android.hardware.graphics.composer" "-15"

# Dex2oat
sed -Ei 's/^description=(\[.*][[:space:]]*)?/description=[ ⛔ Dex2oat Optimizer is running... ] /g' "/data/adb/modules/ReWrite/module.prop"
su -lp 2000 -c "cmd notification post -S bigtext -t 'Re-WriteX' tag '⛔ Dex2oat Optimizer is running...'" >/dev/null 2>&1
sleep 15
dex2oat_opt

# Done
sed -Ei 's/^description=(\[.*][[:space:]]*)?/description=[ ✅ All tweaks is applied... ] /g' "/data/adb/modules/ReWrite/module.prop"
su -lp 2000 -c "cmd notification post -S bigtext -t 'Re-WriteX' tag '✅ All tweaks is applied...'" >/dev/null 2>&1

# Run Ai
sleep 3
$MODDIR/system/etc/rewrite/rewrite.sh > /dev/null
