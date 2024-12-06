#!/bin/bash

path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

cat /etc/hostname
cat /proc/cpuinfo
"$path/scripts/install_marco.sh" 
"$path/scripts/run.sh"
