#!/usr/bin/env ruby

class Person
  def initialize(name)
    @name = name
  end

  def greet
    "Hello, my name is #{@name}."
  end
end

brian = Person.new('Brian')
puts brian.greet
