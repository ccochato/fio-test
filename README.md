TASKS:

1)  install fio
2)  check how to write configuration files

more instructions

1)  do this on a single node, using a disk on the node.
2)  do this on a single node, but now using the shared storage instead compare results
3)  when doing 2, i want u to also script up so that u can get network rx/tx traffic. e.g. using this: “cat /sys/class/net/ib0/statistics/rx_bytes”, u can record this every second or whatever u want and then later analyze, etc… rx_bytes -> received bytes tx_bytes -> sent bytes thru the nic
4)  when u run 2) with 3) u will be recording how many bytes are received due to u reading from a filesystem over a network. i want u to plot bytes vs timestamp. this way u can graphically see the amount of traffic
5)  do this for 1, 2, 4, 8, 16, … 64 nodes. per node fio should give u some stats. record this for further analysis and record network traffic over each node

-------------------------------------------------------------------

Installing:
First download it from the git repo:
git://git.kernel.dk/fio.git or http://git.kernel.dk/fio.git

Then building:
 $ ./configure
 $ make
 $ make install 

Finally to run fio:
 $ fio [options] [jobfile]
 
--------------------------------------------------------

To see some examples of seqread, ranread, randwrite and seqwrite 
go to the /examples/ folder

--------------------------------------------------------

Now using ifconfig  to check and use the ports in the UP state.\n
Using sequential read

The results are in the folder ./seqread/ but the code just run 1 second  using sbatch.
Ask what I am doing wrong. See seqread.sh.
Runnig the code in my local PC it runs well and the results are like the test_n.txt file


----------------------------------
July 12th

I implemented the suggestions and the results are in tak5 folder. 
Please take a look and give me more suggestions.

The job file is test.sh

> sbatch test.sh

-----------------------------------------------



