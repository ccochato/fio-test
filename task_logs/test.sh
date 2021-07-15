#!/bin/bash
#SBATCH --partition=normal
#SBATCH --nodes=10
#SBATCH --ntasks-per-node=6
#SBATCH --cpus-per-task=1
#SBATCH --wait-all-nodes=1
#SBATCH --job-name=cmssw_m2n_iobench
#SBATCH --time=02:00
#SBATCH --output=/users/ccocha/FIO/fio-tests/task_logs/%j.log
#SBATCH --error=/users/ccocha/FIO/fio-tests/task_logs/%j.err


nodes=( 1 2 4 8 16 32 64)


# general settings

LOGSDIR_TOP=/users/ccocha/FIO/fio-tests/task_logs/job_logs
NUM_CORES=$SLURM_CPUS_PER_TASK

# based on the above
LOGSDIR_JOB="$LOGSDIR_TOP/job_$SLURM_JOB_ID"

# create a common dir for this job for the logs/results
[ -d "$LOGSDIR_JOB" ] && rm -rf "$LOGSDIR_JOB"
mkdir $LOGSDIR_JOB


# run the stuff on each node for each task/exe
srun servers_bytes2.sh $LOGSDIR_JOB $NUM_CORES $DATADIR


