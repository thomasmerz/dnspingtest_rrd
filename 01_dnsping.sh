#!/bin/bash

cd ~/dev/dnspingtest_rrd/ || exit 1

PING=/usr/bin/dnsping
COUNT=4
DEADLINE=10

dnsping_host() {
    output="$($PING -q -c $COUNT -w $DEADLINE -s "$1" heise.de 2>&1)"
    # notice $output is quoted to preserve newlines
    temp=$(echo "$output"| awk '
        BEGIN           {pl=100; rtt=0.1}
        /requests transmitted/   {
            match($0, /([0-9]+)% lost/, matchstr)
            pl=matchstr[1]
        }
        /^min/          {
            # looking for something like "min=14.553 ms, avg=16.015 ms, max=17.675 ms, stddev=1.571 ms"
            match($3, /avg=(.*)/, a)
            rtt=a[1]
        }
        /Name or service not known/  {
            # no output at all means network is probably down
            pl=100
            rtt=0.1
        }
        END         {print pl ":" rtt}
        '|cut -d"=" -f2)
    #local temp
    RETURN_VALUE=$temp
}

# dnsping some hosts for some dns resolvers:
# 80.69.96.12 = vodafone-extern
# 192.168.42.241 = localhost ("LAN")
# 192.168.0.13 = via tp-ax6000-router ("WLAN")
# dns1.nextdns.io 45.90.28.39
# dns2.nextdns.io 45.90.30.39
# Google (ECS, DNSSEC);8.8.8.8;8.8.4.4;2001:4860:4860:0:0:0:0:8888;2001:4860:4860:0:0:0:0:8844
# OpenDNS (ECS, DNSSEC);208.67.222.222;208.67.220.220;2620:119:35::35;2620:119:53::53
# DNS.WATCH (DNSSEC);84.200.69.80;84.200.70.40;2001:1608:10:25:0:0:1c04:b12f;2001:1608:10:25:0:0:9249:d69b
# Quad9 (filtered, ECS, DNSSEC);9.9.9.11;149.112.112.11;2620:fe::11;2620:fe::fe:11
for resolvers in 80.69.96.12 45.90.28.39 45.90.30.39 1.1.1.1 1.0.0.1 8.8.8.8 8.8.4.4 208.67.222.222 208.67.220.220 84.200.69.80 84.200.70.40 9.9.9.11 149.112.112.11 192.168.0.1 192.168.42.241 192.168.0.13; do
  dnsping_host $resolvers
  /usr/bin/rrdtool update \
      dnsping_$resolvers.rrd \
      --template \
      pl:rtt \
      N:"$RETURN_VALUE"
  # https://forum.syncthing.net/t/why-are-rrd-files-transferred-by-time-and-not-immediately/16391
  touch dnsping_$resolvers.rrd
done

