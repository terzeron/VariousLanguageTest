#!/usr/bin/env ruby

a = [ 1, 'cat', 3.14 ]
puts a[0]

a[2] = nil
puts a[2]

puts a

empty1 = []
empty2 = Array.new

puts "--- empty1 ---\n"
puts empty1

puts "--- empty2 ---\n"
puts empty2

a = %w{ ant bee cat dog elk }
puts "--- a ---\n"
puts a
puts a[0]
puts a[3]

instSection = {
  'cello' => 'string',
  'clarinet' => 'woodwind',
  'drum' => 'percussion',
  'oboe' => 'woodwind',
  'trumpet' => 'brass',
  'violin' => 'string'
}

puts instSection['oboe']
puts instSection['cello']
puts instSection['bassoon']

histogram = Hash.new(0)
puts histogram['key1']
histogram['key1'] = histogram['key1'] + 1
puts histogram['key1']
