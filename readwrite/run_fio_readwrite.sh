#!/bin/bash
#SBATCH --partition=normal
#SBATCH --nodes=32
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --wait-all-nodes=1
#SBATCH --job-name=fio_readwrite
#SBATCH --time=50:00
#SBATCH --output=/users/ccocha/FIO/fio-tests/readwrite/32_node/%j.log
#SBATCH --error=/users/ccocha/FIO/fio-tests/readwrite/32_node/%j.err


# general settings
fio_njob=64
fio_directory=/scratch/snx2000/ccocha/readwrite/32_node
LOGSDIR_TOP=/users/ccocha/FIO/fio-tests/readwrite/32_node

# based on the above
LOGSDIR_JOB="$LOGSDIR_TOP/job_${SLURM_JOB_ID}_fiojob_$fio_njob"

# create a common dir for this job for the logs/results
[ -d "$LOGSDIR_JOB" ] && rm -rf "$LOGSDIR_JOB"
mkdir $LOGSDIR_JOB


# run the stuff on each node for each fio_njob
srun fio_readwrite.sh $LOGSDIR_JOB $fio_njob $fio_directory



