# ##ReWriteX-Akira##

ReWriteX-Akira is an advanced version of the previously released ReWriteX Alpha and Omega

# Features:
- Kernel parameters tweak for better UX and less latency
- Zram with ram management tweak
- Gms Doze from Gloeyisk
- Dex2Oat Optimizer from Iamlooper
- Internet tweaks and DNS changer from Taka🌿
- Wifi Bonding from Simonsmh
- Balance mode: turn off cpu5-cpu7 cores and reduce other parameters to save battery
- Performance mode: turn on all cpu cores, turn off thermal(optional) and increase other parameters to improve performance
- Performance mode will only be active when playing games that I have added to the list and return to balance mode if you exit the game, so please let me know if there are games that are not supported 



# How to repack with termux on android

```
termux-setup-storage
pkg install git
pkg install zip
git clone https://gitlab.freedesktop.org/rybutz69/rewritex-akira.git
cd rewritex-akira
zip -r ../ReWriteX.Akira.zip *
cd ..
cp ReWriteX.Akira.zip /storage/emulated/0
```

# How to update

```
rm -f ReWriteX.Akira.zip
cd rewritex-akira
git pull
zip -r ../ReWriteX.Akira.zip *
cd ..
cp ReWriteX.Akira.zip /storage/emulated/0
```
