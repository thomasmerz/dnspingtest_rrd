#!/bin/bash

[ -d ~/dev/dnspingtest_rrd/ ] || exit 1

for what in 80.69.96.12 45.90.28.39 45.90.30.39 1.1.1.1 1.0.0.1 8.8.8.8 8.8.4.4 208.67.222.222 208.67.220.220 84.200.69.80 84.200.70.40 9.9.9.11 149.112.112.11 192.168.0.1 192.168.42.241 192.168.0.13; do
  cp -af index_template.html ~/dev/dnspingtest_rrd/index_$what.html
  sed -i "s/192.168.0.13/$what/g" ~/dev/dnspingtest_rrd/index_$what.html
done

