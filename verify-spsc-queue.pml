#define QSIZE 10
byte pushp;
byte popp;
bit queue[QSIZE];

proctype Push() { 
    again:
    (pushp >= popp && pushp - popp < QSIZE-1 || 
        popp < pushp && (pushp + QSIZE) - popp < QSIZE-1 )  // aspetto che si liberi almeno un elemento dalla coda
    // aggiungo un elemento in queue[pushp+1]
    assert(queue[pushp] == 0)
    queue[pushp] = 1;
    pushp = (pushp +1) % QSIZE;
    assert((pushp >= popp && pushp - popp <= QSIZE-1  && pushp - popp >= 0)  || 
           (pushp < popp && (pushp + QSIZE)- popp <= QSIZE-1  && (pushp + QSIZE) - popp >= 0) )
    goto again
}

proctype Pop() { 
    again:
    (pushp != popp); // se la coda e' vuota, aspetta
    // leggo l'elemento in queue[popp]
    assert(queue[popp] == 1);
    queue[popp] = 0;
    popp = (popp + 1) % QSIZE;
    // questo assert non riesce a gestire il warparound
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
