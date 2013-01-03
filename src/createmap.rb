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
  db.execute("INSERT INTO sjisext_to_unicode VALUES(#{0xFC}, #{0x5C})")  # In PC-9800, 0xFC is REVERSE SOLIDUS(U+005C) 
end

table = db.execute('SELECT * FROM sjisext_to_unicode ORDER BY sjisext')

puts "#SJIS\tUnicode"
puts table.map {|sjisext, unicode| sprintf("0x%04X\t0x%04X", sjisext, unicode) }.join("\n")
