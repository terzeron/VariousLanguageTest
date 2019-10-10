#!/usr/bin/env ruby

puts (5.6).round
puts (5.6).class
puts (5.6).round.class

puts 'a string'.length
puts 'a string'.class
puts 'tim tells'.gsub('t', 'j')

puts 'abc'.gsub('b', 'xxx').length

puts ['some', 'things', 'in', 'an', 'array'].length
puts ['some', 'things', 'in', 'an', 'array'].reverse
puts ['some', 'things', 'in', 'an', 'array'].sort.reverse

puts Float.class
puts Class.class
puts Object.class
