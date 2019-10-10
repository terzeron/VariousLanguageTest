#!/usr/bin/env ruby

def greet(*names)
  case names.length
  when 0
    "How sad, nobody wants to hear my talk."
  when 1
    "Hello #{names}. At least one wants to hear about ruby."
  when 2..5
    "Hello #{names.join(', ')}. Good that all of you are interested."
  when 6 .. 10
    "#{names.length} students. That's perfect. Welcome to ruby!"
  else
    "Wow #{names.length} students. We'll have to find a bigger room."
  end
end

puts greet()
puts greet('A')
puts greet('A', 'B')
puts greet('Ashraf', 'Ingo', 'Jens', 'Johannes', 'Marius', 'Robert', 'Stefan',
           'Thorsten', 'Tobias', 'Jet Loong')
