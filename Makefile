#
# Makefile
# This file is part of TTF PC-9800.
#

all: bdf ttf

ttf:
	bdfresize -b 1 -f 4 < compiled/pc-9800.bdf > compiled/pc-9800-x4.bdf
	rm -rf compiled/svg
	mkdir compiled/svg
	ruby src/bdf2pbm.rb compiled/pc-9800-x4.bdf compiled/svg
	rm compiled/pc-9800-x4.bdf
	potrace -s -z white -a -1 compiled/svg/*.pbm
	rm compiled/svg/*.pbm
	fontforge -script src/createttf.pe `date '+%Y.%m.%d'`
	rm -rf compiled/svg

bdf:
	-mkdir compiled
	ruby src/fontrom2bdf.rb data/FONT.ROM > compiled/fontrom.bdf
	ruby src/bdfremap.rb compiled/fontrom.bdf data/EXT.TXT > compiled/fontrom-unicode.bdf
	ruby src/bdfremap.rb data/shnmk16.bdf data/CP932.TXT > compiled/shnmk16-unicode.bdf
	ruby src/bdfremap.rb data/shnm8x16r.bdf data/JIS0201.TXT > compiled/shnm8x16r-unicode.bdf
	ruby src/bdfmerge.rb data/shnm8x16a.bdf compiled/shnm8x16r-unicode.bdf compiled/shnmk16-unicode.bdf compiled/fontrom-unicode.bdf > compiled/pc-9800.bdf
	rm compiled/fontrom.bdf
	rm compiled/fontrom-unicode.bdf
	rm compiled/shnmk16-unicode.bdf
	rm compiled/shnm8x16r-unicode.bdf
	sed -i 's/CHARSET_REGISTRY .*/CHARSET_REGISTRY "ISO10646"/' compiled/pc-9800.bdf
	sed -i "s/STARTCHAR .*/STARTCHAR (for_rename)/" compiled/pc-9800.bdf
	sed -i "s/SWIDTH 480 0/SWIDTH 512 0/" compiled/pc-9800.bdf
	sed -i "s/SWIDTH 960 0/SWIDTH 1024 0/" compiled/pc-9800.bdf

map:
	ruby src/createmap.rb data/Uni2JIS data/CP932.TXT > data/EXT.TXT

clean:
	-rm compiled/fontrom.bdf
	-rm compiled/fontrom-unicode.bdf
	-rm compiled/shnmk16-unicode.bdf
	-rm compiled/shnm8x16r-unicode.bdf
	-rm compiled/pc-9800-x4.bdf
	-rm -rf compiled/svg

distclean:
	-rm -rf compiled

.PHONY: all ttf bdf map clean distclean
