#define QSIZE 10
byte pushp;
byte popp;
// this array track the validity of the data in the queue; 
// 0 means that the data is free/invalid, 1 mean that the data has been pushed 
bit queue[QSIZE];

proctype Push() { 
    again:
    // this is the spin syntax to say while (!condition) /* wait */;
    (pushp >= popp && pushp - popp < QSIZE-1 || 
        popp < pushp && (pushp + QSIZE) - popp < QSIZE-1 )  // wait to get at least a free element in the queue
        
    // verify that queue[pushp] contains a really free element
    assert(queue[pushp] == 0)
    // mark the slot as used
    queue[pushp] = 1;
    // increment the push pointer
    pushp = (pushp +1) % QSIZE;
    // verify that we have not overrun or underrun the queue
    assert((pushp >= popp && pushp - popp <= QSIZE-1  && pushp - popp >= 0)  || 
           (pushp < popp && (pushp + QSIZE)- popp <= QSIZE-1  && (pushp + QSIZE) - popp >= 0) )
    goto again
}

proctype Pop() { 
    again:
    (pushp != popp); // wait to get at least an element in the queue
    
    // verify that the element in the queue was pushed before freeing
    assert(queue[popp] == 1);
    // mark element as unused
    queue[popp] = 0;
    // increment the pop pointer
    popp = (popp + 1) % QSIZE;
    // verify that we have not overrun or underrun the queue
    assert((pushp >= popp && pushp - popp <= QSIZE-1  && pushp - popp >= 0)  || 
           (pushp < popp && (pushp + QSIZE)- popp <= QSIZE-1  && (pushp + QSIZE) - popp >= 0) )
    goto again;
}

init {
    pushp = 0;
    popp = 0;
    int i;
    for (i : 0 .. QSIZE-1) {
        queue[i] = 0;
    }
    run Push();
    run Pop();
}
