#!/usr/bin/env ruby

# Literal Array
puts ['An', 'array', 'with', 5, 'entries'].join(' ')

# New Array
a = Array.new
a << 'some' << 'things' << 'appended'
puts a[2]
a[0] = 3
puts a
puts "#{a}"

# Default values can be used 
puts Array.new(10, 0)

# ... but beware of the reference
a = Array.new(2, 'Slike')
a[0] << 'Amberg'
puts a
