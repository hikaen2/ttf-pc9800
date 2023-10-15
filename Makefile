all: bdf regular bold

regular:
	bdfresize -b 1 -f 4 < dist/pc-9800-regular.bdf > dist/pc-9800-regular-x4.bdf
	rm -rf dist/svg
	mkdir -p dist/svg
	bin/bdf2pbm dist/pc-9800-regular-x4.bdf dist/svg
	rm dist/pc-9800-regular-x4.bdf
	potrace -s -zwhite -a0 dist/svg/*.pbm
	rm dist/svg/*.pbm
	fontforge -script data/createttf-regular.pe `date '+%Y.%m.%d'`
	rm -rf dist/svg

bold:
	bdfresize -b 1 -f 4 < dist/pc-9800-bold.bdf > dist/pc-9800-bold-x4.bdf
	rm -rf dist/svg
	mkdir -p dist/svg
	bin/bdf2pbm dist/pc-9800-bold-x4.bdf dist/svg
	rm dist/pc-9800-bold-x4.bdf
	potrace -s -zwhite -a0 dist/svg/*.pbm
	rm dist/svg/*.pbm
	fontforge -script data/createttf-bold.pe `date '+%Y.%m.%d'`
	rm -rf dist/svg

bdf:
	mkdir -p dist
	bin/fontrom2bdf data/FONT.ROM > dist/fontrom.bdf
	bin/bdfremap dist/fontrom.bdf   data/EXT.TXT       > dist/fontrom-unicode.bdf
	bin/bdfremap data/shnmk16.bdf   data/CP932.JIS.TXT > dist/shnmk16-unicode.bdf
# 	bin/bdfremap data/shnm8x16r.bdf data/JIS0201.TXT   > dist/shnm8x16r-unicode.bdf
# 	bin/bdfmerge data/shnm8x16a.bdf dist/shnm8x16r-unicode.bdf dist/shnmk16-unicode.bdf dist/fontrom-unicode.bdf > dist/pc-9800-regular.bdf
	bin/bdfmerge dist/shnmk16-unicode.bdf dist/fontrom-unicode.bdf > dist/pc-9800-regular.bdf
	rm dist/fontrom.bdf
	rm dist/fontrom-unicode.bdf
	rm dist/shnmk16-unicode.bdf
# 	rm dist/shnm8x16r-unicode.bdf
	sed -i 's/CHARSET_REGISTRY .*/CHARSET_REGISTRY "ISO10646"/' dist/pc-9800-regular.bdf
	sed -i 's/STARTCHAR .*/STARTCHAR (for_rename)/'             dist/pc-9800-regular.bdf
	sed -i 's/SWIDTH 480 0/SWIDTH 512 0/'                       dist/pc-9800-regular.bdf
	sed -i 's/SWIDTH 960 0/SWIDTH 1024 0/'                      dist/pc-9800-regular.bdf
	perl bin/mkbold -l -R dist/pc-9800-regular.bdf > dist/pc-9800-bold.bdf

map:
	bin/sjis2jis   < data/CP932.TXT > data/CP932.JIS.TXT
	bin/createmap data/JIS2Uni data/CP932.JIS.TXT > data/EXT.TXT

dump:
	mkdir -p dist
	bin/fontromdump < data/FONT.ROM > dist/dump.png
	bin/createhtml  < data/EXT.TXT  > dist/dump.html

clean:
	-rm dist/fontrom.bdf
	-rm dist/fontrom-unicode.bdf
	-rm dist/shnmk16-unicode.bdf
	-rm dist/shnm8x16r-unicode.bdf
	-rm dist/pc-9800-x4.bdf
	-rm -rf dist/svg

distclean:
	-rm -rf dist

.PHONY: all regular bold bdf map clean distclean
