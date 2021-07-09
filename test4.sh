#!/bin/bash

#SBATCH --nodes=1

#SBATCH --cpus-per-task=1
#SBATCH --wait-all-nodes=1
#SBATCH --job-name=cmssw_m2n_iobench
#SBATCH --time=01:00

rx1=$(cat /sys/class/net/ipogif0/statistics/rx_bytes)
while sleep 1; do
    rx2=$(cat /sys/class/net/ipogif0/statistics/rx_bytes)
    timestamp=$(date +%s)
    date=( $timestamp $rx2 )
    printf 'Download rate: %s B/s\n' "$((rx2))"
    printf "%s\n" "${date[*]}" >>data.txt    
done
