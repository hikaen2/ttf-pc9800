#!/usr/bin/ruby
#
# createmap.rb
# This file is part of TTF PC-9800.
#

require 'rubygems'
require 'sqlite3'
require 'tempfile'


def jis_to_sjis(jiscode)
  return jiscode if jiscode <= 0x00ff
  high = (jiscode >> 8) & 0x00ff
  low = jiscode & 0x00ff
  low += (high & 0x01) == 1 ? 0x1f : 0x7d
  low += 1 if low >= 0x7f
  high = (high - 0x21 >> 1) + 0x81
  high += 0x40 if high > 0x9f
  return (high << 8) | low
end


def kuten_to_jis(ku, ten)
  ((ku + 0x20) << 8) + (ten + 0x20)
end


if ARGV.length != 2
  puts 'Usaga: createmap.rb Uni2JIS CP932.TXT'
  exit 1
end


db = SQLite3::Database.new(Tempfile.new('').path)
db.execute('CREATE TABLE sjis78_to_unicode (sjis78 INTEGER PRIMARY KEY, unicode INTEGER)')
db.execute('CREATE TABLE cp932_to_unicode (cp932 INTEGER PRIMARY KEY, unicode INTEGER)')
db.execute('CREATE TABLE sjisext_to_unicode (sjisext INTEGER PRIMARY KEY, unicode INTEGER)')

db.transaction do
  IO.read(ARGV[0]).scan(/([0-9A-Fa-f]+)\t.*0-(\d\d)(\d\d)/).map {|unicode, ku, ten| [unicode.hex, jis_to_sjis(kuten_to_jis(ku.to_i, ten.to_i))] }.each do |unicode, sjis|
    db.execute('INSERT INTO sjis78_to_unicode VALUES (?, ?)', sjis, unicode)
  end
  IO.read(ARGV[1]).scan(/0x([0-9A-Fa-f]+)[ \t]+0x([0-9A-Fa-f]+)/).map {|cp932, unicode| [cp932.hex, unicode.hex] }.each do |cp932, unicode|
    db.execute('INSERT INTO cp932_to_unicode VALUES (?, ?)', cp932, unicode)
  end
  db.execute('INSERT INTO sjisext_to_unicode SELECT * FROM sjis78_to_unicode')
  db.execute('INSERT INTO sjisext_to_unicode SELECT * FROM cp932_to_unicode WHERE cp932 <= 255')
  db.execute("INSERT INTO sjisext_to_unicode SELECT * FROM cp932_to_unicode WHERE cp932 BETWEEN #{0x8740} AND #{0x879E}")  # 13ku
  db.execute("INSERT INTO sjisext_to_unicode SELECT * FROM cp932_to_unicode WHERE cp932 BETWEEN #{0xED40} AND #{0xEF3F}")  # 89ku..92ku

  db.execute("UPDATE sjisext_to_unicode SET unicode = #{0xA5} WHERE sjisext = #{0x5C} AND unicode = #{0x5C}")  # 0x5C is YEN SIGN(U+00A5), not REVERSE SOLIDUS(U+005C).
  db.execute("INSERT INTO sjisext_to_unicode VALUES(#{0xFC}, #{0x5C})")   # REVERSE SOLIDUS
  db.execute("INSERT INTO sjisext_to_unicode VALUES(#{0x80}, #{0x2581})") # LOWER ONE EIGHTH BLOCK
  db.execute("INSERT INTO sjisext_to_unicode VALUES(#{0x81}, #{0x2582})") # LOWER ONE QUARTER BLOCK
  db.execute("INSERT INTO sjisext_to_unicode VALUES(#{0x82}, #{0x2583})") # LOWER THREE EIGHTHS BLOCK
  db.execute("INSERT INTO sjisext_to_unicode VALUES(#{0x83}, #{0x2584})") # LOWER HALF BLOCK
  db.execute("INSERT INTO sjisext_to_unicode VALUES(#{0x84}, #{0x2585})") # LOWER FIVE EIGHTHS BLOCK
  db.execute("INSERT INTO sjisext_to_unicode VALUES(#{0x85}, #{0x2586})") # LOWER THREE QUARTERS BLOCK
  db.execute("INSERT INTO sjisext_to_unicode VALUES(#{0x86}, #{0x2587})") # LOWER SEVEN EIGHTHS BLOCK
  db.execute("INSERT INTO sjisext_to_unicode VALUES(#{0x87}, #{0x2588})") # FULL BLOCK
  db.execute("INSERT INTO sjisext_to_unicode VALUES(#{0x88}, #{0x258F})") # LEFT ONE EIGHTH BLOCK
  db.execute("INSERT INTO sjisext_to_unicode VALUES(#{0x89}, #{0x258E})") # LEFT ONE QUARTER BLOCK
  db.execute("INSERT INTO sjisext_to_unicode VALUES(#{0x8A}, #{0x258D})") # LEFT THREE EIGHTHS BLOCK
  db.execute("INSERT INTO sjisext_to_unicode VALUES(#{0x8B}, #{0x258C})") # LEFT HALF BLOCK
  db.execute("INSERT INTO sjisext_to_unicode VALUES(#{0x8C}, #{0x258B})") # LEFT FIVE EIGHTHS BLOCK
  db.execute("INSERT INTO sjisext_to_unicode VALUES(#{0x8D}, #{0x258A})") # LEFT THREE QUARTERS BLOCK
  db.execute("INSERT INTO sjisext_to_unicode VALUES(#{0x8E}, #{0x2589})") # LEFT SEVEN EIGHTHS BLOCK
  db.execute("INSERT INTO sjisext_to_unicode VALUES(#{0x9C}, #{0x256D})") # BOX DRAWINGS LIGHT ARC DOWN AND RIGHT
  db.execute("INSERT INTO sjisext_to_unicode VALUES(#{0x9D}, #{0x256E})") # BOX DRAWINGS LIGHT ARC DOWN AND LEFT
  db.execute("INSERT INTO sjisext_to_unicode VALUES(#{0x9E}, #{0x2570})") # BOX DRAWINGS LIGHT ARC UP AND RIGHT
  db.execute("INSERT INTO sjisext_to_unicode VALUES(#{0x9F}, #{0x256F})") # BOX DRAWINGS LIGHT ARC UP AND LEFT
  db.execute("INSERT INTO sjisext_to_unicode VALUES(#{0xE8}, #{0x2660})") # BLACK SPADE SUIT
  db.execute("INSERT INTO sjisext_to_unicode VALUES(#{0xE9}, #{0x2665})") # BLACK HEART SUIT
  db.execute("INSERT INTO sjisext_to_unicode VALUES(#{0xEA}, #{0x2666})") # BLACK DIAMOND SUIT
  db.execute("INSERT INTO sjisext_to_unicode VALUES(#{0xEB}, #{0x2663})") # BLACK CLUB SUIT
  db.execute("INSERT INTO sjisext_to_unicode VALUES(#{0xE4}, #{0x25E2})") # BLACK LOWER RIGHT TRIANGLE
  db.execute("INSERT INTO sjisext_to_unicode VALUES(#{0xE5}, #{0x25E3})") # BLACK LOWER LEFT TRIANGLE
  db.execute("INSERT INTO sjisext_to_unicode VALUES(#{0xE6}, #{0x25E5})") # BLACK UPPER RIGHT TRIANGLE
  db.execute("INSERT INTO sjisext_to_unicode VALUES(#{0xE7}, #{0x25E4})") # BLACK UPPER LEFT TRIANGLE
#  db.execute("INSERT INTO sjisext_to_unicode VALUES(#{0xEC}, #{0xFFED})") # HALFWIDTH BLACK SQUARE
  db.execute("INSERT INTO sjisext_to_unicode VALUES(#{0xED}, #{0xFFEE})") # HALFWIDTH WHITE CIRCLE
  db.execute("INSERT INTO sjisext_to_unicode VALUES(#{0xEE}, #{0x2571})") # BOX DRAWINGS LIGHT DIAGONAL UPPER RIGHT TO LOWER LEFT
  db.execute("INSERT INTO sjisext_to_unicode VALUES(#{0xEF}, #{0x2572})") # BOX DRAWINGS LIGHT DIAGONAL UPPER LEFT TO LOWER RIGHT
  db.execute("INSERT INTO sjisext_to_unicode VALUES(#{0xF0}, #{0x2573})") # BOX DRAWINGS LIGHT DIAGONAL CROSS
end

table = db.execute('SELECT * FROM sjisext_to_unicode ORDER BY sjisext')

puts "#SJIS\tUnicode"
puts table.map {|sjisext, unicode| sprintf("0x%04X\t0x%04X", sjisext, unicode) }.join("\n")
