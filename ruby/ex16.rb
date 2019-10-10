#!/usr/bin/env ruby

# A simple iterator, calling the block once for each entry in the array
['i', 'am', 'a', 'banana'].each do | entry | print entry, ' ' end
puts ''

# Another commonly used iterator
# The block is called in the scope where it was created
fac = 1
1.upto(5) do | i | fac *= i end
puts fac
puts ''

# The result of the block can be used by the caller
[1, 2, 3, 4, 5].map { | entry | puts entry * entry }
puts [1, 2, 3, 4, 5].map { | entry | entry * entry }

# and more than one argument is allowed
print "Sum of 0 to 100: "
puts (0..100).inject(0) { | result, entry | result + entry }


