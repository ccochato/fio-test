#!/bin/bash -l
#SBATCH --partition=normal
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --wait-all-nodes=1
#SBATCH --job-name=fio_seqread
#SBATCH --time=60:00
#SBATCH --constraint=cache,quad

# general settings
fio_njob=$1
LOGSDIR_TOP=$2
fio_directory=$3

# based on the above
LOGSDIR_JOB="$LOGSDIR_TOP/job_${SLURM_JOB_ID}_fiojob_$fio_njob"

# create a common dir for this job for the logs/results
[ -d "$LOGSDIR_JOB" ] && rm -rf "$LOGSDIR_JOB"
mkdir $LOGSDIR_JOB

# run the stuff on each node for each fio_njob
srun fio_seqread.sh $LOGSDIR_JOB $fio_njob $fio_directory



