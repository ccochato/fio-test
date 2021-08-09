#!/bin/bash

fio_jobs=( 1 2 4 8 16)
fio_bs=( 4k 8k 16k)
fio_workdir=/tmp/fio-data

#create the image ccocha/test2 using the Dockerfile
sudo docker build -t ccocha/test2 .
#directory to save the results
mkdir `pwd`/iotest

for j in ${fio_bs[*]};do
	mkdir `pwd`/iotest/${j}_bs
	
	for i in ${fio_jobs[*]}; do
		output=`pwd`/iotest/${j}_bs/${i}_fiojob
		mkdir $output
		sudo rm -rf $fio_workdir/*
		#run the Dockerfile		
		sudo docker run -v  $fio_workdir:/iotest/work  ccocha/test2 --numjobs=$i --bs=$j --output-format=json --output=output.json /iotest/seqread.fio
		#save the results
		sudo mv $fio_workdir/output.json $output
		
	done
done

#plot and save the results
python plots-seq_read.py
sudo mv seqread.png  `pwd`/iotest
sudo mv  seqread_3d.png `pwd`/iotest

wait


