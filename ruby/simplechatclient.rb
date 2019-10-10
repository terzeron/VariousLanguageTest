#!/usr/bin/env ruby

require 'socket'
require 'thread'

host = ARGV[0] || 'localhost'
port = ARGV[1] || 1111

socket = TCPSocket.new(host, port)

t = Thread.new do
  while line = socket.gets
    puts "Received: #{$line}"
  end
  socket.close
end

while line = $stdin.gets
  break if /^exit/ =~ line
  socket.puts line
end
socket.puts 'QUIT'

t.join
