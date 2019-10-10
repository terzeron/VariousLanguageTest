#!/usr/bin/env ruby

print "Array as stack: "
stack = Array.new()
stack.push('a')
stack.push('b')
stack.push('c')
print stack.pop until stack.empty?
print "\n"

print 'Array as queue: '
queue = Array.new()
queue.push('a').push('b').push('c')
print queue.shift until queue.empty?
print "\n"
