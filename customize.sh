#!/sbin/sh

SKIPUNZIP=1


# Set what you want to display when installing your module

ui_print "██████████████████████████████"
ui_print " ______                            __         __ "
ui_print " |  _  \                    _      \ \       / / "
ui_print " | |_)  |___ _  _  ______ _| |    __\ \     / /  "
ui_print " |  _  // _ \ || || |  __/_\ |__ / _ \ \   / /   "
ui_print " | | \ \  __/ || || | |  | | |__|  __/\ \_/ /    "
ui_print " |_|  \_\___\_______/_|  |_|_____\___| \   /     "
ui_print " | |   | |                             / _ \     "
ui_print " | |___| |_ _  _ _________ _          / / \ \    "
ui_print " |  ___  |_\ |/ / _  |  __/_\        / /   \ \   "
ui_print " | |   | | |   < (_| | |  | |       / /     \ \  "
ui_print " |_|   |_|_|_|\_\____|_|  |_|      /_/       \_\ "
ui_print " "
ui_print "██████████████████████████████"
sleep 0.5
ui_print " "
ui_print " Module info: "
sleep 0.5
ui_print " • Name            : ReWriteX-Hikari"
sleep 0.5
ui_print " • Version         : v8.4 "
sleep 0.5
ui_print " • Release Date    : 06-01-2023"
sleep 0.5
ui_print " • Owner           : Ri_Butz "
sleep 0.5
ui_print " "
ui_print " Device info:"
sleep 0.5
ui_print " • Brand           : $(getprop ro.product.system.brand) "
sleep 0.5
ui_print " • Device          : $(getprop ro.product.system.model) "
sleep 0.5
ui_print " • Processor       : $(getprop ro.product.board) "
sleep 0.5
ui_print " • Android Version : $(getprop ro.system.build.version.release) "
sleep 0.5
ui_print " • SDK Version     : $(getprop ro.build.version.sdk) "
sleep 0.5
ui_print " • Architecture    : $(getprop ro.product.cpu.abi) "
sleep 0.5
ui_print " • Kernel Version  : $(uname -r) "
sleep 0.5
ui_print " "
ui_print " Thanks To:"
sleep 0.2
ui_print " • Allah swt"
sleep 0.2
ui_print " • wHo_EM_i & NotZeetaa"
sleep 0.2
ui_print " • tytydraco"
sleep 0.2
ui_print " • Simonsmh"
sleep 0.2
ui_print " • Gloeyisk"
sleep 0.2
ui_print " • Taka🌿"
sleep 0.2
ui_print " • Pedrozzz0"
sleep 0.2
ui_print " • iamlooper"
sleep 0.2
ui_print " • lybxlpsv"
sleep 0.2
ui_print " • Niko Schwickert"
sleep 0.2
ui_print " • Matt Yang"
sleep 0.2
ui_print " • 𝘿𝙀𝙎𝙄𝙍𝙀 🇷🇺"
sleep 0.2
ui_print " • All my friends who contributed to the"
ui_print "   development of the project and many others"
ui_print " "
ui_print "██████████████████████████████"

# Checking for installation environment
if [ $BOOTMODE = true ]; then
ROOT=$(find `magisk --path` -type d -name "mirror" | head -n 1)
ui_print "- Root path: $ROOT"
else
ROOT=""
fi

# Extract module files
ui_print "- Extracting module files"
unzip -o "$ZIPFILE" 'addon/*' -d $MODPATH >&2
unzip -o "$ZIPFILE" 'system/*' -d $MODPATH >&2
unzip -o "$ZIPFILE" module.prop -d $MODPATH >&2
unzip -o "$ZIPFILE" post-fs-data.sh -d $MODPATH >&2
unzip -o "$ZIPFILE" service.sh -d $MODPATH >&2
unzip -o "$ZIPFILE" system.prop -d $MODPATH >&2
unzip -o "$ZIPFILE" Toast.apk -d $MODPATH >&2
unzip -o "$ZIPFILE" uninstall.sh -d $MODPATH >&2

# Dex2oat opt
dex2oat_enable() {
[[ "$IS64BIT" == "true" ]] && mv -f "$MODPATH/system/bin/dex2oat_opt64" "$MODPATH/system/bin/dex2oat_opt" && rm -f $MODPATH/system/bin/dex2oat_opt32 || mv -f "$MODPATH/system/bin/dex2oat_opt32" "$MODPATH/system/bin/dex2oat_opt" && rm -f $MODPATH/system/bin/dex2oat_opt64
}

# Wifi bonding
wifibonding_enable() {
[ -x "$(which magisk)" ] && MIRRORPATH=$(magisk --path)/.magisk/mirror || unset MIRRORPATH
array=$(find /system /vendor /product /system_ext -name WCNSS_qcom_cfg.ini)
for CFG in $array
do
[[ -f $CFG ]] && [[ ! -L $CFG ]] && {
SELECTPATH=$CFG
mkdir -p `dirname $MODPATH$CFG`
cp -af $MIRRORPATH$SELECTPATH $MODPATH$SELECTPATH
sed -i '/gChannelBondingMode24GHz=/d;/gChannelBondingMode5GHz=/d;/gForce1x1Exception=/d;/sae_enabled=/d;s/^END$/gChannelBondingMode24GHz=1\ngChannelBondingMode5GHz=1\ngForce1x1Exception=0\nsae_enabled=1\nEND/g' $MODPATH$SELECTPATH
}
done
[[ -z $SELECTPATH ]] && abort "- Installation FAILED. Your device didn't support WCNSS_qcom_cfg.ini." || { mkdir -p $MODPATH/system; mv -f $MODPATH/vendor $MODPATH/system/vendor; mv -f $MODPATH/product $MODPATH/system/product; mv -f $MODPATH/system_ext $MODPATH/system/system_ext;}
}

# Run addons
if [ "$(ls -A $MODPATH/addon/*/install.sh 2>/dev/null)" ]; then
  ui_print "- Running Addons"
  for i in $MODPATH/addon/*/install.sh; do
    ui_print "  Running $(echo $i | sed -r "s|$MODPATH/addon/(.*)/install.sh|\1|")..."
    . $i
  done
fi

ui_print "" 
ui_print "  Volume Key Selector to select options:"
ui_print "  1) Powersave governor for cpu4-7 in balance mode"
ui_print "  2) Disable thermal engine"
ui_print "  3) Dex2oat Optimizer"
ui_print "  4) Zram size"
ui_print "  5) Doze Mode"
ui_print "  6) Unity Big.Little trick"
ui_print "  7) Wifi bonding"
ui_print "  8) DNS changer"
ui_print ""
ui_print "  Button Function:"
ui_print "  • Volume + (Next)"
ui_print "  • Volume - (Select)"
ui_print ""
sleep 3

ui_print "  ⚠️Powersave governor for cpu4-7 in balance mode..."
ui_print "    1. Yes (more battery saving but laggy on some devices"
ui_print "    2. No"
ui_print ""
ui_print "    Select:"
RWX=1
while true; do
    ui_print "    $RWX"
    if $VKSEL; then
        RWX=$((RWX + 1))
    else
        break
    fi
    if [ $RWX -gt 2 ]; then
        RWX=1
    fi
done
ui_print "    Selected: $RWX"
case $RWX in
    1 ) TEXTRWX="🟢Yes"; sed -i '/GOV47=custom/s/.*/GOV47=powersave/' $MODPATH/system/etc/rewrite/rewrite_balance.sh;;
    2 ) TEXTRWX="🔴No"; sed -i '/GOV47=custom/s/.*/GOV47=schedutil/' $MODPATH/system/etc/rewrite/rewrite_balance.sh; sed -i '/#schedutil_tunables_bal47/s/.*/schedutil_tunables_bal47/' $MODPATH/system/etc/rewrite/rewrite_balance.sh;;
esac
ui_print "    $TEXTRWX"
ui_print ""

ui_print "  ⚠️Disable thermal engine..."
ui_print "    1. Yes"
ui_print "    2. No"
ui_print ""
ui_print "    Select:"
A=1
while true; do
    ui_print "    $A"
    if $VKSEL; then
        A=$((A + 1))
    else
        break
    fi
    if [ $A -gt 2 ]; then
        A=1
    fi
done
ui_print "    Selected: $A"
case $A in
    1 ) TEXT1="🟢Yes";;
    2 ) TEXT1="🔴No"; sed -i '/start thermal-engine/s/.*/#start thermal-engine/' $MODPATH/system/etc/rewrite/rewrite_balance.sh; sed -i '/start vendor.thermal-engine/s/.*/#start vendor.thermal-engine/' $MODPATH/system/etc/rewrite/rewrite_balance.sh; sed -i '/stop thermal-engine/s/.*/#stop thermal-engine/' $MODPATH/system/etc/rewrite/rewrite_gaming.sh; sed -i '/stop vendor.thermal-engine/s/.*/#stop vendor.thermal-engine/' $MODPATH/system/etc/rewrite/rewrite_gaming.sh;;
esac
ui_print "    $TEXT1"
ui_print ""

ui_print "  ⚠️Dex2oat Optimizer..."
ui_print "    1. Enable"
ui_print "    2. Disable"
ui_print ""
ui_print "    Select:"
B=1
while true; do
    ui_print "    $B"
    if $VKSEL; then
        B=$((B + 1))
    else
        break
    fi
    if [ $B -gt 2 ]; then
        B=1
    fi
done
ui_print "    Selected: $B"
case $B in
    1 ) TEXT2="🟢Enable"; sed -i '/#DO/s/.*/# Dex2oat optimizer by Iamlooper(enable)/' $MODPATH/service.sh; dex2oat_enable;;
    2 ) TEXT2="🔴Disable"; rm -rf $MODPATH/system/bin/dex2oat*;sed -i '/#DO/s/.*/# Dexoat optimizer by Iamlooper(disable)/' $MODPATH/service.sh; sed -i '/Dex2oat/s/.*/#deleted/' $MODPATH/service.sh; sed -i '/dex2oat_opt/s/.*/#deleted/' $MODPATH/service.sh; sed -i '/sleep 15/s/.*/#deleted/' $MODPATH/service.sh;;
esac
ui_print "    $TEXT2"
ui_print ""

ui_print "  ⚠️Zram size..."
ui_prui_print "  ⚠️Zram size..."
ui_print "    1. Default(using default zram from device)"
ui_print "    2. Disable/0MB"
ui_print "    3. 512MB"
ui_print "    4. 1024MB"
ui_print "    5. 1536MB"
ui_print "    6. 2048MB"
ui_print "    7. 2560MB"
ui_print "    8. 3072MB"
ui_print "    9. 4096MB"
ui_print "    10. 5120MB"
ui_print "    11. 6144MB"
ui_print ""
ui_print "    Select:"
C=1
while true; do
    ui_print "    $C"
    if $VKSEL; then
        C=$((C + 1))
    else
        break
    fi
    if [ $C -gt 11 ]; then
        C=1
    fi
done
ui_print "    Selected: $C"
case $C in
    1 ) TEXT3="🔵Default";;
    2 ) TEXT3="🔴Disable/OMB"; sed -i '/#change_zram/s/.*/change_zram/' $MODPATH/service.sh;;
    3 ) TEXT3="🟢512MB"; sed -i '/ZRAMSIZE=0/s/.*/ZRAMSIZE=512M/' $MODPATH/service.sh; sed -i '/#change_zram/s/.*/change_zram/' $MODPATH/service.sh;;
    4 ) TEXT3="🟢1024MB"; sed -i '/ZRAMSIZE=0/s/.*/ZRAMSIZE=1024M/' $MODPATH/service.sh; sed -i '/#change_zram/s/.*/change_zram/' $MODPATH/service.sh;;
    5 ) TEXT3="🟢1536MB"; sed -i '/ZRAMSIZE=0/s/.*/ZRAMSIZE=1536M/' $MODPATH/service.sh; sed -i '/#change_zram/s/.*/change_zram/' $MODPATH/service.sh;;
    6 ) TEXT3="🟢2048MB"; sed -i '/ZRAMSIZE=0/s/.*/ZRAMSIZE=2048M/' $MODPATH/service.sh; sed -i '/#change_zram/s/.*/change_zram/' $MODPATH/service.sh;;
    7 ) TEXT3="🟢2560MB"; sed -i '/ZRAMSIZE=0/s/.*/ZRAMSIZE=2560M/' $MODPATH/service.sh; sed -i '/#change_zram/s/.*/change_zram/' $MODPATH/service.sh;;
    8 ) TEXT3="🟢3072MB"; sed -i '/ZRAMSIZE=0/s/.*/ZRAMSIZE=3072M/' $MODPATH/service.sh; sed -i '/#change_zram/s/.*/change_zram/' $MODPATH/service.sh;;
    9 ) TEXT3="🟢4096MB"; sed -i '/ZRAMSIZE=0/s/.*/ZRAMSIZE=4096M/' $MODPATH/service.sh; sed -i '/#change_zram/s/.*/change_zram/' $MODPATH/service.sh;;
    10 ) TEXT3="🟢5120MB"; sed -i '/ZRAMSIZE=0/s/.*/ZRAMSIZE=5120M/' $MODPATH/service.sh; sed -i '/#change_zram/s/.*/change_zram/' $MODPATH/service.sh;;
    11 ) TEXT3="🟢6144MB"; sed -i '/ZRAMSIZE=0/s/.*/ZRAMSIZE=6144M/' $MODPATH/service.sh; sed -i '/#change_zram/s/.*/change_zram/' $MODPATH/service.sh;;
esac
ui_print "    $TEXT3"
ui_print ""

ui_print "  ⚠️Doze Mode..."
ui_print "    1. Default(use default phone dozing mode)"
ui_print "    2. Light"
ui_print "    3. Deep"
ui_print "    4. Disable"
ui_print ""
ui_print "    Select:"
D=1
while true; do
    ui_print "    $D"
    if $VKSEL; then
        D=$((D + 1))
    else
        break
    fi
    if [ $D -gt 4 ]; then
        D=1
    fi
done
ui_print "    Selected: $D"
case $D in
    1 ) TEXT4="🔵Default"; sed -i '/# Doze mode/s/.*/# Doze mode(Default)/' $MODPATH/service.sh; sed -i '/#dumpsysdeviceidle/s/.*/#using default phone doze mode/' $MODPATH/service.sh; sed -i '/#deep doze/s/.*/#deleted/' $MODPATH/service.sh;;
    2 ) TEXT4="🟢Light"; sed -i '/# Doze mode/s/.*/# Doze mode(Light)/' $MODPATH/service.sh; sed -i '/#dumpsysdeviceidle/s/.*/dumpsys deviceidle enable light/' $MODPATH/service.sh;;
    3 ) TEXT4="🟤Deep"; sed -i '/# Doze mode/s/.*/# Doze mode(Deep)/' $MODPATH/service.sh; sed -i '/#dumpsysdeviceidle/s/.*/dumpsys deviceidle enable/' $MODPATH/service.sh; sed -i '/#deep doze/s/.*/dumpsys deviceidle force-idle/' $MODPATH/service.sh;;
    4 ) TEXT4="🔴Disable"; sed -i '/# Doze mode/s/.*/# Doze mode(Disable)/' $MODPATH/service.sh; sed -i '/#dumpsysdeviceidle/s/.*/dumpsys deviceidle disable/' $MODPATH/service.sh;;
esac
ui_print "    $TEXT4"
ui_print ""

ui_print "  ⚠️Unity Big.Little trick..."
ui_print "    1. Enable"
ui_print "    2. Disable"
ui_print ""
ui_print "    Select:"
E=1
while true; do
    ui_print "    $E"
    if $VKSEL; then
        E=$((E + 1))
    else
        break
    fi
    if [ $E -gt 2 ]; then
        E=1
    fi
done
ui_print "    Selected: $E"
case $E in
    1 ) TEXT5="🟢Enable"; sed -i '/# Unity Big.Little trick by lybxlpsv/s/.*/# Unity Big.Little trick by lybxlpsv(Enable)/' $MODPATH/service.sh; unzip -o "$ZIPFILE" 'script/*' -d $MODPATH >&2;;
    2 ) TEXT5="🔴Disable"; sed -i '/# Unity Big.Little trick by lybxlpsv/s/.*/# Unity Big.Little trick by lybxlpsv(Disable)/' $MODPATH/service.sh; sed -i '/nohup/s/.*/#deleted/' $MODPATH/service.sh;;
esac
ui_print "    $TEXT5"
ui_print ""

ui_print "  ⚠️Wifi Bonding..."
ui_print "    1. Enable"
ui_print "    2. Disable"
ui_print ""
ui_print "    Select:"
F=1
while true; do
    ui_print "    $F"
    if $VKSEL; then
        F=$((F + 1))
    else
        break
    fi
    if [ $F -gt 2 ]; then
        F=1
    fi
done
ui_print "    Selected: $F"
case $F in
    1 ) TEXT6="🟢Enable"; wifibonding_enable;;
    2 ) TEXT6="🔴Disable";;
esac
ui_print "    $TEXT6"
ui_print ""

ui_print "  ⚠️DNS Changer..."
ui_print "    1. Disable (Without DNS)"
ui_print "    2. Cloudflare DNS"
ui_print "    3. Google DNS"
ui_print "    4. AdGuard DNS"
ui_print "    5. OpenDns"
ui_print "    6. Quad9 DNS"
ui_print "    7. Uncensored DNS"
ui_print ""
ui_print "    Select:"
G=1
while true; do
    ui_print "    $G"
    if $VKSEL; then
        G=$((G + 1))
    else
        break
    fi
    if [ $G -gt 7 ]; then
        G=1
    fi
done
ui_print "    Selected: $G"
case $G in
    1 ) TEXT7="🔴Disable (Without DNS)"; rm -rf $MODPATH/system/etc/resolv.conf 2>/dev/null; sed -i '/resetprop -n net.dns1/s/.*/# resetprop -n net.dns1/' $MODPATH/service.sh; sed -i '/resetprop -n net.dns2/s/.*/# resetprop -n net.dns2/' $MODPATH/service.sh; sed -i '/resetprop -n net.eth0.dns1/s/.*/# resetprop -n net.eth0.dns1/' $MODPATH/service.sh; sed -i '/resetprop -n net.eth0.dns2/s/.*/# resetprop -n net.eth0.dns2/' $MODPATH/service.sh; sed -i '/resetprop -n net.ppp0.dns1/s/.*/# resetprop -n net.ppp0.dns1/' $MODPATH/service.sh; sed -i '/resetprop -n net.ppp0.dns2/s/.*/# resetprop -n net.ppp0.dns2/' $MODPATH/service.sh; sed -i '/resetprop -n net.rmnet0.dns1/s/.*/# resetprop -n net.rmnet0.dns1/' $MODPATH/service.sh; sed -i '/resetprop -n net.rmnet0.dns2/s/.*/# resetprop -n net.rmnet0.dns2/' $MODPATH/service.sh; sed -i '/resetprop -n net.rmnet1.dns1/s/.*/# resetprop -n net.rmnet1.dns1/' $MODPATH/service.sh; sed -i '/resetprop -n net.rmnet1.dns2/s/.*/# resetprop -n net.rmnet1.dns2/' $MODPATH/service.sh; sed -i '/resetprop -n net.pdpbr1.dns1/s/.*/# resetprop -n net.pdpbr1.dns1/' $MODPATH/service.sh; sed -i '/resetprop -n net.pdpbr1.dns2/s/.*/# resetprop -n net.pdpbr1.dns2/' $MODPATH/service.sh; sed -i '/resetprop -n net.lte.dns1/s/.*/# resetprop -n net.lte.dns1/' $MODPATH/service.sh; sed -i '/resetprop -n net.lte.dns2/s/.*/# resetprop -n net.lte.dns2/' $MODPATH/service.sh; sed -i '/# DNS Changer/s/.*/# DNS Changer (disable)/' $MODPATH/service.sh; sed -i '/iptables -t nat -A OUTPUT -p tcp --dport 53 -j DNAT --to-destination :53/s/.*/# iptables -t nat -A OUTPUT -p tcp --dport 53 -j DNAT --to-destination :53/' $MODPATH/service.sh; sed -i '/iptables -t nat -A OUTPUT -p udp --dport 53 -j DNAT --to-destination :53/s/.*/# iptables -t nat -A OUTPUT -p udp --dport 53 -j DNAT --to-destination :53/' $MODPATH/service.sh; sed -i '/iptables -t nat -I OUTPUT -p tcp --dport 53 -j DNAT --to-destination :53/s/.*/# iptables -t nat -I OUTPUT -p tcp --dport 53 -j DNAT --to-destination :53/' $MODPATH/service.sh; sed -i '/iptables -t nat -I OUTPUT -p udp --dport 53 -j DNAT --to-destination :53/s/.*/# iptables -t nat -I OUTPUT -p udp --dport 53 -j DNAT --to-destination :53/' $MODPATH/service.sh; sed -i '/# DNS Changer/s/.*/# DNS Changer (disable)/' $MODPATH/system.prop; sed -i '/net.dns1/s/.*/# net.dns1/' $MODPATH/system.prop; sed -i '/net.dns2/s/.*/# net.dns2/' $MODPATH/system.prop; sed -i '/net.eth0.dns1/s/.*/# net.eth0.dns1/' $MODPATH/system.prop; sed -i '/net.eth0.dns2/s/.*/# net.eth0.dns2/' $MODPATH/system.prop; sed -i '/net.ppp0.dns1/s/.*/# net.ppp0.dns1/' $MODPATH/system.prop; sed -i '/net.ppp0.dns2/s/.*/# net.ppp0.dns2/' $MODPATH/system.prop; sed -i '/net.rmnet0.dns1/s/.*/# net.rmnet0.dns1/' $MODPATH/system.prop; sed -i '/net.rmnet0.dns2/s/.*/# net.rmnet0.dns2/' $MODPATH/system.prop; sed -i '/net.rmnet1.dns1/s/.*/# net.rmnet1.dns1/' $MODPATH/system.prop; sed -i '/net.rmnet1.dns2/s/.*/# net.rmnet1.dns2/' $MODPATH/system.prop; sed -i '/net.pdpbr1.dns1/s/.*/# net.pdpbr1.dns1/' $MODPATH/system.prop; sed -i '/net.pdpbr1.dns2/s/.*/# net.pdpbr1.dns2/' $MODPATH/system.prop; sed -i '/net.lte.dns1/s/.*/# net.lte.dns1/' $MODPATH/system.prop; sed -i '/net.lte.dns2/s/.*/# net.lte.dns2/' $MODPATH/system.prop;;
    2 ) TEXT7="🟢Cloudflare DNS"; sed -i '/nameserver1/s/.*/nameserver 1.1.1.1/' $MODPATH/system/etc/resolv.conf; sed -i '/nameserver2/s/.*/nameserver 1.0.0.1/' $MODPATH/system/etc/resolv.conf; sed -i '/resetprop -n net.dns1/s/.*/resetprop -n net.dns1 1.1.1.1/' $MODPATH/service.sh; sed -i '/resetprop -n net.dns2/s/.*/resetprop -n net.dns2 1.0.0.1/' $MODPATH/service.sh; sed -i '/resetprop -n net.eth0.dns1/s/.*/resetprop -n net.eth0.dns1 1.1.1.1/' $MODPATH/service.sh; sed -i '/resetprop -n net.eth0.dns2/s/.*/resetprop -n net.eth0.dns2 1.0.0.1/' $MODPATH/service.sh; sed -i '/resetprop -n net.ppp0.dns1/s/.*/resetprop -n net.ppp0.dns1 1.1.1.1/' $MODPATH/service.sh; sed -i '/resetprop -n net.ppp0.dns2/s/.*/resetprop -n net.ppp0.dns2 1.0.0.1/' $MODPATH/service.sh; sed -i '/resetprop -n net.rmnet0.dns1/s/.*/resetprop -n net.rmnet0.dns1 1.1.1.1/' $MODPATH/service.sh; sed -i '/resetprop -n net.rmnet0.dns2/s/.*/resetprop -n net.rmnet0.dns2 1.0.0.1/' $MODPATH/service.sh; sed -i '/resetprop -n net.rmnet1.dns1/s/.*/resetprop -n net.rmnet1.dns1 1.1.1.1/' $MODPATH/service.sh; sed -i '/resetprop -n net.rmnet1.dns2/s/.*/resetprop -n net.rmnet1.dns2 1.0.0.1/' $MODPATH/service.sh; sed -i '/resetprop -n net.pdpbr1.dns1/s/.*/resetprop -n net.pdpbr1.dns1 1.1.1.1/' $MODPATH/service.sh; sed -i '/resetprop -n net.pdpbr1.dns2/s/.*/resetprop -n net.pdpbr1.dns2 1.0.0.1/' $MODPATH/service.sh; sed -i '/resetprop -n net.lte.dns1/s/.*/resetprop -n net.lte.dns1 1.1.1.1/' $MODPATH/service.sh; sed -i '/resetprop -n net.lte.dns2/s/.*/resetprop -n net.lte.dns2 1.0.0.1/' $MODPATH/service.sh; sed -i '/iptables -t nat -A OUTPUT -p tcp --dport 53 -j DNAT --to-destination :53/s/.*/iptables -t nat -A OUTPUT -p tcp --dport 53 -j DNAT --to-destination 1.1.1.1:53/' $MODPATH/service.sh; sed -i '/iptables -t nat -A OUTPUT -p udp --dport 53 -j DNAT --to-destination :53/s/.*/iptables -t nat -A OUTPUT -p udp --dport 53 -j DNAT --to-destination 1.0.0.1:53/' $MODPATH/service.sh; sed -i '/iptables -t nat -I OUTPUT -p tcp --dport 53 -j DNAT --to-destination :53/s/.*/iptables -t nat -I OUTPUT -p tcp --dport 53 -j DNAT --to-destination 1.1.1.1:53/' $MODPATH/service.sh; sed -i '/iptables -t nat -I OUTPUT -p udp --dport 53 -j DNAT --to-destination :53/s/.*/iptables -t nat -I OUTPUT -p udp --dport 53 -j DNAT --to-destination 1.0.0.1:53/' $MODPATH/service.sh; sed -i '/net.dns1/s/.*/net.dns1=1.1.1.1/' $MODPATH/system.prop; sed -i '/net.dns2/s/.*/net.dns2=1.0.0.1/' $MODPATH/system.prop; sed -i '/net.eth0.dns1/s/.*/net.eth0.dns1=1.1.1.1/' $MODPATH/system.prop; sed -i '/net.eth0.dns2/s/.*/net.eth0.dns2=1.0.0.1/' $MODPATH/system.prop; sed -i '/net.ppp0.dns1/s/.*/net.ppp0.dns1=1.1.1.1/' $MODPATH/system.prop; sed -i '/net.ppp0.dns2/s/.*/net.ppp0.dns2=1.0.0.1/' $MODPATH/system.prop; sed -i '/net.rmnet0.dns1/s/.*/net.rmnet0.dns1=1.1.1.1/' $MODPATH/system.prop; sed -i '/net.rmnet0.dns2/s/.*/net.rmnet0.dns2=1.0.0.1/' $MODPATH/system.prop; sed -i '/net.rmnet1.dns1/s/.*/net.rmnet1.dns1=1.1.1.1/' $MODPATH/system.prop; sed -i '/net.rmnet1.dns2/s/.*/net.rmnet1.dns2=1.0.0.1/' $MODPATH/system.prop; sed -i '/net.pdpbr1.dns1/s/.*/net.pdpbr1.dns1=1.1.1.1/' $MODPATH/system.prop; sed -i '/net.pdpbr1.dns2/s/.*/net.pdpbr1.dns2=1.0.0.1/' $MODPATH/system.prop; sed -i '/net.lte.dns1/s/.*/net.lte.dns1=1.1.1.1/' $MODPATH/system.prop; sed -i '/net.lte.dns2/s/.*/net.lte.dns2=1.0.0.1/' $MODPATH/system.prop;;
    3 ) TEXT7="🟢Google DNS"; sed -i '/nameserver1/s/.*/nameserver 8.8.8.8/' $MODPATH/system/etc/resolv.conf; sed -i '/nameserver2/s/.*/nameserver 8.8.4.4/' $MODPATH/system/etc/resolv.conf; sed -i '/resetprop -n net.dns1/s/.*/resetprop -n net.dns1 8.8.8.8/' $MODPATH/service.sh; sed -i '/resetprop -n net.dns2/s/.*/resetprop -n net.dns2 8.8.4.4/' $MODPATH/service.sh; sed -i '/resetprop -n net.eth0.dns1/s/.*/resetprop -n net.eth0.dns1 8.8.8.8/' $MODPATH/service.sh; sed -i '/resetprop -n net.eth0.dns2/s/.*/resetprop -n net.eth0.dns2 8.8.4.4/' $MODPATH/service.sh; sed -i '/resetprop -n net.ppp0.dns1/s/.*/resetprop -n net.ppp0.dns1 8.8.8.8/' $MODPATH/service.sh; sed -i '/resetprop -n net.ppp0.dns2/s/.*/resetprop -n net.ppp0.dns2 8.8.4.4/' $MODPATH/service.sh; sed -i '/resetprop -n net.rmnet0.dns1/s/.*/resetprop -n net.rmnet0.dns1 8.8.8.8/' $MODPATH/service.sh; sed -i '/resetprop -n net.rmnet0.dns2/s/.*/resetprop -n net.rmnet0.dns2 8.8.4.4/' $MODPATH/service.sh; sed -i '/resetprop -n net.rmnet1.dns1/s/.*/resetprop -n net.rmnet1.dns1 8.8.8.8/' $MODPATH/service.sh; sed -i '/resetprop -n net.rmnet1.dns2/s/.*/resetprop -n net.rmnet1.dns2 8.8.4.4/' $MODPATH/service.sh; sed -i '/resetprop -n net.pdpbr1.dns1/s/.*/resetprop -n net.pdpbr1.dns1 8.8.8.8/' $MODPATH/service.sh; sed -i '/resetprop -n net.pdpbr1.dns2/s/.*/resetprop -n net.pdpbr1.dns2 8.8.4.4/' $MODPATH/service.sh; sed -i '/resetprop -n net.lte.dns1/s/.*/resetprop -n net.lte.dns1 8.8.8.8/' $MODPATH/service.sh; sed -i '/resetprop -n net.lte.dns2/s/.*/resetprop -n net.lte.dns2 8.8.4.4/' $MODPATH/service.sh; sed -i '/iptables -t nat -A OUTPUT -p tcp --dport 53 -j DNAT --to-destination :53/s/.*/iptables -t nat -A OUTPUT -p tcp --dport 53 -j DNAT --to-destination 8.8.8.8:53/' $MODPATH/service.sh; sed -i '/iptables -t nat -A OUTPUT -p udp --dport 53 -j DNAT --to-destination :53/s/.*/iptables -t nat -A OUTPUT -p udp --dport 53 -j DNAT --to-destination 8.8.4.4:53/' $MODPATH/service.sh; sed -i '/iptables -t nat -I OUTPUT -p tcp --dport 53 -j DNAT --to-destination :53/s/.*/iptables -t nat -I OUTPUT -p tcp --dport 53 -j DNAT --to-destination 8.8.8.8:53/' $MODPATH/service.sh; sed -i '/iptables -t nat -I OUTPUT -p udp --dport 53 -j DNAT --to-destination :53/s/.*/iptables -t nat -I OUTPUT -p udp --dport 53 -j DNAT --to-destination 8.8.4.4:53/' $MODPATH/service.sh; sed -i '/net.dns1/s/.*/net.dns1=8.8.8.8/' $MODPATH/system.prop; sed -i '/net.dns2/s/.*/net.dns2=8.8.4.4/' $MODPATH/system.prop; sed -i '/net.eth0.dns1/s/.*/net.eth0.dns1=8.8.8.8/' $MODPATH/system.prop; sed -i '/net.eth0.dns2/s/.*/net.eth0.dns2=8.8.4.4/' $MODPATH/system.prop; sed -i '/net.ppp0.dns1/s/.*/net.ppp0.dns1=8.8.8.8/' $MODPATH/system.prop; sed -i '/net.ppp0.dns2/s/.*/net.ppp0.dns2=8.8.4.4/' $MODPATH/system.prop; sed -i '/net.rmnet0.dns1/s/.*/net.rmnet0.dns1=8.8.8.8/' $MODPATH/system.prop; sed -i '/net.rmnet0.dns2/s/.*/net.rmnet0.dns2=8.8.4.4/' $MODPATH/system.prop; sed -i '/net.rmnet1.dns1/s/.*/net.rmnet1.dns1=8.8.8.8/' $MODPATH/system.prop; sed -i '/net.rmnet1.dns2/s/.*/net.rmnet1.dns2=8.8.4.4/' $MODPATH/system.prop; sed -i '/net.pdpbr1.dns1/s/.*/net.pdpbr1.dns1=8.8.8.8/' $MODPATH/system.prop; sed -i '/net.pdpbr1.dns2/s/.*/net.pdpbr1.dns2=8.8.4.4/' $MODPATH/system.prop; sed -i '/net.lte.dns1/s/.*/net.lte.dns1=8.8.8.8/' $MODPATH/system.prop; sed -i '/net.lte.dns2/s/.*/net.lte.dns2=8.8.4.4/' $MODPATH/system.prop;;
    4 ) TEXT7="🟢AdGuard DNS"; sed -i '/nameserver1/s/.*/nameserver 94.140.14.14/' $MODPATH/system/etc/resolv.conf; sed -i '/nameserver2/s/.*/nameserver 94.140.15.15/' $MODPATH/system/etc/resolv.conf; sed -i '/resetprop -n net.dns1/s/.*/resetprop -n net.dns1 94.140.14.14/' $MODPATH/service.sh; sed -i '/resetprop -n net.dns2/s/.*/resetprop -n net.dns2 94.140.15.15/' $MODPATH/service.sh; sed -i '/resetprop -n net.eth0.dns1/s/.*/resetprop -n net.eth0.dns1 94.140.14.14/' $MODPATH/service.sh; sed -i '/resetprop -n net.eth0.dns2/s/.*/resetprop -n net.eth0.dns2 94.140.15.15/' $MODPATH/service.sh; sed -i '/resetprop -n net.ppp0.dns1/s/.*/resetprop -n net.ppp0.dns1 94.140.14.14/' $MODPATH/service.sh; sed -i '/resetprop -n net.ppp0.dns2/s/.*/resetprop -n net.ppp0.dns2 94.140.15.15/' $MODPATH/service.sh; sed -i '/resetprop -n net.rmnet0.dns1/s/.*/resetprop -n net.rmnet0.dns1 94.140.14.14/' $MODPATH/service.sh; sed -i '/resetprop -n net.rmnet0.dns2/s/.*/resetprop -n net.rmnet0.dns2 94.140.15.15/' $MODPATH/service.sh; sed -i '/resetprop -n net.rmnet1.dns1/s/.*/resetprop -n net.rmnet1.dns1 94.140.14.14/' $MODPATH/service.sh; sed -i '/resetprop -n net.rmnet1.dns2/s/.*/resetprop -n net.rmnet1.dns2 94.140.15.15/' $MODPATH/service.sh; sed -i '/resetprop -n net.pdpbr1.dns1/s/.*/resetprop -n net.pdpbr1.dns1 94.140.14.14/' $MODPATH/service.sh; sed -i '/resetprop -n net.pdpbr1.dns2/s/.*/resetprop -n net.pdpbr1.dns2 94.140.15.15/' $MODPATH/service.sh; sed -i '/resetprop -n net.lte.dns1/s/.*/resetprop -n net.lte.dns1 94.140.14.14/' $MODPATH/service.sh; sed -i '/resetprop -n net.lte.dns2/s/.*/resetprop -n net.lte.dns2 94.140.15.15/' $MODPATH/service.sh; sed -i '/iptables -t nat -A OUTPUT -p tcp --dport 53 -j DNAT --to-destination :53/s/.*/iptables -t nat -A OUTPUT -p tcp --dport 53 -j DNAT --to-destination 94.140.14.14:53/' $MODPATH/service.sh; sed -i '/iptables -t nat -A OUTPUT -p udp --dport 53 -j DNAT --to-destination :53/s/.*/iptables -t nat -A OUTPUT -p udp --dport 53 -j DNAT --to-destination 94.140.15.15:53/' $MODPATH/service.sh; sed -i '/iptables -t nat -I OUTPUT -p tcp --dport 53 -j DNAT --to-destination :53/s/.*/iptables -t nat -I OUTPUT -p tcp --dport 53 -j DNAT --to-destination 94.140.14.14:53/' $MODPATH/service.sh; sed -i '/iptables -t nat -I OUTPUT -p udp --dport 53 -j DNAT --to-destination :53/s/.*/iptables -t nat -I OUTPUT -p udp --dport 53 -j DNAT --to-destination 94.140.15.15:53/' $MODPATH/service.sh; sed -i '/net.dns1/s/.*/net.dns1=94.140.14.14/' $MODPATH/system.prop; sed -i '/net.dns2/s/.*/net.dns2=94.140.15.15/' $MODPATH/system.prop; sed -i '/net.eth0.dns1/s/.*/net.eth0.dns1=94.140.14.14/' $MODPATH/system.prop; sed -i '/net.eth0.dns2/s/.*/net.eth0.dns2=94.140.15.15/' $MODPATH/system.prop; sed -i '/net.ppp0.dns1/s/.*/net.ppp0.dns1=94.140.14.14/' $MODPATH/system.prop; sed -i '/net.ppp0.dns2/s/.*/net.ppp0.dns2=94.140.15.15/' $MODPATH/system.prop; sed -i '/net.rmnet0.dns1/s/.*/net.rmnet0.dns1=94.140.14.14/' $MODPATH/system.prop; sed -i '/net.rmnet0.dns2/s/.*/net.rmnet0.dns2=94.140.15.15/' $MODPATH/system.prop; sed -i '/net.rmnet1.dns1/s/.*/net.rmnet1.dns1=94.140.14.14/' $MODPATH/system.prop; sed -i '/net.rmnet1.dns2/s/.*/net.rmnet1.dns2=94.140.15.15/' $MODPATH/system.prop; sed -i '/net.pdpbr1.dns1/s/.*/net.pdpbr1.dns1=94.140.14.14/' $MODPATH/system.prop; sed -i '/net.pdpbr1.dns2/s/.*/net.pdpbr1.dns2=94.140.15.15/' $MODPATH/system.prop; sed -i '/net.lte.dns1/s/.*/net.lte.dns1=94.140.14.14/' $MODPATH/system.prop; sed -i '/net.lte.dns2/s/.*/net.lte.dns2=94.140.15.15/' $MODPATH/system.prop;;
    5 ) TEXT7="🟢OpenDns"; sed -i '/nameserver1/s/.*/nameserver 208.67.222.222/' $MODPATH/system/etc/resolv.conf; sed -i '/nameserver2/s/.*/nameserver 208.67.220.220/' $MODPATH/system/etc/resolv.conf; sed -i '/resetprop -n net.dns1/s/.*/resetprop -n net.dns1 208.67.222.222/' $MODPATH/service.sh; sed -i '/resetprop -n net.dns2/s/.*/resetprop -n net.dns2 208.67.220.220/' $MODPATH/service.sh; sed -i '/resetprop -n net.eth0.dns1/s/.*/resetprop -n net.eth0.dns1 208.67.222.222/' $MODPATH/service.sh; sed -i '/resetprop -n net.eth0.dns2/s/.*/resetprop -n net.eth0.dns2 208.67.220.220/' $MODPATH/service.sh; sed -i '/resetprop -n net.ppp0.dns1/s/.*/resetprop -n net.ppp0.dns1 208.67.222.222/' $MODPATH/service.sh; sed -i '/resetprop -n net.ppp0.dns2/s/.*/resetprop -n net.ppp0.dns2 208.67.220.220/' $MODPATH/service.sh; sed -i '/resetprop -n net.rmnet0.dns1/s/.*/resetprop -n net.rmnet0.dns1 208.67.222.222/' $MODPATH/service.sh; sed -i '/resetprop -n net.rmnet0.dns2/s/.*/resetprop -n net.rmnet0.dns2 208.67.220.220/' $MODPATH/service.sh; sed -i '/resetprop -n net.rmnet1.dns1/s/.*/resetprop -n net.rmnet1.dns1 208.67.222.222/' $MODPATH/service.sh; sed -i '/resetprop -n net.rmnet1.dns2/s/.*/resetprop -n net.rmnet1.dns2 208.67.220.220/' $MODPATH/service.sh; sed -i '/resetprop -n net.pdpbr1.dns1/s/.*/resetprop -n net.pdpbr1.dns1 208.67.222.222/' $MODPATH/service.sh; sed -i '/resetprop -n net.pdpbr1.dns2/s/.*/resetprop -n net.pdpbr1.dns2 208.67.220.220/' $MODPATH/service.sh; sed -i '/resetprop -n net.lte.dns1/s/.*/resetprop -n net.lte.dns1 208.67.222.222/' $MODPATH/service.sh; sed -i '/resetprop -n net.lte.dns2/s/.*/resetprop -n net.lte.dns2 208.67.220.220/' $MODPATH/service.sh; sed -i '/iptables -t nat -A OUTPUT -p tcp --dport 53 -j DNAT --to-destination :53/s/.*/iptables -t nat -A OUTPUT -p tcp --dport 53 -j DNAT --to-destination 208.67.222.222:53/' $MODPATH/service.sh; sed -i '/iptables -t nat -A OUTPUT -p udp --dport 53 -j DNAT --to-destination :53/s/.*/iptables -t nat -A OUTPUT -p udp --dport 53 -j DNAT --to-destination 208.67.220.220:53/' $MODPATH/service.sh; sed -i '/iptables -t nat -I OUTPUT -p tcp --dport 53 -j DNAT --to-destination :53/s/.*/iptables -t nat -I OUTPUT -p tcp --dport 53 -j DNAT --to-destination 208.67.222.222:53/' $MODPATH/service.sh; sed -i '/iptables -t nat -I OUTPUT -p udp --dport 53 -j DNAT --to-destination :53/s/.*/iptables -t nat -I OUTPUT -p udp --dport 53 -j DNAT --to-destination 208.67.220.220:53/' $MODPATH/service.sh; sed -i '/net.dns1/s/.*/net.dns1=208.67.222.222/' $MODPATH/system.prop; sed -i '/net.dns2/s/.*/net.dns2=208.67.220.220/' $MODPATH/system.prop; sed -i '/net.eth0.dns1/s/.*/net.eth0.dns1=208.67.222.222/' $MODPATH/system.prop; sed -i '/net.eth0.dns2/s/.*/net.eth0.dns2=208.67.220.220/' $MODPATH/system.prop; sed -i '/net.ppp0.dns1/s/.*/net.ppp0.dns1=208.67.222.222/' $MODPATH/system.prop; sed -i '/net.ppp0.dns2/s/.*/net.ppp0.dns2=208.67.220.220/' $MODPATH/system.prop; sed -i '/net.rmnet0.dns1/s/.*/net.rmnet0.dns1=208.67.222.222/' $MODPATH/system.prop; sed -i '/net.rmnet0.dns2/s/.*/net.rmnet0.dns2=208.67.220.220/' $MODPATH/system.prop; sed -i '/net.rmnet1.dns1/s/.*/net.rmnet1.dns1=208.67.222.222/' $MODPATH/system.prop; sed -i '/net.rmnet1.dns2/s/.*/net.rmnet1.dns2=208.67.220.220/' $MODPATH/system.prop; sed -i '/net.pdpbr1.dns1/s/.*/net.pdpbr1.dns1=208.67.222.222/' $MODPATH/system.prop; sed -i '/net.pdpbr1.dns2/s/.*/net.pdpbr1.dns2=208.67.220.220/' $MODPATH/system.prop; sed -i '/net.lte.dns1/s/.*/net.lte.dns1=208.67.222.222/' $MODPATH/system.prop; sed -i '/net.lte.dns2/s/.*/net.lte.dns2=208.67.220.220/' $MODPATH/system.prop;;
    6 ) TEXT7="🟢Quad9 DNS"; sed -i '/nameserver1/s/.*/nameserver 9.9.9.9/' $MODPATH/system/etc/resolv.conf; sed -i '/nameserver2/s/.*/nameserver 149.112.112.112/' $MODPATH/system/etc/resolv.conf; sed -i '/resetprop -n net.dns1/s/.*/resetprop -n net.dns1 9.9.9.9/' $MODPATH/service.sh; sed -i '/resetprop -n net.dns2/s/.*/resetprop -n net.dns2 149.112.112.112/' $MODPATH/service.sh; sed -i '/resetprop -n net.eth0.dns1/s/.*/resetprop -n net.eth0.dns1 9.9.9.9/' $MODPATH/service.sh; sed -i '/resetprop -n net.eth0.dns2/s/.*/resetprop -n net.eth0.dns2 149.112.112.112/' $MODPATH/service.sh; sed -i '/resetprop -n net.ppp0.dns1/s/.*/resetprop -n net.ppp0.dns1 9.9.9.9/' $MODPATH/service.sh; sed -i '/resetprop -n net.ppp0.dns2/s/.*/resetprop -n net.ppp0.dns2 149.112.112.112/' $MODPATH/service.sh; sed -i '/resetprop -n net.rmnet0.dns1/s/.*/resetprop -n net.rmnet0.dns1 9.9.9.9/' $MODPATH/service.sh; sed -i '/resetprop -n net.rmnet0.dns2/s/.*/resetprop -n net.rmnet0.dns2 149.112.112.112/' $MODPATH/service.sh; sed -i '/resetprop -n net.rmnet1.dns1/s/.*/resetprop -n net.rmnet1.dns1 9.9.9.9/' $MODPATH/service.sh; sed -i '/resetprop -n net.rmnet1.dns2/s/.*/resetprop -n net.rmnet1.dns2 149.112.112.112/' $MODPATH/service.sh; sed -i '/resetprop -n net.pdpbr1.dns1/s/.*/resetprop -n net.pdpbr1.dns1 9.9.9.9/' $MODPATH/service.sh; sed -i '/resetprop -n net.pdpbr1.dns2/s/.*/resetprop -n net.pdpbr1.dns2 149.112.112.112/' $MODPATH/service.sh; sed -i '/resetprop -n net.lte.dns1/s/.*/resetprop -n net.lte.dns1 9.9.9.9/' $MODPATH/service.sh; sed -i '/resetprop -n net.lte.dns2/s/.*/resetprop -n net.lte.dns2 149.112.112.112/' $MODPATH/service.sh; sed -i '/iptables -t nat -A OUTPUT -p tcp --dport 53 -j DNAT --to-destination :53/s/.*/iptables -t nat -A OUTPUT -p tcp --dport 53 -j DNAT --to-destination 9.9.9.9:53/' $MODPATH/service.sh; sed -i '/iptables -t nat -A OUTPUT -p udp --dport 53 -j DNAT --to-destination :53/s/.*/iptables -t nat -A OUTPUT -p udp --dport 53 -j DNAT --to-destination 149.112.112.112:53/' $MODPATH/service.sh; sed -i '/iptables -t nat -I OUTPUT -p tcp --dport 53 -j DNAT --to-destination :53/s/.*/iptables -t nat -I OUTPUT -p tcp --dport 53 -j DNAT --to-destination 9.9.9.9:53/' $MODPATH/service.sh; sed -i '/iptables -t nat -I OUTPUT -p udp --dport 53 -j DNAT --to-destination :53/s/.*/iptables -t nat -I OUTPUT -p udp --dport 53 -j DNAT --to-destination 149.112.112.112:53/' $MODPATH/service.sh; sed -i '/net.dns1/s/.*/net.dns1=9.9.9.9/' $MODPATH/system.prop; sed -i '/net.dns2/s/.*/net.dns2=149.112.112.112/' $MODPATH/system.prop; sed -i '/net.eth0.dns1/s/.*/net.eth0.dns1=9.9.9.9/' $MODPATH/system.prop; sed -i '/net.eth0.dns2/s/.*/net.eth0.dns2=149.112.112.112/' $MODPATH/system.prop; sed -i '/net.ppp0.dns1/s/.*/net.ppp0.dns1=9.9.9.9/' $MODPATH/system.prop; sed -i '/net.ppp0.dns2/s/.*/net.ppp0.dns2=149.112.112.112/' $MODPATH/system.prop; sed -i '/net.rmnet0.dns1/s/.*/net.rmnet0.dns1=9.9.9.9/' $MODPATH/system.prop; sed -i '/net.rmnet0.dns2/s/.*/net.rmnet0.dns2=149.112.112.112/' $MODPATH/system.prop; sed -i '/net.rmnet1.dns1/s/.*/net.rmnet1.dns1=9.9.9.9/' $MODPATH/system.prop; sed -i '/net.rmnet1.dns2/s/.*/net.rmnet1.dns2=149.112.112.112/' $MODPATH/system.prop; sed -i '/net.pdpbr1.dns1/s/.*/net.pdpbr1.dns1=9.9.9.9/' $MODPATH/system.prop; sed -i '/net.pdpbr1.dns2/s/.*/net.pdpbr1.dns2=149.112.112.112/' $MODPATH/system.prop; sed -i '/net.lte.dns1/s/.*/net.lte.dns1=9.9.9.9/' $MODPATH/system.prop; sed -i '/net.lte.dns2/s/.*/net.lte.dns2=149.112.112.112/' $MODPATH/system.prop;;
    7 ) TEXT7="🟢Uncensored DNS"; sed -i '/nameserver1/s/.*/nameserver 91.239.100.100/' $MODPATH/system/etc/resolv.conf; sed -i '/nameserver2/s/.*/nameserver 89.233.43.71/' $MODPATH/system/etc/resolv.conf; sed -i '/resetprop -n net.dns1/s/.*/resetprop -n net.dns1 91.239.100.100/' $MODPATH/service.sh; sed -i '/resetprop -n net.dns2/s/.*/resetprop -n net.dns2 89.233.43.71/' $MODPATH/service.sh; sed -i '/resetprop -n net.eth0.dns1/s/.*/resetprop -n net.eth0.dns1 91.239.100.100/' $MODPATH/service.sh; sed -i '/resetprop -n net.eth0.dns2/s/.*/resetprop -n net.eth0.dns2 89.233.43.71/' $MODPATH/service.sh; sed -i '/resetprop -n net.ppp0.dns1/s/.*/resetprop -n net.ppp0.dns1 91.239.100.100/' $MODPATH/service.sh; sed -i '/resetprop -n net.ppp0.dns2/s/.*/resetprop -n net.ppp0.dns2 89.233.43.71/' $MODPATH/service.sh; sed -i '/resetprop -n net.rmnet0.dns1/s/.*/resetprop -n net.rmnet0.dns1 91.239.100.100/' $MODPATH/service.sh; sed -i '/resetprop -n net.rmnet0.dns2/s/.*/resetprop -n net.rmnet0.dns2 89.233.43.71/' $MODPATH/service.sh; sed -i '/resetprop -n net.rmnet1.dns1/s/.*/resetprop -n net.rmnet1.dns1 91.239.100.100/' $MODPATH/service.sh; sed -i '/resetprop -n net.rmnet1.dns2/s/.*/resetprop -n net.rmnet1.dns2 89.233.43.71/' $MODPATH/service.sh; sed -i '/resetprop -n net.pdpbr1.dns1/s/.*/resetprop -n net.pdpbr1.dns1 91.239.100.100/' $MODPATH/service.sh; sed -i '/resetprop -n net.pdpbr1.dns2/s/.*/resetprop -n net.pdpbr1.dns2 89.233.43.71/' $MODPATH/service.sh; sed -i '/resetprop -n net.lte.dns1/s/.*/resetprop -n net.lte.dns1 91.239.100.100/' $MODPATH/service.sh; sed -i '/resetprop -n net.lte.dns2/s/.*/resetprop -n net.lte.dns2 89.233.43.71/' $MODPATH/service.sh; sed -i '/iptables -t nat -A OUTPUT -p tcp --dport 53 -j DNAT --to-destination :53/s/.*/iptables -t nat -A OUTPUT -p tcp --dport 53 -j DNAT --to-destination 91.239.100.100:53/' $MODPATH/service.sh; sed -i '/iptables -t nat -A OUTPUT -p udp --dport 53 -j DNAT --to-destination :53/s/.*/iptables -t nat -A OUTPUT -p udp --dport 53 -j DNAT --to-destination 89.233.43.71:53/' $MODPATH/service.sh; sed -i '/iptables -t nat -I OUTPUT -p tcp --dport 53 -j DNAT --to-destination :53/s/.*/iptables -t nat -I OUTPUT -p tcp --dport 53 -j DNAT --to-destination 91.239.100.100:53/' $MODPATH/service.sh; sed -i '/iptables -t nat -I OUTPUT -p udp --dport 53 -j DNAT --to-destination :53/s/.*/iptables -t nat -I OUTPUT -p udp --dport 53 -j DNAT --to-destination 89.233.43.71:53/' $MODPATH/service.sh; sed -i '/net.dns1/s/.*/net.dns1=91.239.100.100/' $MODPATH/system.prop; sed -i '/net.dns2/s/.*/net.dns2=89.233.43.71/' $MODPATH/system.prop; sed -i '/net.eth0.dns1/s/.*/net.eth0.dns1=91.239.100.100/' $MODPATH/system.prop; sed -i '/net.eth0.dns2/s/.*/net.eth0.dns2=89.233.43.71/' $MODPATH/system.prop; sed -i '/net.ppp0.dns1/s/.*/net.ppp0.dns1=91.239.100.100/' $MODPATH/system.prop; sed -i '/net.ppp0.dns2/s/.*/net.ppp0.dns2=89.233.43.71/' $MODPATH/system.prop; sed -i '/net.rmnet0.dns1/s/.*/net.rmnet0.dns1=91.239.100.100/' $MODPATH/system.prop; sed -i '/net.rmnet0.dns2/s/.*/net.rmnet0.dns2=89.233.43.71/' $MODPATH/system.prop; sed -i '/net.rmnet1.dns1/s/.*/net.rmnet1.dns1=91.239.100.100/' $MODPATH/system.prop; sed -i '/net.rmnet1.dns2/s/.*/net.rmnet1.dns2=89.233.43.71/' $MODPATH/system.prop; sed -i '/net.pdpbr1.dns1/s/.*/net.pdpbr1.dns1=91.239.100.100/' $MODPATH/system.prop; sed -i '/net.pdpbr1.dns2/s/.*/net.pdpbr1.dns2=89.233.43.71/' $MODPATH/system.prop; sed -i '/net.lte.dns1/s/.*/net.lte.dns1=91.239.100.100/' $MODPATH/system.prop; sed -i '/net.lte.dns2/s/.*/net.lte.dns2=89.233.43.71/' $MODPATH/system.prop;;
esac
ui_print "    $TEXT7"
ui_print ""

rm -rf $MODPATH/addon 2>/dev/null

# Universal GMS Doze by gloeyisk
# open source loving GL-DP and all contributors;
# Patches Google Play services app and its background processes to be able using battery optimization
#
# Patch the xml and place the modified one to the original directory
ui_print "- Patching XML files"
GMS0="\"com.google.android.gms"\"
STR1="allow-unthrottled-location package=$GMS0"
STR2="allow-ignore-location-settings package=$GMS0"
STR3="allow-in-power-save package=$GMS0"
STR4="allow-in-data-usage-save package=$GMS0"
NULL="/dev/null"

ui_print "- Finding system XML"
SYS_XML="$(
    SXML="$(find /system_ext/* /system/* /product/* \
                 /vendor/* -type f -iname '*.xml' -print)"
    for S in $SXML; do
        if grep -qE "$STR1|$STR2|$STR3|$STR4" $ROOT$S 2> $NULL; then
            echo "$S"
        fi
    done
)"

PATCH_SX() {
    for SX in $SYS_XML; do
        mkdir -p "$(dirname $MODPATH$SX)"
        cp -af $ROOT$SX $MODPATH$SX
        ui_print "  Patching: $SX"
        sed -i "/$STR1/d;/$STR2/d;/$STR3/d;/$STR4/d" $MODPATH/$SX
    done

    # Merge patched files under /system dir
    for P in product vendor; do
        if [ -d $MODPATH/$P ]; then
            ui_print "- Moving files to module dir"
            mkdir -p $MODPATH/system/$P
            mv -f $MODPATH/$P $MODPATH/system/
        fi
    done
}

# Search and patch any conflicting modules (if present)
# Search conflicting XML files
MOD_XML="$(
    MXML="$(find /data/adb/* -type f -iname "*.xml" -print)"
    for M in $MXML; do
        if grep -qE "$STR1|$STR2|$STR3|$STR4" $M; then
            echo "$M"
        fi
    done
)"

PATCH_MX() {
    ui_print "- Finding conflicting XML"
    for MX in $MOD_XML; do
        MOD="$(echo "$MX" | awk -F'/' '{print $5}')"
        ui_print "  $MOD: $MX"
        sed -i "/$STR1/d;/$STR2/d;/$STR3/d;/$STR4/d" $MX
    done
}

# Find and patch conflicting XML
PATCH_SX && PATCH_MX

# Install toast app
ui_print "- Install toast app"
pm install $MODPATH/Toast.apk

# Clean up
ui_print "- Cleaning obsolete files"
find $MODPATH/* -maxdepth 0 \
              ! -name 'module.prop' \
              ! -name 'post-fs-data.sh' \
              ! -name 'service.sh' \
              ! -name 'system.prop' \
              ! -name 'uninstall.sh' \
              ! -name 'system' \
              ! -name 'script' \
                -exec rm -rf {} \;

# Set permissions
ui_print "- Setting permissions"
set_perm_recursive $MODPATH 0 0 0755 0644
set_perm_recursive $MODPATH/system/bin 0 0 0755 0755
set_perm_recursive $MODPATH/system/etc/rewrite 0 0 0755 0755
set_perm_recursive $MODPATH/script/ 0 0 0755 0700

# Wipe dalvik cache
ui_print "- Wipe dalvik-cache"
rm -rf /data/dalvik-cache/*
