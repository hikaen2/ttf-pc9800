#!/usr/bin/ruby
#
# bdfremap.rb
# This file is part of TTF PC-9800.
#

if ARGV.length != 2
  puts "Usage: bdfremap.rb bdffile mapfile"
  exit
end


def sjis_to_jis(sjis)
  hi = (sjis >> 8) & 0xff
  lo = sjis & 0xff
  return lo if hi == 0
  
  hi -= (hi<=0x9f) ? 0x71 : 0xb1
  hi = hi * 2 + 1
  lo -= (lo > 0x7f) ? 1 : 0
  hi += (lo >= 0x9e) ? 1 : 0
  lo -= (lo >= 0x9e) ? 0x7d : 0x1f
  return hi << 8 | lo
end

def parse_map(map)
  map.scan(/0x([0-9A-Fa-f]+)[ \t]+0x([0-9A-Fa-f]+)/).map {|sjis, unicode| [sjis.hex, unicode.hex] }.group_by {|sjis, unicode| unicode }.values.map {|arrays| arrays.min }
end


bdf = IO.read(ARGV[0])
print bdf.match(/^.*ENDPROPERTIES\s*\n/m)
chars = bdf.scan(/STARTCHAR.+?ENDCHAR\s*\n/m).inject({}) { |sum,s| sum[s.match(/ENCODING\s+(\d+)/)[1].to_i] = s; sum }

out = []
parse_map(IO.read(ARGV[1])).map {|sjis, unicode| [sjis_to_jis(sjis), unicode] }.each do |jis, unicode|
  out << chars[jis].gsub(/ENCODING\s+(\d+)/) { |m| sprintf('ENCODING %d', unicode) } if chars[jis]
end

puts "CHARS " + out.length.to_s
print out.join
puts "ENDFONT"
