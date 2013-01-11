#!/usr/bin/ruby
#
# bdfmerge.rb
# This file is part of TTF PC-9800.
#

if ARGV.length < 2
  puts "Usage: bdfmerge.rb basefile addfiles ..."
  exit 1
end


print IO.read(ARGV[-1]).match(/^.*ENDPROPERTIES\s*\n/m).to_s

chars = {}
ARGV.each do |arg|
  chars = IO.read(arg).scan(/STARTCHAR.+?ENDCHAR\s*\n/m).inject(chars) { |sum,s| sum[s.match(/ENCODING\s+(\d+)/)[1].to_i] = s; sum }
end

puts "CHARS " + chars.length.to_s + "\n"

chars.to_a.sort{ |a,b| a[0] <=> b[0] }.map { |a| a[1] }.each do |a|
  print a
end

puts "ENDFONT"
