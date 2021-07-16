#!/bin/bash

# cli
LOGSDIR_JOB=$1
FIO_NJOB=$2
FIO_DIRECT=$3

THISHOST="`hostname`"
INSTANCE=$SLURM_LOCALID


# various variables
WORKDIR="/var/tmp/fiorun__$FIO_NJOB"
LOGSDIR_FIO_NJOB="$LOGSDIR_JOB/${THISHOST}_fiojob_$FIO_NJOB"

# create the logs directory 
[ -d "$LOGSDIR_FIO_NJOB" ] && echo "$LOGSDIR_FIO_NJOB already exists!!!" && exit 1
mkdir $LOGSDIR_FIO_NJOB

[ -d "$WORKDIR" ] && rm -rf $WORKDIR
mkdir $WORKDIR
cd $WORKDIR


# run fio for instance 0
if [ $INSTANCE -eq 0 ]
then
    FIO_NUM_JOBS=$FIO_NJOB FIO_DIRECTORY=$FIO_DIRECT fio /users/ccocha/FIO/fio-tests/seqread/seqread.fio >> output.log &

    # loop and collect network usage 
    # break out when the aboe process is finished
    PID=$!
    while true;
    do
        [ -n "${PID}" -a -d "/proc/${PID}" ] || break
        timestamp=$(date +%s )
        #bytes=`cat /sys/class/net/ib0/statistics/rx_bytes`
        bytes=( $timestamp $(ifconfig | grep "UP\|RX packets"  | awk '{print $5}') )
        printf " ${bytes[*]} " >> netlogs 
        printf " \n " >>netlogs
        unset bytes
        sleep 1
    done

    # save the net logs
    mv netlogs $LOGSDIR_FIO_NJOB/
    
else
    # for all the other instances
    FIO_NUM_JOBS=$FIO_NJOB FIO_DIRECTORY=$FIO_DIRECT  fio /users/ccocha/FIO/fio-tests/seqread/seqread.fio >> output.log
fi

# move the logs if exist
mv output.log $LOGSDIR_FIO_NJOB/
