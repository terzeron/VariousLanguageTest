#!/usr/bin/env ruby

puts "hello".tr('aeiou', '*')
puts "hello".tr('^aeiou', '*')
puts "hello".tr('el', 'ip')
puts "hello".tr('a-y', 'b-z')
