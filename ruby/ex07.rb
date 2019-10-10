#!/usr/bin/env ruby

def multi_foo(count = 3)
  'foo ' * count
end

puts multi_foo(3)

puts 'Simple #{multi_foo(2)}'
puts "Interpolated #{multi_foo}"

puts 10
puts 0.5
puts 2e-4
puts 0xFFFF
puts 010
