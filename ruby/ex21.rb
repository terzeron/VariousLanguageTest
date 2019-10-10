#!/usr/bin/env ruby

if (1 + 1 == 2)
  puts "Like in school"
else
  puts "What a surprise!"
end

puts "Like in school" if (1 + 1 == 2)
puts "Surprising!" unless (1 + 1 == 2)

puts (1 + 1 == 2) ? 'Working' : 'Defect'

spam_probability = rand(100)
case spam_probability
when 0..10 then puts "Lowest probability"
when 10..50 then puts "Low probability"
when 50..90 then puts "High probability"
when 90..100 then puts "Highest probability"
end
