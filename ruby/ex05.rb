#!/usr/bin/env ruby

class Person
  def initialize(name)
    @name = name
  end

  def greet
    "Hello, my name is #{@name}."
  end
end

class Matz < Person
  def initialize
    super('Yukihiro Matsumoto')
  end
end

puts Matz.new.greet
