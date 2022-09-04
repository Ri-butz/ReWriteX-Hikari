#!/system/bin/sh
# Do NOT assume where your module will be located.
# ALWAYS use $MODDIR if you need to know where this script
# and module is placed.
# This will make sure your module will still work
# if Magisk change its mount point in the future
MODDIR=${0%/*}

# Sleep some time to make sure init is completed
sleep 30
wait_until_login() {
  # In case of /data encryption is disabled
  while [[ "$(getprop sys.boot_completed)" != "1" ]]; do
    sleep 3
  done
  # We don't have the permission to rw "/storage/emulated/0" before the user unlocks the screen
  test_file="/storage/emulated/0/Android/.PERMISSION_TEST"
  true >"$test_file"
  while [[ ! -f "$test_file" ]]; do
    true >"$test_file"
    sleep 1
  done
  rm -f "$test_file"
}
wait_until_login

# Enable all tweak
sed -Ei 's/^description=(\[.*][[:space:]]*)?/description=[ 🚴 ReWriteX is started please wait... ] /g' "/data/adb/modules/ReWrite/module.prop"

# AVC denial fix
magiskpolicy --live 'allow untrusted_app proc_net_tcp_udp file {read write open getattr}'
magiskpolicy --live 'allow untrusted_app app_data_file file {read write open getattr execute execute_no_trans}'

# DNS Changer
iptables -t nat -A OUTPUT -p tcp --dport 53 -j DNAT --to-destination :53
iptables -t nat -A OUTPUT -p udp --dport 53 -j DNAT --to-destination :53
iptables -t nat -I OUTPUT -p tcp --dport 53 -j DNAT --to-destination :53
iptables -t nat -I OUTPUT -p udp --dport 53 -j DNAT --to-destination :53

# Kernel parameters
echo "15" > /proc/sys/kernel/perf_cpu_time_max_percent
echo "15000000" > /proc/sys/kernel/sched_wakeup_granularity_ns
echo "10000000" > /proc/sys/kernel/sched_min_granularity_ns
echo "5000000" > /proc/sys/kernel/sched_migration_cost_ns

# Lpm
echo "0" > /sys/module/lpm_levels/parameters/lpm_prediction
echo "0" > /sys/module/lpm_levels/parameters/sleep_disabled

# Disable timer migration
echo "0" > /proc/sys/kernel/timer_migration

# Disable kernel panic
echo '0' > /proc/sys/kernel/panic
echo '0' > /proc/sys/kernel/panic_on_oops
echo '0' > /proc/sys/kernel/panic_on_warn
echo '0' > /sys/module/kernel/parameters/panic
echo '0' > /sys/module/kernel/parameters/panic_on_warn
echo '0' > /sys/module/kernel/parameters/pause_on_oops

# Disable Fsync
chmod 666 /sys/module/sync/parameters/fsync_enable
chown root /sys/module/sync/parameters/fsync_enable
echo "N" > /sys/module/sync/parameters/fsync_enable

# Cpu tunables
for gov in /sys/devices/system/cpu/*/cpufreq
do
    echo "schedutil" > $gov/scaling_governor
done

for sched  in /sys/devices/system/cpu/*/cpufreq/schedutil
do
    echo "0" > $sched/up_rate_limit_us
    echo "0" > $sched/down_rate_limit_us
    echo "90" > $sched/hispeed_load
    echo "1" > $sched/pl
done

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

# Stune Boost
echo "1" > /dev/stune/schedtune.sched_boost_enabled
echo "0" > /dev/stune/schedtune.boost
echo "0" > /dev/stune/schedtune.sched_boost_no_override
echo "0" > /dev/stune/schedtune.prefer_idle
echo "0" > /dev/stune/schedtune.colocate
echo "0" > /dev/stune/cgroup.clone_children
echo "0" > /dev/stune/cgroup.sane_behavior
##Background
echo "1" > /dev/stune/background/schedtune.sched_boost_enabled
echo "0" > /dev/stune/background/schedtune.boost
echo "0" > /dev/stune/background/schedtune.sched_boost_no_override
echo "0" > /dev/stune/background/schedtune.prefer_idle
echo "0" > /dev/stune/background/schedtune.colocate
echo "0" > /dev/stune/background/cgroup.clone_children
##Foreground
echo "1" > /dev/stune/foreground/schedtune.sched_boost_enabled
echo "0" > /dev/stune/foreground/schedtune.boost
echo "1" > /dev/stune/foreground/schedtune.sched_boost_no_override
echo "0" > /dev/stune/foreground/schedtune.prefer_idle
echo "0" > /dev/stune/foreground/schedtune.colocate 0
echo "0" > /dev/stune/foreground/cgroup.clone_children
##Real time
echo "1" > /dev/stune/rt/schedtune.sched_boost_enabled
echo "0" > /dev/stune/rt/schedtune.boost
echo "0" > /dev/stune/rt/schedtune.sched_boost_no_override
echo "0" > /dev/stune/rt/schedtune.prefer_idle
echo "0" > /dev/stune/rt/schedtune.colocate
echo "0" > /dev/stune/rt/cgroup.clone_children
##Top app
echo "1" > /dev/stune/top-app/schedtune.sched_boost_enabled
echo "1" > /dev/stune/top-app/schedtune.sched_boost_no_override
echo "1" > /dev/stune/top-app/schedtune.prefer_idle
echo "1" > /dev/stune/top-app/schedtune.colocate
echo "0" > /dev/stune/top-app/cgroup.clone_children

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
echo "20" > /proc/sys/vm/dirty_ratio
echo "300" > /proc/sys/vm/dirty_expire_centisecs
echo "5000" > /proc/sys/vm/dirty_writeback_centisecs
echo "750" > /proc/sys/vm/extfrag_threshold
echo "100" > /proc/sys/vm/swappiness
echo "0" > /proc/sys/vm/oom_kill_allocating_task
echo "80" > /proc/sys/vm/vfs_cache_pressure
echo "10" > /proc/sys/vm/stat_interval
echo "8192" > /proc/sys/vm/min_free_kbytes

# LMK
echo "1" > /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk
chmod 666 /sys/module/lowmemorykiller/parameters/minfree
chown root /sys/module/lowmemorykiller/parameters/minfree
echo "14535,29070,43605,58112,72675,87210" > /sys/module/lowmemorykiller/parameters/minfree
echo "33280" > /sys/module/lowmemorykiller/parameters/vmpressure_file_min

# I/O scheduler optimized
for queue in /sys/block/*/queue
do
    echo "0" > $queue/iostats
    echo "0" > $queue/add_random
    echo "0" > $queue/rotational
    echo "1" > $queue/rq_affinity
    echo "cfq" > $queue/scheduler
    echo "0" > $queue/iosched/slice_idle
    echo "0" > $queue/iosched/group_idle
    echo "0" > $queue/iosched/group_idle_us
    echo "1" > $queue/iosched/low_latency
    echo "50" > $queue/iosched/target_latency
    echo "50000" > $queue/iosched/target_latency_us
done

# Multi User Support
for i in $(ls /data/user/)
do
# Disable collective Device administrators
pm disable com.google.android.gms/com.google.android.gms.auth.managed.admin.DeviceAdminReceiver
pm disable com.google.android.gms/com.google.android.gms.mdm.receivers.MdmDeviceAdminReceiver
done

# Fstrim
fstrim -v /data
fstrim -v /system
fstrim -v /cache
fstrim -v /vendor
fstrim -v /product

# Dex2oat
sed -Ei 's/^description=(\[.*][[:space:]]*)?/description=[ ⛔ Dex2oat Optimizer is running... ] /g' "/data/adb/modules/ReWrite/module.prop"
sleep 15
dex2oat_opt
sed -Ei 's/^description=(\[.*][[:space:]]*)?/description=[ ✅ Dex2oat Optimizer is finished... ] /g' "/data/adb/modules/ReWrite/module.prop"

# Run Ai
sleep 3
$MODDIR/system/etc/rewrite/rewrite.sh > /dev/null
