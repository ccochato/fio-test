TASKS:

    install, should be trivial
    check how to write configuration files
    again, create a github repo: fio-tests and create several tests, based on what u learn in 2) have a readme file in there

more instructions

    do this on a single node, using a disk on the node.
    do this on a single node, but now using the shared storage instead compare results
    when doing 2, i want u to also script up so that u can get network rx/tx traffic. e.g. using this: “cat /sys/class/net/ib0/statistics/rx_bytes”, u can record this every second or whatever u want and then later analyze, etc… rx_bytes -> received bytes tx_bytes -> sent bytes thru the nic
    when u run 2) with 3) u will be recording how many bytes are received due to u reading from a filesystem over a network. i want u to plot bytes vs timestamp. this way u can graphically see the amount of traffic
    do this for 1, 2, 4, 8, 16, … 64 nodes. per node fio should give u some stats. record this for further analysis and record network traffic over each node
