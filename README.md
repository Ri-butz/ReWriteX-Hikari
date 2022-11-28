# ##ReWriteX-Hikari##

ReWriteX-Hikari is an advanced version of the previously released ReWriteX Alpha and Omega

# Features:
- Kernel parameters tweak for better UX and less latency
- Zram with ram management tweak
- Gms Doze from Gloeyisk
- Dex2Oat Optimizer from Iamlooper
- Internet tweaks and DNS changer from Taka🌿
- Wifi Bonding from Simonsmh
- Unity Big.Little trick from lybxlpsv
- Balance mode: turn off cpu6-cpu7 cores and reduce other parameters to save battery
- Performance mode: turn on all cpu cores, turn off thermal(optional) and increase other parameters to improve performance
- Performance mode will only be active when playing games that I have added to the list and return to balance mode if you exit the game, so please let me know if there are games that are not supported 
- And etc


# How to repack with termux on android

```
termux-setup-storage
pkg install git
pkg install zip
git clone https://github.com/Ri-Butz/ReWriteX-Hikari.git
cd ReWriteX-Hikari
zip -r ../ReWriteX.Hikari.zip *
cd ..
cp ReWriteX.Hikari.zip /storage/emulated/0
```

# How to update

```
rm -f ReWriteX.Hikari.zip
cd ReWriteX-Hikari
git pull
zip -r ../ReWriteX.Hikari.zip *
cd ..
cp ReWriteX.Hikari.zip /storage/emulated/0
```

# Thanks To

- Allah swt
- [Gloeyisk](https://github.com/gloeyisk)
- [NotZeetaa](https://github.com/NotZeetaa)
- [IamLooper](https://github.com/iamlooper)
- [Taka🌿](https://github.com/takeru-kageyuki)
- [Simonsmh](https://github.com/simonsmh)
- [Pedrozzz0](https://github.com/King-Projects)
- [Niko Schwickert](https://github.com/feravolt)
- [lybxlpsv](https://github.com/lybdroid)
- [DESIRE](https://t.me/SMOOTH_Team)
- And all my friends who contributed to the development of the project and many others
