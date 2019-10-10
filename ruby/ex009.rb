#!/usr/bin/env ruby

class KaraokeSong
  def initialize(name, artist, duration, lyrics)
    @name = name
    @artist = artist
    @duration = duration
    @lyrics = lyrics
  end
  def to_s
    "KS: #{@name} - - #{@artist} (#{@duration}) [#{@lyrics}]"
  end
end

aSong = KaraokeSong.new("My Way", "Sinatra", 225, "And now, the ...")
print aSong.to_s, "\n"
