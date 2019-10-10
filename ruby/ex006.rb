#!/usr/bin/env ruby

printf "Number: %5.2f, String: %s\n", 1.23, "hello"

line = gets
print line

while gets
  if /Ruby/
    print
  end
end
