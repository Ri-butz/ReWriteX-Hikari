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

# Devfreq
echo "9500" > /sys/class/devfreq/soc:qcom,cpubw/max_freq
echo "6000" > /sys/class/devfreq/soc:qcom,llccbw/max_freq

# Lpm
echo "25" > /sys/module/lpm_levels/parameters/bias_hyst

# Top app stune boost
echo "0" > /dev/stune/top-app/schedtune.boost

# Gpu
echo "1" > /sys/class/kgsl/kgsl-3d0/throttling
echo "0" > /sys/class/kgsl/kgsl-3d0/force_no_nap
echo "0" > /sys/class/kgsl/kgsl-3d0/force_rail_on
echo "0" > /sys/class/kgsl/kgsl-3d0/force_bus_on
echo "0" > /sys/class/kgsl/kgsl-3d0/force_clk_on

# I/O scheduler
echo "128" > /sys/block/dm-0/queue/read_ahead_kb
echo "64" > /sys/block/dm-0/queue/nr_requests
echo "128" > /sys/block/dm-1/queue/read_ahead_kb
echo "64" > /sys/block/dm-1/queue/nr_requests
echo "128" > /sys/block/loop0/queue/read_ahead_kb
echo "64" > /sys/block/loop0/queue/nr_requests
echo "128" > /sys/block/loop1/queue/read_ahead_kb
echo "64" > /sys/block/loop1/queue/nr_requests
echo "128" > /sys/block/loop2/queue/read_ahead_kb
echo "64" > /sys/block/loop2/queue/nr_requests
echo "128" > /sys/block/loop3/queue/read_ahead_kb
echo "64" > /sys/block/loop3/queue/nr_requests
echo "128" > /sys/block/loop4/queue/read_ahead_kb
echo "64" > /sys/block/loop4/queue/nr_requests
echo "128" > /sys/block/loop5/queue/read_ahead_kb
echo "64" > /sys/block/loop5/queue/nr_requests
echo "128" > /sys/block/loop6/queue/read_ahead_kb
echo "64" > /sys/block/loop6/queue/nr_requests
echo "128" > /sys/block/loop7/queue/read_ahead_kb
echo "64" > /sys/block/loop7/queue/nr_requests
echo "128" > /sys/block/loop8/queue/read_ahead_kb
echo "64" > /sys/block/loop8/queue/nr_requests
echo "128" > /sys/block/loop9/queue/read_ahead_kb
echo "64" > /sys/block/loop9/queue/nr_requests
echo "128" > /sys/block/loop10/queue/read_ahead_kb
echo "64" > /sys/block/loop10/queue/nr_requests
echo "128" > /sys/block/loop11/queue/read_ahead_kb
echo "64" > /sys/block/loop11/queue/nr_requests
echo "128" > /sys/block/loop12/queue/read_ahead_kb
echo "64" > /sys/block/loop12/queue/nr_requests
echo "128" > /sys/block/loop13/queue/read_ahead_kb
echo "64" > /sys/block/loop13/queue/nr_requests
echo "128" > /sys/block/loop14/queue/read_ahead_kb
echo "64" > /sys/block/loop14/queue/nr_requests
echo "128" > /sys/block/loop15/queue/read_ahead_kb
echo "64" > /sys/block/loop15/queue/nr_requests
echo "128" > /sys/block/mmcblk0/queue/read_ahead_kb
echo "64" > /sys/block/mmcblk0/queue/nr_requests
echo "128" > /sys/block/ram0/queue/read_ahead_kb
echo "64" > /sys/block/ram0/queue/nr_requests
echo "128" > /sys/block/ram1/queue/read_ahead_kb
echo "64" > /sys/block/ram1/queue/nr_requests
echo "128" > /sys/block/ram2/queue/read_ahead_kb
echo "64" > /sys/block/ram2/queue/nr_requests
echo "128" > /sys/block/ram3/queue/read_ahead_kb
echo "64" > /sys/block/ram3/queue/nr_requests
echo "128" > /sys/block/ram4/queue/read_ahead_kb
echo "64" > /sys/block/ram4/queue/nr_requests
echo "128" > /sys/block/ram5/queue/read_ahead_kb
echo "64" > /sys/block/ram5/queue/nr_requests
echo "128" > /sys/block/ram6/queue/read_ahead_kb
echo "64" > /sys/block/ram6/queue/nr_requests
echo "128" > /sys/block/ram7/queue/read_ahead_kb
echo "64" > /sys/block/ram7/queue/nr_requests
echo "128" > /sys/block/ram8/queue/read_ahead_kb
echo "64" > /sys/block/ram8/queue/nr_requests
echo "128" > /sys/block/ram9/queue/read_ahead_kb
echo "64" > /sys/block/ram9/queue/nr_requests
echo "128" > /sys/block/ram10/queue/read_ahead_kb
echo "64" > /sys/block/ram10/queue/nr_requests
echo "128" > /sys/block/ram11/queue/read_ahead_kb
echo "64" > /sys/block/ram11/queue/nr_requests
echo "128" > /sys/block/ram12/queue/read_ahead_kb
echo "64" > /sys/block/ram12/queue/nr_requests
echo "128" > /sys/block/ram13/queue/read_ahead_kb 
echo "64" > /sys/block/ram13/queue/nr_requests
echo "128" > /sys/block/ram14/queue/read_ahead_kb
echo "64" > /sys/block/ram14/queue/nr_requests
echo "128" > /sys/block/ram15/queue/read_ahead_kb
echo "64" > /sys/block/ram15/queue/nr_requests
echo "128" > /sys/block/sda/queue/read_ahead_kb
echo "64" > /sys/block/sda/queue/nr_requests
echo "128" > /sys/block/sdb/queue/read_ahead_kb
echo "64" > /sys/block/sdb/queue/nr_requests
echo "128" > /sys/block/sdc/queue/read_ahead_kb
echo "64" > /sys/block/sdc/queue/nr_requests
echo "128" > /sys/block/zram0/queue/read_ahead_kb
echo "64" > /sys/block/zram0/queue/nr_requests

# Entropy
echo "128" > /proc/sys/kernel/random/read_wakeup_threshold
echo "512" > /proc/sys/kernel/random/write_wakeup_threshold

# Report
sed -Ei 's/^description=(\[.*][[:space:]]*)?/description=[ 🥶 Balance Mode... ] /g' "/data/adb/modules/ReWrite/module.prop"
am start -a android.intent.action.MAIN -e toasttext "🥶 Balance Mode..." -n bellavita.toast/.MainActivity
