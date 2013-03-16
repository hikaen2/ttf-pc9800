#!/usr/bin/ruby
#
# fontrom2bdf.rb
# This file is part of TTF PC-9800.
#

def to_bdf(bin)
  def index_to_jis(i)
    (((i / 96 + 1 + 0x20) << 8) + (i - (i / 96) * 96 + 0x20))
  end

  def integers_to_bdf(jis, integers)
    integers = integers.select.with_index {|n,i| i%2==0} if (0x2920..0x2b7f).include?(jis)

    # integers.length is 16 or 32
    char = ''
    char << "STARTCHAR (for_rename)\n"
    char << "ENCODING #{jis}\n"
    char << "SWIDTH #{integers.length*32} 0\n"    # 512 or 1024
    char << "DWIDTH #{integers.length/2} 0\n"     # 8 or 16
    char << "BBX #{integers.length/2} 16 0 -2\n"  # 8 or 16
    char << "BITMAP\n"
    char << integers.pack('C*').unpack('H*')[0].upcase.gsub(/[0-9A-Fa-f]{#{integers.length/8}}/, "\\0\n")
    char << "ENDCHAR\n"
  end


  bin = bin.ljust(288768, 255.chr)  # 288768 = 8*256 + 16*256 + 32*8832

  ((0.. 255).map {|i| [i,               bin[0x0800+i*16, 16].each_byte.to_a] } +
   (0..8831).map {|i| [index_to_jis(i), bin[0x1800+i*32, 16].each_byte.zip(bin[0x1800+i*32+16, 16].each_byte).flatten] }).
    reject {|jis, integers| integers.all? {|byte| byte == 0 } }.
    map {|jis, integers| integers_to_bdf(jis, integers) }
end


if ARGV.length != 1
  puts 'Usage: fontrom2hex.rb FONT.ROM'
  exit 1
end

print <<EOS
STARTFONT 2.1
FONT -FontForge-PC9800-Medium-R-Normal--16-150-75-75-C-160-JISX0208.1978-0
SIZE 16 75 75
FONTBOUNDINGBOX 16 16 0 -2
STARTPROPERTIES 18
FOUNDRY "FontForge"
FAMILY_NAME "PC9800"
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
FONT_ASCENT 14
FONT_DESCENT 2
DEFAULT_CHAR 8481
FONTNAME_REGISTRY ""
ENDPROPERTIES
CHARS 6879
EOS

print to_bdf(File.open(ARGV[0], 'rb').read).join()

puts 'ENDFONT'
