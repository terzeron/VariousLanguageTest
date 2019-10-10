#!/usr/bin/env io

fruits := list("apple", "banana", "lemon")
fruits append("orange")
fruits appendSeq(list("strawberry", "blueberry", "raspberry"))
fruits println

fruits at(0) println
fruits at(3) println
fruits first println
fruits last println
fruits size println

fruits join(", ") println
fruits map(asUppercase) println
fruits select(endsWithSeq("berry")) println
fruits reduce(a, b, a .. " and " .. b) println
fruits sortByKey(size) println
fruits reverse println

name := "abcdefghijklmnop"
name println
name size println
name reverse println

3.14 round println
3.14 ceil println
3.14 floor println
16 sqrt println
11 factorial println
-123 abs println
(-123) abs println

true println
false println
1 == 1 println
1 == 2 println
true not println
false not println
true and false println
true and true println
false and false println
