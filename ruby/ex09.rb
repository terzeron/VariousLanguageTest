#!/usr/bin/env ruby

puts 'hal'.tr('a-yz', 'b-za')

class String
  def rot13
    self.tr('a-z', 'n-za-m')
  end
end

a = 'geheimer text'
puts "a: #{a}"
b = a.rot13
puts "b: #{b}"
puts "b.rot13: #{b.rot13}"

