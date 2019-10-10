#!/usr/bin/env ruby

class Song
  def initialize(name, artist, duration)
    @name = name
    @artist = artist
    @duration = duration
  end
end

aSong = Song.new("Bicylops", "Fleck", 260)
print aSong.inspect, "\n"

print "to_s:", aSong.to_s, "\n"

# KaraokeSong: subclass
class KaraokeSong < Song
  def initialize(name, artist, duration, lyrics)
    super(name, artist, duration)
    @lyrics = lyrics
  end
end


    
