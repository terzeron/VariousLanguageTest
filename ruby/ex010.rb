#!/usr/bin/env ruby

class Song
  def initialize(name, artist, duration)
    @name = name
    @artist = artist
    @duration = duration
  end
  def to_s
    "Song: #{@name}--#{@artist} (#{@duration})"
  end
end

# KaraokeSong: subclass
class KaraokeSong < Song
  def initialize(name, artist, duration, lyrics)
    super(name, artist, duration)
    @lyrics = lyrics
  end
  def to_s
    super + " [#{@lyrics}]"
  end
end

aSong = KaraokeSong.new("My Way", "Sinatra", 225, "And now, the end...")
print aSong.to_s, "\n"

    
