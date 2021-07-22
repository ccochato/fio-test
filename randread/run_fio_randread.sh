#!/bin/bash
#SBATCH --partition=normal
#SBATCH --nodes=150
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --wait-all-nodes=1
#SBATCH --job-name=cmssw_m2n_iobench
#SBATCH --time=60:00
#SBATCH --output=/users/ccocha/FIO/fio-tests/randread/150_node/%j.log
#SBATCH --error=/users/ccocha/FIO/fio-tests/randread/150_node/%j.err


# general settings
fio_njob=64
fio_directory=/scratch/snx2000/ccocha/randread/150_node
LOGSDIR_TOP=/users/ccocha/FIO/fio-tests/randread/150_node

# based on the above
LOGSDIR_JOB="$LOGSDIR_TOP/job_${SLURM_JOB_ID}_fiojob_$fio_njob"

# create a common dir for this job for the logs/results
[ -d "$LOGSDIR_JOB" ] && rm -rf "$LOGSDIR_JOB"
mkdir $LOGSDIR_JOB


# run the stuff on each node for each fio_njob
srun fio_randread.sh $LOGSDIR_JOB $fio_njob $fio_directory



