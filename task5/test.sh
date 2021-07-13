#!/bin/bash
#SBATCH --partition=normal
#SBATCH --nodes=130
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --wait-all-nodes=1
#SBATCH --job-name=cmssw_m2n_iobench
#SBATCH --time=01:00
#SBATCH --output=/users/ccocha/FIO/fio-tests/task5/%j.log
#SBATCH --error=/users/ccocha/FIO/fio-tests/task5/%j.err


nodes=( 1 2 4 8 16 32 64)


chmod +x servers_bytes.sh

for i in ${nodes[*]}; do
  srun \
    -N1 \
    --mem=124G \
    
    bash servers_bytes.sh $i --subset $i --file $1 &
done

wait
