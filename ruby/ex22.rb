#!/usr/bin/env ruby

def is_true(value)
  value ? true : false
end

puts is_true(false)
puts is_true(nil)
puts is_true(true)
puts is_true(1)
puts is_true(0)
puts is_true([0,1,2])
puts is_true('a'..'z')
puts is_true('')
puts is_true(:a_symbol)
