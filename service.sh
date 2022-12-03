#!/system/bin/sh
# Do NOT assume where your module will be located.
# ALWAYS use $MODDIR if you need to know where this script
# and module is placed.
# This will make sure your module will still work
# if Magisk change its mount point in the future
MODDIR=${0%/*}

# Sleep some time to make sure init is completed
sleep 30

###############################
# PATHs
###############################

BIN_DIR="/bin"
MODULE_PATH="$(dirname $(readlink -f "$0"))"
MODULE_PATH="${MODULE_PATH%$SCRIPT_DIR}"
PATH=/sbin:/system/sbin:/product/bin:/apex/com.android.runtime/bin:/system/bin:/system/xbin:/odm/bin:/vendor/bin:/vendor/xbin:/sbin
FSCC_REL="$BIN_DIR"
FSCC_NAME="fscache-ctrl"

###############################
# Abbreviations
###############################

SYS_FRAME="/system/framework"
SYS_LIB="/system/lib64"
VDR_LIB="/vendor/lib64"
DALVIK="/data/dalvik-cache"
APEX1="/apex/com.android.art/javalib"
APEX2="/apex/com.android.runtime/javalib"
ZRAMSIZE=0

###############################
# FSCC tool functions
###############################

fscc_file_list=""

# $1:apk_path $return:oat_path
fscc_path_apk_to_oat()
{
    # OPSystemUI/OPSystemUI.apk -> OPSystemUI/oat
    echo "${1%/*}/oat"
}

# $1:file/dir
fscc_list_append()
{
    fscc_file_list="$fscc_file_list $1"
}

# $1:file/dir
fscc_add_obj()
{
    # whether file or dir exists
    if [ -e "$1" ]; then
        fscc_list_append "$1"
    fi
}

# $1:package_name
fscc_add_apk()
{
    if [ "$1" != "" ]; then
        # pm path -> "package:/system/product/priv-app/OPSystemUI/OPSystemUI.apk"
        fscc_add_obj "$(pm path "$1" | head -n 1 | cut -d: -f2)"
    fi
}

# $1:package_name
fscc_add_dex()
{
    local package_apk_path
    local apk_name

    if [ "$1" != "" ]; then
        # pm path -> "package:/system/product/priv-app/OPSystemUI/OPSystemUI.apk"
        package_apk_path="$(pm path "$1" | head -n 1 | cut -d: -f2)"
        # user app: OPSystemUI/OPSystemUI.apk -> OPSystemUI/oat
        fscc_add_obj "${package_apk_path%/*}/oat"

        # remove apk name suffix
        apk_name="${package_apk_path%/*}"
        # remove path prefix
        apk_name="${apk_name##*/}"
        # system app: get dex & vdex
        # /data/dalvik-cache/arm64/system@product@priv-app@OPSystemUI@OPSystemUI.apk@classes.dex
        for dex in $(find "$DALVIK" | grep "@$apk_name@"); do
            fscc_add_obj "$dex"
        done
   fi
}

fscc_add_app_home()
{
    # well, not working on Android 7.1
    local intent_act="android.intent.action.MAIN"
    local intent_cat="android.intent.category.HOME"
    local pkg_name
    # "  packageName=com.microsoft.launcher"
    pkg_name="$(pm resolve-activity -a "$intent_act" -c "$intent_cat" | grep packageName | head -n 1 | cut -d= -f2)"
    # /data/dalvik-cache/arm64/system@priv-app@OPLauncher2@OPLauncher2.apk@classes.dex 16M/31M  53.2%
    # /data/dalvik-cache/arm64/system@priv-app@OPLauncher2@OPLauncher2.apk@classes.vdex 120K/120K  100%
    # /system/priv-app/OPLauncher2/OPLauncher2.apk 14M/30M  46.1%
    fscc_add_apk "$pkg_name"
    fscc_add_dex "$pkg_name"
}

fscc_add_app_ime()
{
    local pkg_name
    # "      packageName=com.baidu.input_yijia"
    pkg_name="$(ime list | grep packageName | head -n 1 | cut -d= -f2)"
    # /data/dalvik-cache/arm/system@app@baidushurufa@baidushurufa.apk@classes.dex 5M/17M  33.1%
    # /data/dalvik-cache/arm/system@app@baidushurufa@baidushurufa.apk@classes.vdex 2M/7M  28.1%
    # /system/app/baidushurufa/baidushurufa.apk 1M/28M  5.71%
    # pin apk file in memory is not valuable
    fscc_add_dex "$pkg_name"
}

# $1:package_name
fscc_add_apex_lib()
{
    fscc_add_obj "$(find /apex -name "$1" | head -n 1)"
}

# after appending fscc_file_list
fscc_start()
{
    # multiple parameters, cannot be warped by ""
    "$MODULE_PATH/$FSCC_REL/$FSCC_NAME" -fdlb0 $fscc_file_list
}

fscc_stop()
{
    killall "$FSCC_NAME"
}

# return:status
fscc_status()
{
    # get the correct value after waiting for fscc loading files
    sleep 2
    if [ "$(ps -A | grep "$FSCC_NAME")" != "" ]; then
        echo "Running. $(cat /proc/meminfo | grep Mlocked | cut -d: -f2 | tr -d ' ') in cache."
    else
        echo "Not running."
    fi
}
###############################
# Cgroup functions
###############################

# $1:task_name $2:cgroup_name $3:"cpuset"/"stune"
change_task_cgroup()
{
    # avoid matching grep itself
    # ps -Ao pid,args | grep kswapd
    # 150 [kswapd0]
    # 16490 grep kswapd
    local ps_ret
    ps_ret="$(ps -Ao pid,args)"
    for temp_pid in $(echo "$ps_ret" | grep "$1" | awk '{print $1}'); do
        for temp_tid in $(ls "/proc/$temp_pid/task/"); do
            echo "$temp_tid" > "/dev/$3/$2/tasks"
        done
    done
}

# $1:task_name $2:hex_mask(0x00000003 is CPU0 and CPU1)
change_task_affinity()
{
    # avoid matching grep itself
    # ps -Ao pid,args | grep kswapd
    # 150 [kswapd0]
    # 16490 grep kswapd
    local ps_ret
    ps_ret="$(ps -Ao pid,args)"
    for temp_pid in $(echo "$ps_ret" | grep "$1" | awk '{print $1}'); do
        for temp_tid in $(ls "/proc/$temp_pid/task/"); do
            taskset -p "$2" "$temp_tid"
        done
    done
}

# $1:task_name $2:nice(relative to 120)
change_task_nice()
{
    # avoid matching grep itself
    # ps -Ao pid,args | grep kswapd
    # 150 [kswapd0]
    # 16490 grep kswapd
    local ps_ret
    ps_ret="$(ps -Ao pid,args)"
    for temp_pid in $(echo "$ps_ret" | grep "$1" | awk '{print $1}'); do
        for temp_tid in $(ls "/proc/$temp_pid/task/"); do
            renice "$2" -p "$temp_tid"
        done
    done
}
###############################

# Enable all tweak
sed -Ei 's/^description=(\[.*][[:space:]]*)?/description=[ 🚴 Apply tweaks please wait... ] /g' "/data/adb/modules/NGNL/module.prop"
su -lp 2000 -c "cmd notification post -S bigtext -t 'NoGame•NoLife' tag '🚴 Apply tweaks please wait...'" >/dev/null 2>&1

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
swapoff /dev/block/zram0
echo "1" > /sys/block/zram0/reset
echo "0" > /sys/block/zram0/disksize
echo "$ZRAMSIZE" > /sys/block/zram0/disksize
mkswap /dev/block/zram0
swapon /dev/block/zram0

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
fstrim /vendor

# Unity Big.Little trick by lybxlpsv 
nohup sh $MODDIR/script/unitytrick > /dev/null &

# Doze mode
#dumpsysdeviceidle
#deep doze

# Fix laggy bilibili feed scrolling
change_task_cgroup "servicemanager" "top-app" "cpuset"
change_task_cgroup "servicemanager" "foreground" "stune"
change_task_cgroup "android.phone" "top-app" "cpuset"
change_task_cgroup "android.phone" "foreground" "stune"

# Fix laggy home gesture
change_task_cgroup "system_server" "top-app" "cpuset"
change_task_cgroup "system_server" "foreground" "stune"

# Reduce render thread waiting time
change_task_cgroup "surfaceflinger" "top-app" "cpuset"
change_task_cgroup "surfaceflinger" "foreground" "stune"
change_task_cgroup "android.hardware.graphics.composer" "top-app" "cpuset"
change_task_cgroup "android.hardware.graphics.composer" "foreground" "stune"
change_task_nice "surfaceflinger" "-20"
change_task_nice "android.hardware.graphics.composer" "-20"

# Reduce big cluster wakeup, eg. android.hardware.sensors@1.0-service
change_task_affinity ".hardware." "0f"
# ...but exclude the fingerprint&camera service for speed
change_task_affinity ".hardware.biometrics.fingerprint" "ff"
change_task_affinity ".hardware.camera.provider" "ff"

# Kernel reclaim threads run on more power-efficient cores
change_task_nice "kswapd" "-2"
change_task_nice "oom_reaper" "-2"
change_task_affinity "kswapd" "7f"
change_task_affinity "oom_reaper" "7f"

# Similiar to PinnerService, Mlock(Unevictable) 200~350MB
fscc_add_obj "$SYS_FRAME/framework.jar"
fscc_add_obj "$SYS_FRAME/services.jar"
fscc_add_obj "$SYS_FRAME/ext.jar"
fscc_add_obj "$SYS_FRAME/telephony-common.jar"
fscc_add_obj "$SYS_FRAME/qcnvitems.jar"
fscc_add_obj "$SYS_FRAME/oat"
fscc_add_obj "$SYS_FRAME/arm64"
fscc_add_obj "$SYS_FRAME/arm/boot-framework.oat"
fscc_add_obj "$SYS_FRAME/arm/boot-framework.vdex"
fscc_add_obj "$SYS_FRAME/arm/boot.oat"
fscc_add_obj "$SYS_FRAME/arm/boot.vdex"
fscc_add_obj "$SYS_FRAME/arm/boot-core-libart.oat"
fscc_add_obj "$SYS_FRAME/arm/boot-core-libart.vdex"
fscc_add_obj "$SYS_LIB/libandroid_servers.so"
fscc_add_obj "$SYS_LIB/libandroid_runtime.so"
fscc_add_obj "$SYS_LIB/libandroidfw.so"
fscc_add_obj "$SYS_LIB/libandroid.so"
fscc_add_obj "$SYS_LIB/libhwui.so"
fscc_add_obj "$SYS_LIB/libjpeg.so"
fscc_add_obj "$VDR_LIB/libssc.so"
fscc_add_obj "$VDR_LIB/libgsl.so"
fscc_add_obj "$VDR_LIB/sensors.ssc.so"
fscc_add_apex_lib "core-oj.jar"
fscc_add_apex_lib "core-libart.jar"
fscc_add_apex_lib "updatable-media.jar"
fscc_add_apex_lib "okhttp.jar"
fscc_add_apex_lib "bouncycastle.jar"
# do not pin too many files on low memory devices
[ "$TMEM" -gt 2098652 ] && fscc_add_apk "com.android.systemui"
[ "$TMEM" -gt 2098652 ] && fscc_add_dex "com.android.systemui"
[ "$TMEM" -gt 4197304 ] && fscc_add_app_home
[ "$TMEM" -gt 4197304 ] && fscc_add_app_ime
fscc_stop
fscc_start

#DO
sed -Ei 's/^description=(\[.*][[:space:]]*)?/description=[ ⛔ Dex2oat Optimizer is running... ] /g' "/data/adb/modules/NGNL/module.prop"
su -lp 2000 -c "cmd notification post -S bigtext -t 'NoGame•NoLife' tag '⛔ Dex2oat Optimizer is running...'" >/dev/null 2>&1
sleep 15
dex2oat_opt

# Report max frequency to unity tasks
[[ -e "/proc/sys/kernel/sched_lib_mask_force" ]] && [[ -e "/proc/sys/kernel/sched_lib_name" ]] && {
	echo "UnityMain,libunity.so" > "/proc/sys/kernel/sched_lib_name"
	echo "255" > "/proc/sys/kernel/sched_lib_mask_force"
}

# Done
sed -Ei 's/^description=(\[.*][[:space:]]*)?/description=[ ✅ All tweaks is applied... ] /g' "/data/adb/modules/NGNL/module.prop"
su -lp 2000 -c "cmd notification post -S bigtext -t 'NoGame•NoLife' tag '✅ All tweaks is applied...'" >/dev/null 2>&1

# Run Ai
sleep 3
rewrite
