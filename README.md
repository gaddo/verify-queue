 # verify-queue

This is an experiment to formally verify a single producer / single consumer fifo queue.

The use case I have in mind is the communication between two processor with some shared memory; in my instance it is the main ARM V8 core and the PRU of the arm 335x of the Beaglebone Black.

I will use [Spin](http://spinroot.com/spin/whatispin.html) with a simplified model of my queue.

To check this model, install spin and run

    spin -a verify-spsc-queue.pml
    gcc -DMEMLIM=1024 -O2 -DXUSAFE -DSAFETY -DNOCLAIM -w -o pan pan.c
    ./pan

>(Spin Version 6.4.5 -- 1 January 2016)
>        + Partial Order Reduction
>
>Full statespace search for:
>        never claim             - (not selected)
>        assertion violations    +
>        cycle checks            - (disabled by -DSAFETY)
>        invalid end states      +
>
>State-vector 44 byte, depth reached 234, errors: 0
>     1336 states, stored
>     1201 states, matched
>     2537 transitions (= stored+matched)
>        0 atomic steps
>hash conflicts:         0 (resolved)
>
>Stats on memory usage (in Megabytes):
>    0.092       equivalent memory usage for states (stored*(State-vector + overhead))
>    0.290       actual memory usage for states
>  128.000       memory used for hash table (-w24)
>    0.534       memory used for DFS stack (-m10000)
>  128.730       total actual memory usage
>
>
>unreached in proctype Push
>        p94.pml:17, state 7, "-end-"
>        (1 of 7 states)
>unreached in proctype Pop
>        p94.pml:30, state 7, "-end-"
>        (1 of 7 states)
>unreached in init
>        (0 of 15 states)
>
>pan: elapsed time 0.01 seconds

this (i hope ! ) proves that:

1. the size of the fifo is never smaller that 0
2. the size is never bigger than QSIZE
3. every element that i pop from the queue has been pushed
4. every element i push on the queue is not on an unread already pushed element

The main problem in the implementation of the model is to handle correctly the wraparound of the head and tail pointers. See the assertions the pml ...

This is my very first formal verification; any kind of feedback is welcome !
