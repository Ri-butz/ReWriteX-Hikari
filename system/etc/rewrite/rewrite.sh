#!/system/bin/sh
# Re-WriteX
# By Ri_Butz

sleep 1

B=$MODDIR/system/etc/rewrite/rewrite_balance.sh
P=$MODDIR/system/etc/rewrite/rewrite_performance.sh
LOG=/storage/emulated/0/ReWrite.log

echo "# ReWriteX-Hikari" > $LOG
echo "# Version : v7.5" >> $LOG
echo "# Build Date: 04/11/2022" >> $LOG
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
    sleep 5
     if [ $(dumpsys activity | grep activity=activities | head -n 34 | grep -o -e 'com.emulator.fpse64' -e 'lega.feisl.hhera' -e 'com.github.stenzek.duckstation' -e 'org.mm.jr' -e 'gamesirnsemulator' -e 'skyline.emu' -e 'nextgen' -e 'YoStarJP' -e 'YoStarEN' -e 'bluearchive' -e 'Arknights' -e 'AzurLane' -e 'ioncannon' -e 'clpeak' -e 'skynet' -e 'cputhrottlingtest' -e 'ea.gp' -e 'roblox' -e 'androbench2' -e 'com.andromeda.androbench2' -e 'andromeda' -e 'antutu' -e 'com.futuremark.dmandroid.application' -e 'futuremark' -e 'dmandroid' -e 'geekbench5' -e 'adventure.rpg.anime.game.vng.ys6' -e 'primatelabs' -e 'codm' -e 'com.mobile.legends' -e 'nexon' -e 'ea.game' -e 'konami' -e 'bandainamco' -e 'netmarble' -e 'edengames' -e 'tencent' -e 'krmobile' -e 'moonton' -e 'gameloft' -e 'netease' -e 'garena' -e 'pubg' -e 'pubgmhd' -e 'pubgmobile' -e 'miHoYo' -e 'mojang' -e 'AntutuBenchmark' -e 'aethersx2' -e 'criticalops' -e 'supercell' -e 'warface' -e 'ppsspp' -e 'ubisoft' -e 'activision' -e 'rockstargames' -e 'Fortnite' -e 'FortniteMobile' -e 'epicgames' -e 'garena' -e 'apexlegendsmobilefps' -e 'riotgames' -e 'me.pou.app' -e 'com.ngame.allstar.eu' -e 'levelinfinite' -e 'GacoGames' -e 'gacogames' -e 'carxtech' -e 'CarXTech' -e 'vespainteractive' -e 'KingsRaid' -e 'autochessmoba' -e 'com.play.rosea' -e 'bandainamcoent' -e 'asobimo' -e 'com.silentlexx.ffmpeggui' -e 'cyou.joiplay.joiplay' -e 'glip.gg' -e 'battlefun' -e 'clgame' -e 'com.GlobalSoFunny' -e 'com.xd' -e 'com.pinkcore.heros' -e 'rayark' | head -n 1) ]; then
            if tail -n 1 /storage/emulated/0/Rewrite.log | grep -w "Performance"
            then
            echo " "
            else
            sh $P
            echo " " >> $LOG
            echo "=> Performance mode activated  $(date "+%H:%M:%S")" >> $LOG
            sleep 50
            fi
else
            if tail -n 1 /storage/emulated/0/Rewrite.log | grep -w "Balance"
            then
            echo " "
            else
            sh $B
            echo " " >> $LOG
            echo "=> Balance mode activated      $(date "+%H:%M:%S")" >> $LOG
            fi
fi
done
