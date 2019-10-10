#!/usr/bin/env ruby

require 'socket'
require 'thread'

host, port = ARGV[0], ARGV[1]
semaphore = Mutex.new
server = TCPServer.new(host, port)
clients = []

while (socket = server.accept)
  semaphore.synchronize do clients << socket end
  swt = Thread.new(socket) do | the_socket |
    while line = the_socket.gets
      break if /^QUIT/ =~ line
      semaphore.synchronize do
        clients.each do | client |
          clients.puts line if client != the_socket
        end
      end
    end
    semaphore.synchronize do clients.delete(socket) end
    socket.close
  end
end
