#!/bin/bash
# avellaneda end of trading cycle

echo -ne "Current Time in secondsf >> "
date | awk '{print $4}' | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 }'
read -p "time until end of trading cycle >> " cycle_time
echo -ne $cycle_time | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 }'
