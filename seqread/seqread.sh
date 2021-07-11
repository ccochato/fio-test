#!/bin/bash
#SBATCH --partition=normal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --wait-all-nodes=1
#SBATCH --job-name=cmssw_m2n_iobench
#SBATCH --time=01:00
#SBATCH --output=/users/ccocha/FIO/fio-tests/seqread/%j.log
#SBATCH --error=/users/ccocha/FIO/fio-tests/seqread/%j.err


fio --filename=device name --direct=1 --rw=read --bs=4k --ioengine=libaio --iodepth=256 --runtime=120 --numjobs=4 --time_based --group_reporting --name=iops-test-job --eta-newline=1 --readonly

intARR=()
intARR=( $(ifconfig | grep "UP\|RUNNIG" | awk '{print $1}' | grep ':' | tr -d ':' ) )
echo "${intARR[@]}"

while sleep 1; do
  data=()
  data[0]=$( date +%s ) #timestamp
  for i in "${intARR[@]}"; do
      data+=' '
      data+=$(cat /sys/class/net/$i/statistics/rx_bytes)
  
  printf " ${data[*]} " >>testn.txt
  printf " \n " >>testn.txt
  echo " ${data[*]} "
 
  unset data
  done
