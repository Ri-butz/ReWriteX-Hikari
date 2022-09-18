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
done
for sched  in /sys/devices/system/cpu/*/cpufreq/schedutil
do
    echo "0" > $sched/up_rate_limit_us
    echo "0" > $sched/down_rate_limit_us
    echo "80" > $sched/hispeed_load
    echo "1" > $sched/pl
done

# Lpm
echo "100" > /sys/module/lpm_levels/parameters/bias_hyst

# Top app stune boost
echo "60" > /dev/stune/top-app/schedtune.boost

# Gpu
echo "0" > /sys/class/kgsl/kgsl-3d0/throttling
echo "2" > /sys/class/kgsl/kgsl-3d0/default_pwrlevel
echo "1" > /sys/class/kgsl/kgsl-3d0/force_no_nap
echo "1" > /sys/class/kgsl/kgsl-3d0/force_rail_on
echo "1" > /sys/class/kgsl/kgsl-3d0/force_bus_on
echo "1" > /sys/class/kgsl/kgsl-3d0/force_clk_on

# I/O scheduler
echo "1024" > /sys/block/dm-0/queue/read_ahead_kb
echo "128" > /sys/block/dm-0/queue/nr_requests
echo "1024" > /sys/block/dm-1/queue/read_ahead_kb
echo "128" > /sys/block/dm-1/queue/nr_requests
echo "1024" > /sys/block/loop0/queue/read_ahead_kb
echo "128" > /sys/block/loop0/queue/nr_requests
echo "1024" > /sys/block/loop1/queue/read_ahead_kb
echo "128" > /sys/block/loop1/queue/nr_requests
echo "1024" > /sys/block/loop2/queue/read_ahead_kb
echo "128" > /sys/block/loop2/queue/nr_requests
echo "1024" > /sys/block/loop3/queue/read_ahead_kb
echo "128" > /sys/block/loop3/queue/nr_requests
echo "1024" > /sys/block/loop4/queue/read_ahead_kb
echo "128" > /sys/block/loop4/queue/nr_requests
echo "1024" > /sys/block/loop5/queue/read_ahead_kb
echo "128" > /sys/block/loop5/queue/nr_requests
echo "1024" > /sys/block/loop6/queue/read_ahead_kb
echo "128" > /sys/block/loop6/queue/nr_requests
echo "1024" > /sys/block/loop7/queue/read_ahead_kb
echo "128" > /sys/block/loop7/queue/nr_requests
echo "1024" > /sys/block/loop8/queue/read_ahead_kb
echo "128" > /sys/block/loop8/queue/nr_requests
echo "1024" > /sys/block/loop9/queue/read_ahead_kb
echo "128" > /sys/block/loop9/queue/nr_requests
echo "1024" > /sys/block/loop10/queue/read_ahead_kb
echo "128" > /sys/block/loop10/queue/nr_requests
echo "1024" > /sys/block/loop11/queue/read_ahead_kb
echo "128" > /sys/block/loop11/queue/nr_requests
echo "1024" > /sys/block/loop12/queue/read_ahead_kb
echo "128" > /sys/block/loop12/queue/nr_requests
echo "1024" > /sys/block/loop13/queue/read_ahead_kb
echo "128" > /sys/block/loop13/queue/nr_requests
echo "1024" > /sys/block/loop14/queue/read_ahead_kb
echo "128" > /sys/block/loop14/queue/nr_requests
echo "1024" > /sys/block/loop15/queue/read_ahead_kb
echo "128" > /sys/block/loop15/queue/nr_requests
echo "1024" > /sys/block/mmcblk0/queue/read_ahead_kb
echo "128" > /sys/block/mmcblk0/queue/nr_requests
echo "1024" > /sys/block/ram0/queue/read_ahead_kb
echo "128" > /sys/block/ram0/queue/nr_requests
echo "1024" > /sys/block/ram1/queue/read_ahead_kb
echo "128" > /sys/block/ram1/queue/nr_requests
echo "1024" > /sys/block/ram2/queue/read_ahead_kb
echo "128" > /sys/block/ram2/queue/nr_requests
echo "1024" > /sys/block/ram3/queue/read_ahead_kb
echo "128" > /sys/block/ram3/queue/nr_requests
echo "1024" > /sys/block/ram4/queue/read_ahead_kb
echo "128" > /sys/block/ram4/queue/nr_requests
echo "1024" > /sys/block/ram5/queue/read_ahead_kb
echo "128" > /sys/block/ram5/queue/nr_requests
echo "1024" > /sys/block/ram6/queue/read_ahead_kb
echo "128" > /sys/block/ram6/queue/nr_requests
echo "1024" > /sys/block/ram7/queue/read_ahead_kb
echo "128" > /sys/block/ram7/queue/nr_requests
echo "1024" > /sys/block/ram8/queue/read_ahead_kb
echo "128" > /sys/block/ram8/queue/nr_requests
echo "1024" > /sys/block/ram9/queue/read_ahead_kb
echo "128" > /sys/block/ram9/queue/nr_requests
echo "1024" > /sys/block/ram10/queue/read_ahead_kb
echo "128" > /sys/block/ram10/queue/nr_requests
echo "1024" > /sys/block/ram11/queue/read_ahead_kb
echo "128" > /sys/block/ram11/queue/nr_requests
echo "1024" > /sys/block/ram12/queue/read_ahead_kb
echo "128" > /sys/block/ram12/queue/nr_requests
echo "1024" > /sys/block/ram13/queue/read_ahead_kb 
echo "128" > /sys/block/ram13/queue/nr_requests
echo "1024" > /sys/block/ram14/queue/read_ahead_kb
echo "128" > /sys/block/ram14/queue/nr_requests
echo "1024" > /sys/block/ram15/queue/read_ahead_kb
echo "128" > /sys/block/ram15/queue/nr_requests
echo "1024" > /sys/block/sda/queue/read_ahead_kb
echo "128" > /sys/block/sda/queue/nr_requests
echo "1024" > /sys/block/sdb/queue/read_ahead_kb
echo "128" > /sys/block/sdb/queue/nr_requests
echo "1024" > /sys/block/sdc/queue/read_ahead_kb
echo "128" > /sys/block/sdc/queue/nr_requests
echo "1024" > /sys/block/zram0/queue/read_ahead_kb
echo "128" > /sys/block/zram0/queue/nr_requests

# Entropy
echo "1024" > /proc/sys/kernel/random/read_wakeup_threshold
echo "2048" > /proc/sys/kernel/random/write_wakeup_threshold

# Report
sed -Ei 's/^description=(\[.*][[:space:]]*)?/description=[ 🥵 Performance Mode... ] /g' "/data/adb/modules/ReWrite/module.prop"
am start -a android.intent.action.MAIN -e toasttext "🥵 Performance Mode..." -n bellavita.toast/.MainActivity
