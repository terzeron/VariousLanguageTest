#!/bin/bash

for OPT_LEVEL in 0 1 2 3; do
    rm -f test.s test2.s diff.${OPT_LEVEL}
    echo "gcc -o test.s.${OPT_LEVEL} -S test.c -O${OPT_LEVEL}"
    gcc -o test.s.${OPT_LEVEL} -S test.c -O${OPT_LEVEL} 
    echo "gcc -o test.s.${OPT_LEVEL} -S test2.c -O${OPT_LEVEL}"
    gcc -o test2.s.${OPT_LEVEL} -S test2.c -O${OPT_LEVEL} 
    diff test.s.${OPT_LEVEL} test2.s.${OPT_LEVEL} > diff.${OPT_LEVEL}
done
head -10000 diff.*
