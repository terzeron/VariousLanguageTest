#!/usr/bin/env ruby

count = 5
tries = 3

if count > 10
  puts "Try again"
elsif tries == 3
  puts "You lose"
else
  puts "Enter a number"
end

#while weight < 100 and numPallets <= 30
#  pallet = nextPallet()
#  weight += pallet.weight
#  numPallets += 1
#end

radiation = 5000
if radiation > 3000
  puts "Danger, Will Robinson"
end

puts "Danger, Will Robinson" if radiation > 3000

square = 1.02
while square < 1000
  square = square * square
  puts square;
end

square = square * square while square < 1000
