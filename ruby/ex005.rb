#!/usr/bin/env ruby

# block
#{ puts "Hello" }

# block
#do
#  club.enroll(person)
#  person.socialize
#end

def callBlock
  yield
  yield
end

callBlock { puts "In the block" }

#def callBlock2
#  yield ,
#end

#callBlock2 { |, | ... }

# array
a = %w{ ant bee cat dog elk }
# iterate
a.each { |animal| puts animal }

# implementation
#def each
#  for each element
#    yield(element)
#  end
#end

[ 'cat', 'dog', 'horse' ].each do |animal|
  print animal, " -- "
end
puts "\n"

5.times { print "*" }
puts "\n"

3.upto(6) {|i| print i }
puts "\n"

('a'..'e').each {|char| print char}
puts "\n"

