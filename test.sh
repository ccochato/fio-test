#!/bin/bash

rx1=$(cat /sys/class/net/ib0/statistics/rx_bytes)
while sleep 1; do
    rx2=$(cat /sys/class/net/ib0/statistics/rx_bytes)
    timestamp=$(date +%s)
    date=( $timestamp $rx2 )
    printf 'Download rate: %s B/s\n' "$((rx2))"
    printf "%s\n" "${date[*]}" >>date.txt    
done
