#!/usr/bin/ruby
#
# fontrom2bdf.rb
# This file is part of TTF PC-9800.
#

def to_bdf(bin)
  def index_to_jis(i)
    (((i / 96 + 1 + 0x20) << 8) + (i - (i / 96) * 96 + 0x20))
  end

  def integers_to_bdf(code, integers)
    # integers.length is 16 or 32
    char = ''
    char << "STARTCHAR (for_rename)\n"
    char << "ENCODING #{code}\n"
    char << "SWIDTH #{integers.length*32} 0\n"    # 512 or 1024
    char << "DWIDTH #{integers.length/2} 0\n"     # 8 or 16
    char << "BBX #{integers.length/2} 16 0 -2\n"  # 8 or 16
    char << "BITMAP\n"
    char << integers.pack('C*').unpack('H*')[0].upcase.gsub(/[0-9A-Fa-f]{#{integers.length/8}}/, "\\0\n")
    char << "ENDCHAR\n"
  end

  ((0.. 255).map {|i| [i,               bin[0x0800+i*16, 16].each_byte.to_a] } +
   (0..8831).map {|i| [index_to_jis(i), bin[0x1800+i*32, 16].each_byte.zip(bin[0x1800+i*32+16, 16].each_byte).flatten] }).
    select {|code, integers| integers.any? {|byte| byte > 0 } }.
    map {|code, integers| integers_to_bdf(code, integers) }
end


if ARGV.length != 1
  puts 'Usage: fontrom2hex.rb FONT.ROM'
  exit 1
end

print <<EOS
STARTFONT 2.1
FONT -Shinonome-Gothic-Medium-R-Normal--16-150-75-75-C-160-JISX0208.1990-0
SIZE 16 75 75
FONTBOUNDINGBOX 16 16 0 -2
STARTPROPERTIES 20
FONT_ASCENT 14
FONT_DESCENT 2
DEFAULT_CHAR 8481
COPYRIGHT "Public Domain"
FONTNAME_REGISTRY ""
FOUNDRY "Shinonome"
FAMILY_NAME "Gothic"
WEIGHT_NAME "Medium"
SLANT "R"
SETWIDTH_NAME "Normal"
ADD_STYLE_NAME ""
PIXEL_SIZE 16
POINT_SIZE 150
RESOLUTION_X 75
RESOLUTION_Y 75
SPACING "C"
AVERAGE_WIDTH 160
CHARSET_REGISTRY "JISX0208.1978"
CHARSET_ENCODING "0"
ENDPROPERTIES
CHARS 6879
EOS

print to_bdf(File.open(ARGV[0], "rb").read).join()

puts 'ENDFONT'
