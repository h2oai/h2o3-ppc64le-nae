#!/bin/bash

# If you want S3 support create a core-site.xml file and place it in $HOME/.ec2/

set -e

d=`dirname $0`

# Use 90% of RAM for H2O.
memTotalKb=`cat /proc/meminfo | grep MemTotal | sed 's/MemTotal:[ \t]*//' | sed 's/ kB//'`
memTotalMb=$[ $memTotalKb / 1024 ]
tmp=$[ $memTotalMb * 90 ]
xmxMb=$[ $tmp / 100 ]

java -Xmx${xmxMb}m -jar /opt/h2o.jar -name Nimbix -flatfile /opt/flatfile.txt -port 54321
