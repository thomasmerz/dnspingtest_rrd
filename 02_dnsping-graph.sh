#!/bin/sh

cd ~/dev/dnspingtest_rrd/ || exit 1

h='80.69.96.12 45.90.28.39 45.90.30.39 1.1.1.1 1.0.0.1 8.8.8.8 8.8.4.4 208.67.222.222 208.67.220.220 84.200.69.80 84.200.70.40 9.9.9.11 149.112.112.11 192.168.0.1 192.168.42.241 192.168.0.13'
for what in $h; do

  rrdtool graph images/dnsping_"${what}"_hour.png -h 500 -w 1200 -a PNG \
  --imginfo '<IMG SRC=/stats/%s WIDTH=%lu HEIGHT=%lu >' \
  --start -3600 --end -60 --x-grid MINUTE:10:HOUR:1:MINUTE:30:0:%R \
  -v "Response Time (ms)" \
  --rigid \
  --lower-limit 0 \
  DEF:roundtrip=data/dnsping_"${what}".rrd:rtt:AVERAGE \
  DEF:packetloss=data/dnsping_"${what}".rrd:pl:AVERAGE \
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

  rrdtool graph images/dnsping_"${what}"_day.png -h 500 -w 1200 -a PNG \
  --imginfo '<IMG SRC=/stats/%s WIDTH=%lu HEIGHT=%lu >' \
  --lazy --start -86400 --end -60 --x-grid MINUTE:30:HOUR:1:HOUR:2:0:%H \
  -v "Response Time (ms)" \
  --rigid \
  --lower-limit 0 \
  DEF:roundtrip=data/dnsping_"${what}".rrd:rtt:AVERAGE \
  DEF:packetloss=data/dnsping_"${what}".rrd:pl:AVERAGE \
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

  rrdtool graph images/dnsping_"${what}"_week.png -h 500 -w 1200 -a PNG \
  --imginfo '<IMG SRC=/stats/%s WIDTH=%lu HEIGHT=%lu >' \
  --lazy --start -604800 --end -1800 \
  -v "Response Time (ms)" \
  --rigid \
  --lower-limit 0 \
  DEF:roundtrip=data/dnsping_"${what}".rrd:rtt:AVERAGE \
  DEF:packetloss=data/dnsping_"${what}".rrd:pl:AVERAGE \
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

  rrdtool graph images/dnsping_"${what}"_month.png -h 500 -w 1200 -a PNG \
  --imginfo '<IMG SRC=/stats/%s WIDTH=%lu HEIGHT=%lu >' \
  --lazy --start -2592000 --end -7200 \
  -v "Response Time (ms)" \
  --rigid \
  --lower-limit 0 \
  DEF:roundtrip=data/dnsping_"${what}".rrd:rtt:AVERAGE \
  DEF:packetloss=data/dnsping_"${what}".rrd:pl:AVERAGE \
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

  rrdtool graph images/dnsping_"${what}"_year.png \
  --imginfo '<IMG SRC=/stats/%s WIDTH=%lu HEIGHT=%lu >' \
  --lazy --start -31536000 --end -86400 -h 500 -w 1200 -a PNG \
  -v "Response Time (ms)" \
  --rigid \
  --lower-limit 0 \
  DEF:roundtrip=data/dnsping_"${what}".rrd:rtt:AVERAGE \
  DEF:packetloss=data/dnsping_"${what}".rrd:pl:AVERAGE \
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

