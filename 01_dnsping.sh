#!/bin/bash

# Usage: 01_dnsping.sh [random|example.com]

cd ~/dev/dnspingtest_rrd/ || exit 1

PING=/usr/bin/dnsping
COUNT=4     # higher count = smoother / finer "loss" scale; lower count = less caching effects
DEADLINE=1  # even 1s (1000ms) is much too long to wait for!
tcp=''

# ---
# inspired by: https://github.com/gitthangbaby/dnsperftest/blob/patch-1/dnstest_random#L28-L35
# ---
if [ "$1" = "random" ]; then
  random=true
  COUNT=10
  # Random domains to choose from
  mapfile -t RANDOM_DOMAINS < <(
  cat opendns-random-domains.txt
  cat opendns-top-domains.txt
# Info:
# "Both lists are in public domain, and are updated weekly"
# But: last update 8 years ago :-(
# So there's no need to download these lists again and again.
# I opened an issue at Cisco Umbrella (fka OpenDNS) to reactivate updating these lists.
#  curl -sS https://raw.githubusercontent.com/opendns/public-domain-lists/master/opendns-top-domains.txt
#  curl -sS https://raw.githubusercontent.com/opendns/public-domain-lists/master/opendns-random-domains.txt
  )
else
  domain="$1"
fi
# ---

dnsping_host() {
    if [ "$random" = "true" ]; then
      domain=${RANDOM_DOMAINS[$RANDOM % ${#RANDOM_DOMAINS[*]}]};
    else
      domain=${domain:=heise.de}
    fi
    echo "querying $domain for $1"
    output="$($PING "$tcp" -q -c $COUNT -w $DEADLINE -s "$1" "$domain" 2>&1)"
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
    #echo -e "loss in percent : avg query time in ms => $temp\n"
    RETURN_VALUE=$temp
}

# -- MAIN --

if [ ! -f dnsresolvers.list ]; then
  pwd
  echo "dnsresolvers.list: file not found."
  exit 2
fi
resolverlist="$(grep -v ^\# dnsresolvers.list)"
[ -z "$resolverlist" ] && exit 1
for resolver in $resolverlist; do
  if echo "$resolver"|grep -q 'T'; then
    resolver="$(echo "$resolver"|cut -d "-" -f1)"
    tcp="-T"
    echo $resolver $tcp
  fi
  # create rrd-file from scratch if not existing:
  if ! [ -f data/dnsping_"${resolver}".rrd ]; then
    /usr/bin/rrdtool create data/dnsping_"${resolver}".rrd \
      --step 60 \
      DS:pl:GAUGE:600:0:100 \
      DS:rtt:GAUGE:600:0:10000000 \
      RRA:AVERAGE:0.5:1:800 \
      RRA:AVERAGE:0.5:6:800 \
      RRA:AVERAGE:0.5:24:800 \
      RRA:AVERAGE:0.5:288:800 \
      RRA:MAX:0.5:1:800 \
      RRA:MAX:0.5:6:800 \
      RRA:MAX:0.5:24:800 \
      RRA:MAX:0.5:288:800
  fi
  # do the dnsping:
  dnsping_host "$resolver"
  # and update rrd:
  /usr/bin/rrdtool update \
      data/dnsping_"$resolver".rrd \
      --template \
      pl:rtt \
      N:"$RETURN_VALUE"
  # https://forum.syncthing.net/t/why-are-rrd-files-transferred-by-time-and-not-immediately/16391
  touch data/dnsping_"$resolver".rrd
done

