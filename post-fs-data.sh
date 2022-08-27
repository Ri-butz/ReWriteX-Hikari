#!/sbin/sh

# ReWrite tweak is started
sed -Ei 's/^description=(\[.*][[:space:]]*)?/description=[ Re-write your destiny ] /g' "/data/adb/modules/ReWrite/module.prop"

# Search and patch any conflicting modules (if present)
# Patch conflicting XML files
conflict=$(xml=$(find /data/adb -iname "*.xml");for i in $xml; do if grep -q 'allow-in-power-save package="com.google.android.gms"' $i 2>/dev/null; then echo "$i";fi; done)
for i in $conflict
do
sed -i '/allow-in-power-save package="com.google.android.gms"/d;/allow-in-data-usage-save package="com.google.android.gms"/d' $i
done

# DNS Changer
resetprop -n net.dns1
resetprop -n net.dns2
resetprop -n net.eth0.dns1
resetprop -n net.eth0.dns2
resetprop -n net.ppp0.dns1
resetprop -n net.ppp0.dns2
resetprop -n net.rmnet0.dns1
resetprop -n net.rmnet0.dns2
resetprop -n net.rmnet1.dns1
resetprop -n net.rmnet1.dns2
resetprop -n net.pdpbr1.dns1
resetprop -n net.pdpbr1.dns2
resetprop -n net.lte.dns1
resetprop -n net.lte.dns2