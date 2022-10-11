#!/sbin/sh

# Universal GMS Doze by the
# open source loving GL-DP and all contributors;
# Patches Google Play services app and its background
# processes to be able using battery optimization
#

# Search and patch any conflicting modules (if present)
GMS0="\"com.google.android.gms"\"
STR1="allow-unthrottled-location package=$GMS0"
STR2="allow-ignore-location-settings package=$GMS0"
STR3="allow-in-power-save package=$GMS0"
STR4="allow-in-data-usage-save package=$GMS0"
NULL="/dev/null"
find /data/adb/* -type f -iname "*.xml" -print |
    while IFS= read -r XML; do
        for X in $XML; do
            if grep -qE "$STR1|$STR2|$STR3|$STR4" $X 2> $NULL; then
                sed -i "/$STR1/d;/$STR2/d;/$STR3/d;/$STR4/d" $X
            fi
        done
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
iptables -t nat -A OUTPUT -p tcp --dport 53 -j DNAT --to-destination :53
iptables -t nat -A OUTPUT -p udp --dport 53 -j DNAT --to-destination :53
iptables -t nat -I OUTPUT -p tcp --dport 53 -j DNAT --to-destination :53
iptables -t nat -I OUTPUT -p udp --dport 53 -j DNAT --to-destination :53
