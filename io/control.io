#!/usr/bin/env io

(1 == 2) then ("1 equals to 2." println) else ("1 does not equal to 2." println)

if(1 == 2, "1 equals to 2.", "1 does not equal to 2.") println

fruits := list("apple", "banana", "lemon", "orange", "strawberry", "blueberry", "raspberry")
fruits foreach(fruit, fruit println)
fruit foreach (println)


