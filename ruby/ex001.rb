#!/usr/bin/env ruby

def sayGoodnight(name)
  result = "Goodnight, " + name;
  result = result + " Good evening, #{name}"
  return result;
end

puts sayGoodnight("John-Boy")
puts sayGoodnight("Mary-Ellen")
puts (sayGoodnight("John-Boy"))
puts (sayGoodnight"Mary-Ellen")

puts "And Goodnight,\nGrandma"

# name: local variable
# $name: global variable
# @name: instance
# @@name: class
# PI: constant
# MyClass: class name
