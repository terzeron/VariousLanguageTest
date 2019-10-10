#!/usr/bin/env ruby

line = "xxxPerlxxxPerlyyyyy"
if line =~ /Perl|Python/
  puts "Scripting language mentioned: #{line}"
end

newline = line.sub(/Perl/, 'Ruby')
puts newline

newline = line.gsub(/Perl/, 'Ruby')
puts newline
