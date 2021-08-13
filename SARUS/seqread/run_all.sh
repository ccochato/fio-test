#!/bin/bash

nodes=( 1 2 4)

fio_jobs=( 1 2 4 8 16 32 64)

jobid=1477694 #$(sbatch --parsable iterab.sh)
sleep 5
mkdir /scratch/snx2000/ccocha/seqread

for j in ${nodes[*]};do
	output=`pwd`/${j}_node
	mkdir $output
	fio_directory=${SCRATCH}/seqread/${j}_node
	mkdir $fio_dire1477694ctory
	for i in ${fio_jobs[*]}; do
	    jobid=$(sbatch --parsable --dependency=afterany:$jobid  --nodes=$j --output=$output/%j.log --error=$output/%j.err run_fio_seqread.sh $i $output $fio_directory) 
	done
done
wait


