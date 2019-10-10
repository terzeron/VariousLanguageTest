#!/usr/bin/env ruby

# Literal hash
h0 = { 'one' => 1, 'two' => 2, 'three' => 3}
puts h0
puts h0['one']

# Populating a hash
h1 = Hash.new
h1['gemstone'] = 'ruby'
h1['fruit'] = 'banana'
puts h1

# Oftne symbols are used as keys
h2 = {:june => 'perl', :july => 'ruby'}
puts h2[:july]

# But arbitrary keys are possible
a = ['Array', 1]
b = ['Array', 2]
h3 = { a => :a1, b => :a2 }
puts h3[a]
