#!/usr/bin/env ruby

class Song
  def initialize(name, artist, duration)
    @name = name
    @artist = artist
    @duration = duration
  end
  attr_reader :name, :artist, :duration
end

aSong = Song.new("Bicylops", "Fleck", 260)
print aSong.artist, "\n"
print aSong.name, "\n"
print aSong.duration, "\n"
