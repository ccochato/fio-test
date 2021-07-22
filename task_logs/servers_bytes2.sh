#!/bin/bash

# cli
LOGSDIR_JOB=$1

THISHOST="`hostname`"
INSTANCE=$SLURM_LOCALID


# various variables
WORKDIR="/var/tmp/fiorun__$INSTANCE"
LOGSDIR_TASK="$LOGSDIR_JOB/${THISHOST}__$INSTANCE"

# create the logs directory 
[ -d "$LOGSDIR_TASK" ] && echo "$LOGSDIR_TASK already exists!!!" && exit 1
mkdir $LOGSDIR_TASK

[ -d "$WORKDIR" ] && rm -rf $WORKDIR
mkdir $WORKDIR
cd $WORKDIR


# run fio for instance 0
if [ $INSTANCE -eq 0 ]
then
    fio /users/ccocha/FIO/fio-tests/task_logs/seqread.fio >> output.log &

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
    mv netlogs $LOGSDIR_TASK/
    
else
    # for all the other instances
    fio /users/ccocha/FIO/fio-tests/task_logs/seqread.fio >>output.log
fi

# move the logs if exist
mv iotest $LOGSDIR_TASK/
mv output.log $LOGSDIR_TASK/
