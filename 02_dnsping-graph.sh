#!/bin/bash

cd ~/dev/dnspingtest_rrd/ || exit 1

# -- MAIN --

if [ ! -f dnsresolvers.list ]; then
  echo "dnsresolvers.list: file not found."
  exit 2
fi
resolverlist="$(grep -v ^\# dnsresolvers.list)"
[ -z "$resolverlist" ] && exit 1
for resolver in $resolverlist; do

  if echo "$resolver"|grep -q 'T'; then
    resolver="$(echo "$resolver"|cut -d "-" -f1)"
  fi

  # create html-file from "template" if not existing:
  if [ ! -e "index_$resolver.html" ]; then
    cp -af index_192.168.0.13_pihole_wlan.html index_"$resolver".html
    sed -i "s/192.168.0.13/$resolver/g" index_"$resolver".html
  fi

  rrdtool graph images/dnsping_"${resolver}"_hour.png -h 500 -w 1200 -a PNG \
  --imginfo '<IMG SRC=/stats/%s WIDTH=%lu HEIGHT=%lu >' \
  --start -3600 --end -60 --x-grid MINUTE:10:HOUR:1:MINUTE:30:0:%R \
  -v "Response Time (ms)" \
  --rigid \
  --lower-limit 0 \
  DEF:roundtrip=data/dnsping_"${resolver}".rrd:rtt:AVERAGE \
  DEF:packetloss=data/dnsping_"${resolver}".rrd:pl:AVERAGE \
  CDEF:PLNone=packetloss,0,2,LIMIT,UN,UNKN,INF,IF \
  CDEF:PL2=packetloss,2,8,LIMIT,UN,UNKN,INF,IF \
  CDEF:PL15=packetloss,8,15,LIMIT,UN,UNKN,INF,IF \
  CDEF:PL25=packetloss,15,25,LIMIT,UN,UNKN,INF,IF \
  CDEF:PL50=packetloss,25,50,LIMIT,UN,UNKN,INF,IF \
  CDEF:PL75=packetloss,50,75,LIMIT,UN,UNKN,INF,IF \
  CDEF:PL100=packetloss,75,100,LIMIT,UN,UNKN,INF,IF \
  AREA:roundtrip#4444ff:"Response Time (millis)" \
  GPRINT:roundtrip:LAST:"Cur\: %5.2lf" \
  GPRINT:roundtrip:AVERAGE:"Avg\: %5.2lf" \
  GPRINT:roundtrip:MAX:"Max\: %5.2lf" \
  GPRINT:roundtrip:MIN:"Min\: %5.2lf\n" \
  AREA:PLNone#6c9bcd:"0-2%":STACK \
  AREA:PL2#00ffae:"2-8%":STACK \
  AREA:PL15#ccff00:"8-15%":STACK \
  AREA:PL25#ffff00:"15-25%":STACK \
  AREA:PL50#ffcc66:"25-50%":STACK \
  AREA:PL75#ff9900:"50-75%":STACK \
  AREA:PL100#ff0000:"75-100%":STACK \
  COMMENT:"(Packet Loss Percentage)"

  rrdtool graph images/dnsping_"${resolver}"_day.png -h 500 -w 1200 -a PNG \
  --imginfo '<IMG SRC=/stats/%s WIDTH=%lu HEIGHT=%lu >' \
  --lazy --start -86400 --end -60 --x-grid MINUTE:30:HOUR:1:HOUR:2:0:%H \
  -v "Response Time (ms)" \
  --rigid \
  --lower-limit 0 \
  DEF:roundtrip=data/dnsping_"${resolver}".rrd:rtt:AVERAGE \
  DEF:packetloss=data/dnsping_"${resolver}".rrd:pl:AVERAGE \
  CDEF:PLNone=packetloss,0,2,LIMIT,UN,UNKN,INF,IF \
  CDEF:PL2=packetloss,2,8,LIMIT,UN,UNKN,INF,IF \
  CDEF:PL15=packetloss,8,15,LIMIT,UN,UNKN,INF,IF \
  CDEF:PL25=packetloss,15,25,LIMIT,UN,UNKN,INF,IF \
  CDEF:PL50=packetloss,25,50,LIMIT,UN,UNKN,INF,IF \
  CDEF:PL75=packetloss,50,75,LIMIT,UN,UNKN,INF,IF \
  CDEF:PL100=packetloss,75,100,LIMIT,UN,UNKN,INF,IF \
  AREA:roundtrip#4444ff:"Response Time (millis)" \
  GPRINT:roundtrip:LAST:"Cur\: %5.2lf" \
  GPRINT:roundtrip:AVERAGE:"Avg\: %5.2lf" \
  GPRINT:roundtrip:MAX:"Max\: %5.2lf" \
  GPRINT:roundtrip:MIN:"Min\: %5.2lf\n" \
  AREA:PLNone#6c9bcd:"0-2%":STACK \
  AREA:PL2#00ffae:"2-8%":STACK \
  AREA:PL15#ccff00:"8-15%":STACK \
  AREA:PL25#ffff00:"15-25%":STACK \
  AREA:PL50#ffcc66:"25-50%":STACK \
  AREA:PL75#ff9900:"50-75%":STACK \
  AREA:PL100#ff0000:"75-100%":STACK \
  COMMENT:"(Packet Loss Percentage)"

  rrdtool graph images/dnsping_"${resolver}"_week.png -h 500 -w 1200 -a PNG \
  --imginfo '<IMG SRC=/stats/%s WIDTH=%lu HEIGHT=%lu >' \
  --lazy --start -604800 --end -1800 \
  -v "Response Time (ms)" \
  --rigid \
  --lower-limit 0 \
  DEF:roundtrip=data/dnsping_"${resolver}".rrd:rtt:AVERAGE \
  DEF:packetloss=data/dnsping_"${resolver}".rrd:pl:AVERAGE \
  CDEF:PLNone=packetloss,0,2,LIMIT,UN,UNKN,INF,IF \
  CDEF:PL2=packetloss,2,8,LIMIT,UN,UNKN,INF,IF \
  CDEF:PL15=packetloss,8,15,LIMIT,UN,UNKN,INF,IF \
  CDEF:PL25=packetloss,15,25,LIMIT,UN,UNKN,INF,IF \
  CDEF:PL50=packetloss,25,50,LIMIT,UN,UNKN,INF,IF \
  CDEF:PL75=packetloss,50,75,LIMIT,UN,UNKN,INF,IF \
  CDEF:PL100=packetloss,75,100,LIMIT,UN,UNKN,INF,IF \
  AREA:roundtrip#4444ff:"Response Time (millis)" \
  GPRINT:roundtrip:LAST:"Cur\: %5.2lf" \
  GPRINT:roundtrip:AVERAGE:"Avg\: %5.2lf" \
  GPRINT:roundtrip:MAX:"Max\: %5.2lf" \
  GPRINT:roundtrip:MIN:"Min\: %5.2lf\n" \
  AREA:PLNone#6c9bcd:"0-2%":STACK \
  AREA:PL2#00ffae:"2-8%":STACK \
  AREA:PL15#ccff00:"8-15%":STACK \
  AREA:PL25#ffff00:"15-25%":STACK \
  AREA:PL50#ffcc66:"25-50%":STACK \
  AREA:PL75#ff9900:"50-75%":STACK \
  AREA:PL100#ff0000:"75-100%":STACK \
  COMMENT:"(Packet Loss Percentage)"

  rrdtool graph images/dnsping_"${resolver}"_month.png -h 500 -w 1200 -a PNG \
  --imginfo '<IMG SRC=/stats/%s WIDTH=%lu HEIGHT=%lu >' \
  --lazy --start -2592000 --end -7200 \
  -v "Response Time (ms)" \
  --rigid \
  --lower-limit 0 \
  DEF:roundtrip=data/dnsping_"${resolver}".rrd:rtt:AVERAGE \
  DEF:packetloss=data/dnsping_"${resolver}".rrd:pl:AVERAGE \
  CDEF:PLNone=packetloss,0,2,LIMIT,UN,UNKN,INF,IF \
  CDEF:PL2=packetloss,2,8,LIMIT,UN,UNKN,INF,IF \
  CDEF:PL15=packetloss,8,15,LIMIT,UN,UNKN,INF,IF \
  CDEF:PL25=packetloss,15,25,LIMIT,UN,UNKN,INF,IF \
  CDEF:PL50=packetloss,25,50,LIMIT,UN,UNKN,INF,IF \
  CDEF:PL75=packetloss,50,75,LIMIT,UN,UNKN,INF,IF \
  CDEF:PL100=packetloss,75,100,LIMIT,UN,UNKN,INF,IF \
  AREA:roundtrip#4444ff:"Response Time (millis)" \
  GPRINT:roundtrip:LAST:"Cur\: %5.2lf" \
  GPRINT:roundtrip:AVERAGE:"Avg\: %5.2lf" \
  GPRINT:roundtrip:MAX:"Max\: %5.2lf" \
  GPRINT:roundtrip:MIN:"Min\: %5.2lf\n" \
  AREA:PLNone#6c9bcd:"0-2%":STACK \
  AREA:PL2#00ffae:"2-8%":STACK \
  AREA:PL15#ccff00:"8-15%":STACK \
  AREA:PL25#ffff00:"15-25%":STACK \
  AREA:PL50#ffcc66:"25-50%":STACK \
  AREA:PL75#ff9900:"50-75%":STACK \
  AREA:PL100#ff0000:"75-100%":STACK \
  COMMENT:"(Packet Loss Percentage)"

  rrdtool graph images/dnsping_"${resolver}"_year.png \
  --imginfo '<IMG SRC=/stats/%s WIDTH=%lu HEIGHT=%lu >' \
  --lazy --start -31536000 --end -86400 -h 500 -w 1200 -a PNG \
  -v "Response Time (ms)" \
  --rigid \
  --lower-limit 0 \
  DEF:roundtrip=data/dnsping_"${resolver}".rrd:rtt:AVERAGE \
  DEF:packetloss=data/dnsping_"${resolver}".rrd:pl:AVERAGE \
  CDEF:PLNone=packetloss,0,2,LIMIT,UN,UNKN,INF,IF \
  CDEF:PL2=packetloss,2,8,LIMIT,UN,UNKN,INF,IF \
  CDEF:PL15=packetloss,8,15,LIMIT,UN,UNKN,INF,IF \
  CDEF:PL25=packetloss,15,25,LIMIT,UN,UNKN,INF,IF \
  CDEF:PL50=packetloss,25,50,LIMIT,UN,UNKN,INF,IF \
  CDEF:PL75=packetloss,50,75,LIMIT,UN,UNKN,INF,IF \
  CDEF:PL100=packetloss,75,100,LIMIT,UN,UNKN,INF,IF \
  AREA:roundtrip#4444ff:"Response Time (millis)" \
  GPRINT:roundtrip:LAST:"Cur\: %5.2lf" \
  GPRINT:roundtrip:AVERAGE:"Avg\: %5.2lf" \
  GPRINT:roundtrip:MAX:"Max\: %5.2lf" \
  GPRINT:roundtrip:MIN:"Min\: %5.2lf\n" \
  AREA:PLNone#6c9bcd:"0-2%":STACK \
  AREA:PL2#00ffae:"2-8%":STACK \
  AREA:PL15#ccff00:"8-15%":STACK \
  AREA:PL25#ffff00:"15-25%":STACK \
  AREA:PL50#ffcc66:"25-50%":STACK \
  AREA:PL75#ff9900:"50-75%":STACK \
  AREA:PL100#ff0000:"75-100%":STACK \
  COMMENT:"(Packet Loss Percentage)"

done

