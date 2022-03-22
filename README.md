# Purpose of this project
This project implement a nice monitoring of average response times of DNS resolvers based on [dnsping](https://dnsdiag.org/) in RRD databases and simple HTML pages with PNG graphs. With these information you can decide which DNS resolver to choose for performance reasons.  

![image](https://user-images.githubusercontent.com/18568381/158039572-d814b991-addc-4953-aa33-9ceb7f513bf4.png)
(45.90.30.39 [NextDNS.io](https://nextdns.io/de) Monthly Response Times & Loss Stats(5min average))  

vs.  

![image](https://user-images.githubusercontent.com/18568381/158039581-f8e41d32-f153-4bf5-b1db-884309252fb2.png)
(9.9.9.11 [Quad9](https://quad9.net/) Monthly Response Times & Loss Stats(5min average))  

vs.  
![image](https://user-images.githubusercontent.com/18568381/158039631-71648a7f-8a92-45df-9487-31be7eb3cd04.png)
(192.168.0.13 [Pi-hole](https://github.com/pi-hole) Monthly Response Times & Loss Stats(5min average)) 

There are the following scripts that are doing the following:

```
01_dnsping.sh with optional parameters: random or example.com
02_dnsping-graph.sh
98_create_html.sh
98_create_rrd.sh
```

## 01_dnsping.sh
Run this script periodically (for example every 5 minutes) via crontab to performance-test some DNS resolvers. All results are written into RRD database(s).  
You may use `random` domains or specify a domain to be queried if you don't want to use the default (heise.de).  

🚧 You have to check and edit [resolvers](01_dnsping.sh#L76) in this file!

## 02_dnsping-graph.sh
Run this script periodically (for example every hour) via crontab to create PNG-chart(s) from results RRD database(s) for hourly/daily/weekly/monthly/yearly charts.

🚧 You have to check and edit [resolvers](02_dnsping-graph.sh#L5) in this file!

## 98_create_html.sh
Run this script once to copy and edit html-files from template for all DNS resolvers that are "configured" in this script.  

🚧 You have to check and edit [resolvers](98_create_html.sh#L3R) in this file!

## 98_create_rrd.sh
Run this script once to create rrd-database-files all DNS resolvers that are "configured" in this script.  

🚧 You have to check and edit [resolvers](98_create_rrd.sh#L19) in this file!

## Crontab
```
# this is my dnsping:
*/5 * * * * ~/dev/dnspingtest_rrd/01_dnsping.sh >/dev/null
0   * * * * ~/dev/dnspingtest_rrd/02_dnsping-graph.sh >/dev/null
```

## Examples
I've uploaded some real-world [examples](examples) from my home-network (Vodafone Gigabit wth 1000 downlink and 50 Mbit uplink with a static domain and with random domains for every DNS resolver, and some [Hetzner-Cloudserver](https://www.hetzner.com/de/cloud) in Nuremberg/Germany and Helsinki/Finland) monitored via Wifi which is how most devices/gadgets nowadays are connected and what query times they will experience, too. This is much more realistic for home- and end-users than monitoring via a direct connection to DE-CIX. Please watch out for the index-html files.  


## Alternatives
If you are more cloud-savvy, you could do this also with [Netdata](https://www.netdata.cloud/) and these docs/links:
* [DNS query monitoring with Netdata](https://learn.netdata.cloud/docs/agent/collectors/go.d.plugin/modules/dnsquery)
* [netdata go.d.plugin configuration for dns_query](https://github.com/netdata/go.d.plugin/blob/master/config/go.d/dns_query.conf)
* [detect dns query failure](https://github.com/netdata/netdata/blob/master/health/health.d/dns_query.conf)

Which gives you this for example:

<img width="800" alt="image" src="https://user-images.githubusercontent.com/18568381/158039823-543e1250-6b93-43c5-8b28-2122ac2588fc.png">
<img width="800" alt="image" src="https://user-images.githubusercontent.com/18568381/158039834-5aac9521-2ee6-415f-aa17-4108becd203f.png">
<img width="800" alt="image" src="https://user-images.githubusercontent.com/18568381/158039846-9b340832-38da-4a8a-bd40-580f9878e9ca.png">
<img width="800" alt="image" src="https://user-images.githubusercontent.com/18568381/158039861-035d1fb6-425c-4584-96e8-f1a28bdd5293.png">

Have fun!

