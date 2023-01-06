#!/system/bin/sh

# Get cpu max freq
FREQ0=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq)
FREQ1=$(cat /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq)
FREQ2=$(cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq)
FREQ3=$(cat /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq)
FREQ4=$(cat /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq)
FREQ5=$(cat /sys/devices/system/cpu/cpu5/cpufreq/scaling_max_freq)
FREQ6=$(cat /sys/devices/system/cpu/cpu6/cpufreq/scaling_max_freq)
FREQ7=$(cat /sys/devices/system/cpu/cpu7/cpufreq/scaling_max_freq)

# Functions
schedutil_tunables_game03()
{
  #cpu0
   echo "$FREQ0" > /sys/devices/system/cpu/cpu0/cpufreq/schedutil/hispeed_freq
   echo "80" > /sys/devices/system/cpu/cpu0/cpufreq/schedutil/hispeed_load
   echo "0" > /sys/devices/system/cpu/cpu0/cpufreq/schedutil/up_rate_limit_us
   echo "0" > /sys/devices/system/cpu/cpu0/cpufreq/schedutil/down_rate_limit_us
   echo "0" > /sys/devices/system/cpu/cpu0/cpufreq/schedutil/pl

  #cpu1
   echo "$FREQ1" > /sys/devices/system/cpu/cpu1/cpufreq/schedutil/hispeed_freq
   echo "80" > /sys/devices/system/cpu/cpu1/cpufreq/schedutil/hispeed_load
   echo "0" > /sys/devices/system/cpu/cpu1/cpufreq/schedutil/up_rate_limit_us
   echo "0" > /sys/devices/system/cpu/cpu1/cpufreq/schedutil/down_rate_limit_us
   echo "0" > /sys/devices/system/cpu/cpu1/cpufreq/schedutil/pl

  #cpu2
   echo "$FREQ2" > /sys/devices/system/cpu/cpu2/cpufreq/schedutil/hispeed_freq
   echo "80" > /sys/devices/system/cpu/cpu2/cpufreq/schedutil/hispeed_load
   echo "0" > /sys/devices/system/cpu/cpu2/cpufreq/schedutil/up_rate_limit_us
   echo "0" > /sys/devices/system/cpu/cpu2/cpufreq/schedutil/down_rate_limit_us
   echo "0" > /sys/devices/system/cpu/cpu2/cpufreq/schedutil/pl

  #cpu3
   echo "$FREQ3" > /sys/devices/system/cpu/cpu3/cpufreq/schedutil/hispeed_freq
   echo "80" > /sys/devices/system/cpu/cpu3/cpufreq/schedutil/hispeed_load
   echo "0" > /sys/devices/system/cpu/cpu0/cpufreq/schedutil/up_rate_limit_us
   echo "0" > /sys/devices/system/cpu/cpu0/cpufreq/schedutil/down_rate_limit_us
   echo "0" > /sys/devices/system/cpu/cpu0/cpufreq/schedutil/pl
}

schedutil_tunables_game47()
{
  #cpu4
   echo "$FREQ4" > /sys/devices/system/cpu/cpu4/cpufreq/schedutil/hispeed_freq
   echo "80" > /sys/devices/system/cpu/cpu4/cpufreq/schedutil/hispeed_load
   echo "0" > /sys/devices/system/cpu/cpu4/cpufreq/schedutil/up_rate_limit_us
   echo "0" > /sys/devices/system/cpu/cpu4/cpufreq/schedutil/down_rate_limit_us
   echo "0" > /sys/devices/system/cpu/cpu4/cpufreq/schedutil/pl

  #cpu5
   echo "$FREQ5" > /sys/devices/system/cpu/cpu5/cpufreq/schedutil/hispeed_freq
   echo "0" > /sys/devices/system/cpu/cpu5/cpufreq/schedutil/hispeed_load
   echo "0" > /sys/devices/system/cpu/cpu5/cpufreq/schedutil/up_rate_limit_us
   echo "0" > /sys/devices/system/cpu/cpu5/cpufreq/schedutil/down_rate_limit_us
   echo "0" > /sys/devices/system/cpu/cpu5/cpufreq/schedutil/pl

  #cpu6
   echo "$FREQ6" > /sys/devices/system/cpu/cpu6/cpufreq/schedutil/hispeed_freq
   echo "80" > /sys/devices/system/cpu/cpu6/cpufreq/schedutil/hispeed_load
   echo "0" > /sys/devices/system/cpu/cpu6/cpufreq/schedutil/up_rate_limit_us
   echo "0" > /sys/devices/system/cpu/cpu6/cpufreq/schedutil/down_rate_limit_us
   echo "0" > /sys/devices/system/cpu/cpu6/cpufreq/schedutil/pl

  #cpu7
   echo "$FREQ7" > /sys/devices/system/cpu/cpu7/cpufreq/schedutil/hispeed_freq
   echo "80" > /sys/devices/system/cpu/cpu7/cpufreq/schedutil/hispeed_load
   echo "0" > /sys/devices/system/cpu/cpu7/cpufreq/schedutil/up_rate_limit_us
   echo "0" > /sys/devices/system/cpu/cpu7/cpufreq/schedutil/down_rate_limit_us
   echo "0" > /sys/devices/system/cpu/cpu7/cpufreq/schedutil/pl
}

# Disable Thermal
stop thermal-engine
stop vendor.thermal-engine

# Governor
##cpu0-3
  for gov in /sys/devices/system/cpu/cpu[0,1,2,3]/cpufreq
  do
    echo "schedutil" > $gov/scaling_governor
  done
##cpu4-7
  for gov in /sys/devices/system/cpu/cpu[4,5,6,7]/cpufreq
  do
    echo "schedutil" > $gov/scaling_governor
  done

# Schedutil tunables
schedutil_tunables_game03
schedutil_tunables_game47

# Core ctl
for cctl in /sys/devices/system/cpu/*/core_ctl
do
  chmod 666 $cctl/enable
  echo "0" > $cctl/enable
  chmod 444 $cctl/enable
done

# Top app
echo "70" > /dev/stune/top-app/schedtune.boost
echo "1" > /dev/stune/top-app/schedtune.sched_boost_no_override

# Foreground
echo "70" > /dev/stune/top-app/schedtune.boost
echo "1" > /dev/stune/top-app/schedtune.sched_boost_no_override

# GPU settings
for gpu in /sys/class/kgsl/kgsl-3d0
do
  echo "0" > $gpu/throttling
  echo "0" > $gpu/bus_split
  echo "1" > $gpu/force_clk_on
  echo "1" > $gpu/force_bus_on
  echo "1" > $gpu/force_rail_on
  echo "1" > $gpu/force_no_nap
  echo "4" > $gpu/devfreq/polling_interval
  echo "1000000" > $gpu/idle_timer
done

# Sched boost
echo "1" > /proc/sys/kernel/sched_boost

# Fs
echo "5" > /proc/sys/fs/lease-break-time

# Entropy
echo "512" > /proc/sys/kernel/random/read_wakeup_threshold
echo "2048" > /proc/sys/kernel/random/write_wakeup_threshold

# Fstrim
fstrim /data
fstrim /cache
fstrim /system
fstrim /vendor

# Clear pagecache, dentries, and inodes
sync; echo "1" > /proc/sys/vm/drop_caches
am kill-all

# Report
sed -Ei 's/^description=(\[.*][[:space:]]*)?/description=[ 🎮 Gaming Mode... ] /g' "/data/adb/modules/ReWrite/module.prop"
am start -a android.intent.action.MAIN -e toasttext "🎮 Gaming Mode..." -n bellavita.toast/.MainActivity
