###ReWriteX-Hikari###

#Changelog

• v7.9
- Add cgroup and fscc functions from matt yang
- Enable lmk with psi instead vmpressure
- Sync art properties with dex2oat optimizer
- Zram up to 6GB
- Etc

• v7.8
- Updated the installer view and logs view
- Add fs lease_break_time
- Add gpu polling_interval
- Add option 2.5Gb zram
- Add freefire,NIKKE: Goddess of Victory and Neural Cloud to performance profile
- Enable sched_boost at performance mode and disable it on balance mode

• v7.7 Rev2
- Optimize installer
- Remove unusable tweak
- Update wifi bonding from simonsmh

• v7.6
- Move toast as user app
- Move rewrite.sh to system/bin
- Add free-fire max to performance profile
- Add some tweak to system.prop
- Etc

• v7.5
- Add more options when installing
- New schedutil tweaks(test)
- Use cfq i/o scheduler
- Add support for A13(need more tester)
- Etc

• v7.4
- Use noop i/o scheduler governor
- Fixed some minor bugs

• v7.3
- Renicer is back
- Use gms doze 1.8.5 without disable gms service, just sysconfig/google.xml
- Etc

• v7.2
- Add com.emulator.fpse64 to performance profile
- Remove renicer
- Reduce read wakeup threshold
- etc

• v7.1
- Just a little improvement 

• v7.0
- Restore some old settings for better ram management and less latency
- Enable max_phantom_proccess and reduce max_cache_proccess
- Hiding cpuinfo min freq on unity big.litte trick

• v6.9
- Just a few fixes and additions YoStarEN to performance profile

• v6.8
- Add gpu idler timer and pmqos latency
- Add support performance mode for lega.feisl.hhera
- Add Unity Big.Little trick by lybxlpsv (optional)
- Remake Stune boost
- Disable core ctl on performance mode
- etc

• v6.7
- Add renicer priority Surfaceflinger & Graphics composer
- Add cgroup boost
- Changing sched kernel settings
- Fix gms doze 
- Disable rampdumps
- etc

• v6.6
- Disable adreno snapshot crashdumper
- Increase vfs cache pressure to 50
- Add skyline.emu,org.mm.jr,com.xiaoji.gamesirnsemulator,com.github.stenzek.duckstation to performance profile

• v6.5
- Add doze mode selector(disable,light,or deep)
- Reduce vfs cache pressure
- Increase stat interval

• v6.4rev2
- Add AzurLane to performance profile

• v6.4
- Add force deep doze
- Enable force 4x MSAA

• v6.3
- Changed proc/sys/kernel value to reduce latency
- Add pmgqos_active_latency on kgsl/kgsl-3d0 

• v6.2
- Add support performance mode for app from XD entertainment 
- Bringing back some old features
- SkiaGL Optimization by @kntdreborn ! and created by @zaidannn7
- Sync gms doze 1.8.7 from Gloeyisk
- Move all i/o scheduler strings to service.sh

• v6.1
- Renamed ReWriteX Hikari
- Add dns from AdGuard,OpenDns,Quad9,and uncensored dns
- Remove status mode on description module
- Remove iorapd (unstable more heating on some devices)

• v6.0
- Add Hwui tweak from pixel device
- Add SurfaceFlinger tweak from pixel device
- Add notification
- Enable iorapd
- Remove useless script
- Etc

• v5.8
- Disable printk
- Disable some debug
- Disable kernel tracking
- Disable kernel panic
- Disable fsync
- OpenGL as default render ui
- Support game from asobimo.inc
- Support app ffmpeggui 

• v5.7
- Light profile lmk from smartpack
- Remove devfreq
- Increase top-app stune boost

• v5.6
- Add support RagnarokX and KingsRaid
- Light profile LMK

•v5.5
- Reduce top-app stune boost
- Enable cpu5 on balance mode
- Move toast app to system/app

•v5.4
- Remove internet tweaks(unstable)
- Add toast notification 

•v5.3
- Add zram size options (2gb,3gb,or 4gb)

•v5.2
- Reduce top-app stune boost on performance mode
