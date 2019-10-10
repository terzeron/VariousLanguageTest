#!/usr/bin/env ruby

i = 1
while (i < 10)
  i *= 2
end
puts i

i *= 2 while (i < 100)
puts i

begin
  i *= 2
end while (i < 100)
puts i

i *= 2 until (i >= 1000)
puts i

loop do
  break if (i >= 4000)
  i *= 2
end
puts i

4.times do i *= 2 end
puts i

r = []
for i in 0..7
  next if i % 2 == 0
  r << i
end
puts r

(0..7).select { |i| i % 2 != 0 }
 
