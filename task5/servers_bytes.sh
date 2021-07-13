#!/bin/bash

bytes_counter(){
  filename="node_""$1""_$(date +%s)"

  servers=( $(ifconfig | grep "UP\|RUNNIG" | awk '{print $1}' | grep ':' | tr -d ':' ) )
  echo "Timestamp "" ${servers[*]} " >>$filename.txt

  while sleep 1; do
    timestamp=$(date +%s )
    ser_byt=( $timestamp $(ifconfig | grep "UP\|RX packets"  | awk '{print $5}') )
    printf " ${ser_byt[*]} " >>$filename.txt
    printf "\n" >>$filename.txt
    unset ser_byt
  done
}

fio seqread.fio
bytes_counter $1
