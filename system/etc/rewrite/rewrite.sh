#!/system/bin/sh
# Re-WriteX
# By Ri_Butz

sleep 1

B=$MODDIR/system/etc/rewrite/rewrite_balance.sh
P=$MODDIR/system/etc/rewrite/rewrite_performance.sh
LOG=/sdcard/ReWrite.log

echo "# ReWriteX-Akira" > $LOG
echo "# Version : v5.8" >> $LOG
echo "# Build Date: 06/09/2022" >> $LOG
echo "# By Ri_Butz (Telegram)" >> $LOG
echo " " >> $LOG
echo "  • Device          : $(getprop ro.product.system.model)" >> $LOG
echo "  • Brand           : $(getprop ro.product.system.brand)" >> $LOG
echo "  • Proccessor      : $(getprop ro.product.board)" >> $LOG
echo "  • Architecture    : $(getprop ro.product.cpu.abi)" >> $LOG
echo "  • Android Version : $(getprop ro.system.build.version.release)" >> $LOG
echo "  • Kernel          : $(uname -r)" >> $LOG
echo " " >> $LOG

# Begin of AI
sed -Ei 's/^description=(\[.*][[:space:]]*)?/description=[ 🤖 Ai is started... ] /g' "/data/adb/modules/ReWrite/module.prop"
am start -a android.intent.action.MAIN -e toasttext "🤖 Ai is started..." -n bellavita.toast/.MainActivity

# Thx to @wHo_EM_i for his top script

while true; do
    sleep 10
     if [ $(dumpsys activity | grep activities | head -n 34 | grep -o -e 'ioncannon' -e 'clpeak' -e 'skynet' -e 'cputhrottlingtest' -e 'ea.gp' -e 'androbench2' -e 'com.andromeda.androbench2' -e 'andromeda' -e 'antutu' -e 'com.futuremark.dmandroid.application' -e 'futuremark' -e 'dmandroid' -e 'geekbench5' -e 'primatelabs' -e 'codm' -e 'com.mobile.legends' -e 'nexon' -e 'ea.game' -e 'konami' -e 'bandainamco' -e 'netmarble' -e 'edengames' -e 'tencent' -e 'krmobile' -e 'moonton' -e 'gameloft' -e 'netease' -e 'garena' -e 'pubg' -e 'pubgmhd' -e 'pubgmobile' -e 'miHoYo' -e 'mojang' -e 'AntutuBenchmark' -e 'aethersx2' -e 'criticalops' -e 'supercell' -e 'warface' -e 'ppsspp' -e 'ubisoft' -e 'activision' -e 'rockstargames' -e 'Fortnite' -e 'FortniteMobile' -e 'epicgames' -e 'garena' -e 'apexlegendsmobilefps' -e 'riotgames' -e 'me.pou.app' -e 'com.ngame.allstar.eu' -e 'levelinfinite' -e 'GacoGames' -e 'gacogames' -e 'carxtech' -e 'CarXTech' -e 'vespainteractive' -e 'KingsRaid' -e 'autochessmoba' -e 'com.play.rosea' -e 'bandainamcoent' -e 'asobimo' -e 'com.silentlexx.ffmpeggui' | head -n 1) ]; then
            if tail -n 1 /sdcard/Rewrite.log | grep -w "Performance"
            then
            echo " "
            else
            sh $P
            echo " " >> $LOG
            echo "=> Performance mode activated  $(date "+%H:%M:%S")" >> $LOG
            sleep 1
            fi
else
            if tail -n 1 /sdcard/Rewrite.log | grep -w "Balance"
            then
            echo " "
            else
            sh $B
            echo " " >> $LOG
            echo "=> Balance mode activated      $(date "+%H:%M:%S")" >> $LOG
            fi
fi
done
