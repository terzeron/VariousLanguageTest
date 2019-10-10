#!/usr/bin/env ruby

# Every assignment returns the assigned value
a = 4
puts "a=#{a}"

# So assignments can be chained
a = b = 4
puts "a+b=#{a + b}"

# and used in a test
file = File.open('ex01.rb')
linecount = 0
linecount += 1 while (line = file.gets)
puts "linecount: #{linecount}"

# shortcuts
a += 2
a = a + 2
puts "a=#{a}"

# Parallel assignment
puts "a=#{a} b=#{b}"
a, b = b, a
puts "a=#{a} b=#{b}"

# Array splitting
array = [1, 2]
a, b = *array
puts "a=#{a} b=#{b}"
