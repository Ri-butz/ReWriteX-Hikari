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
  echo "0" > $gov/schedutil/hispeed_freq
done

# Kernel parameters
echo "15" > /proc/sys/kernel/perf_cpu_time_max_percent
echo "4000000" > /proc/sys/kernel/sched_latency_ns
echo "15000000" > /proc/sys/kernel/sched_wakeup_granularity_ns
echo "10000000" > /proc/sys/kernel/sched_min_granularity_ns
echo "5000000" > /proc/sys/kernel/sched_migration_cost_ns
echo "32" > /proc/sys/kernel/sched_nr_migrate
echo "15" > /proc/sys/kernel/sched_min_task_util_for_boost
echo "1000" > /proc/sys/kernel/sched_min_task_util_for_colocation
echo "100" > /proc/sys/kernel/sched_rr_timeslice_ns
echo "1000000" > /proc/sys/kernel/sched_rt_period_us
echo "950000" > /proc/sys/kernel/sched_rt_runtime_us
echo "0" > /proc/sys/kernel/sched_autogroup_enabled
echo "0" > /proc/sys/kernel/sched_tunable_scaling
echo "0" > /proc/sys/kernel/sched_child_runs_first
echo "0" > /proc/sys/kernel/timer_migration
echo "0" > /proc/sys/kernel/sched_schedstats
echo "0	0 0 0" > /proc/sys/kernel/printk
echo "off" > /proc/sys/kernel/printk_devkmsg

# Disable kernel panic
echo "0" > /proc/sys/kernel/panic
echo "0" > /proc/sys/kernel/panic_on_oops
echo "0" > /proc/sys/kernel/panic_on_warn
echo "0" > /sys/module/kernel/parameters/panic
echo "0" > /sys/module/kernel/parameters/panic_on_warn
echo "0" > /sys/module/kernel/parameters/pause_on_oops

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
for stune in /dev/stune/*
do
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
if [ -d "/sys/module/subsystem_restart/parameters" ]
then
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
echo "10" > /proc/sys/vm/dirty_background_ratio
echo "30" > /proc/sys/vm/dirty_ratio
echo "300" > /proc/sys/vm/dirty_expire_centisecs
echo "700" > /proc/sys/vm/dirty_writeback_centisecs
echo "750" > /proc/sys/vm/extfrag_threshold
echo "100" > /proc/sys/vm/swappiness
echo "0" > /proc/sys/vm/page-cluster
echo "0" > /proc/sys/vm/oom_kill_allocating_task
echo "50" > /proc/sys/vm/vfs_cache_pressure
echo "20" > /proc/sys/vm/stat_interval
echo "8192" > /proc/sys/vm/min_free_kbytes
echo "32" > /proc/sys/vm/watermark_scale_factor
echo "1500" > /proc/sys/vm/watermark_boost_factor

# LMK
echo "0" > /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk
chmod 666 /sys/module/lowmemorykiller/parameters/minfree
chown root /sys/module/lowmemorykiller/parameters/minfree
echo "14535,29070,43605,58112,72675,87210" > /sys/module/lowmemorykiller/parameters/minfree
chmod 444 /sys/module/lowmemorykiller/parameters/minfree

# I/O scheduler
  #Internal storage
  for int in /sys/block/sd*/queue
  do
    echo "cfq" > $int/scheduler
    echo "0" > $int/add_random
    echo "0" > $int/iostats
    echo "128" > $int/read_ahead_kb
    echo "64" > $int/nr_requests
  done
  #External storage
  for ext in /sys/block/mmc*/queue
  do
    echo "cfq" > $ext/scheduler
    echo "0" > $ext/add_random
    echo "0" > $ext/iostats
    echo "128" > $ext/read_ahead_kb
    echo "64" > $ext/nr_requests
  done

# Max Processing
[ $(getprop ro.build.version.release) -gt 9 ] && device_config put activity_manager max_phantom_processes 32 ; device_config put activity_manager max_cached_processes 64 || settings put global activity_manager_constants max_cached_processes=64

# Fstrim
fstrim /data
fstrim /cache
fstrim /system
sm fstrim

# Unity Big.Little trick by lybxlpsv 
nohup sh $MODDIR/script/unitytrick > /dev/null &

# Doze mode
#dumpsysdeviceidle
#deep doze

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

#DO
sed -Ei 's/^description=(\[.*][[:space:]]*)?/description=[ ⛔ Dex2oat Optimizer is running... ] /g' "/data/adb/modules/ReWrite/module.prop"
su -lp 2000 -c "cmd notification post -S bigtext -t 'Re-WriteX' tag '⛔ Dex2oat Optimizer is running...'" >/dev/null 2>&1
sleep 15
dex2oat_opt

# Report max frequency to unity tasks
[[ -e "/proc/sys/kernel/sched_lib_mask_force" ]] && [[ -e "/proc/sys/kernel/sched_lib_name" ]] && {
	echo "UnityMain,libunity.so" > "/proc/sys/kernel/sched_lib_name"
	echo "255" > "/proc/sys/kernel/sched_lib_mask_force"
}

# Done
sed -Ei 's/^description=(\[.*][[:space:]]*)?/description=[ ✅ All tweaks is applied... ] /g' "/data/adb/modules/ReWrite/module.prop"
su -lp 2000 -c "cmd notification post -S bigtext -t 'Re-WriteX' tag '✅ All tweaks is applied...'" >/dev/null 2>&1

# Run Ai
sleep 3
rewrite
