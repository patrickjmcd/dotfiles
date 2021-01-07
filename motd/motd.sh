#!/bin/bash

user=`whoami`
date=`date`
printf "Welcome, ${user}. It's currently ${date}"
source $(dirname $0)/services.sh
source $(dirname $0)/cpu.sh

echo "System:"
system_profiler SPSoftwareDataType | tail -n10 | cut -c 5- 
source $(dirname $0)/colors.sh
# cat $(dirname $0)/apple.txt | lolcat
echo 
