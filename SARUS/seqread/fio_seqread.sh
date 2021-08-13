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

#[ -d "$WORKDIR" ] && rm -rf $WORKDIR
#mkdir $WORKDIR
#cd $WORKDIR

sarus run \
 --mount=type=bind,source=$FIO_DIRECT,destination=/iotest/work \
 ccocha/fio_seqread \
 fio --iodepth=32  --numjobs=$FIO_NJOB --output-format=json --output=${THISHOST}_output.json /iotest/seqread.fio
# move the json if exist
cd $FIO_DIRECT
mv ${THISHOST}_output.json $LOGSDIR_FIO_NJOB/output.json
#rm -r $WORKDIR
