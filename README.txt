PC-9800 - ビットマップTTFフォント

説明
  このソフトは NEC PC-9800 シリーズのフォントをTTFに変換するソフトです。
  NEC PC-9800 シリーズのフォントROMイメージファイルが必要です。
  Neko Project II の GETBIOS などで、FONT.ROM を作っておいてください。

使い方
  data/FONT.ROM にフォントROMイメージをおいて make してください。

コンパイルに必要なソフトウェア
  - make
  - Ruby
  - FontForge
  - bdfresize
  - Potrace
  - patch
  - sed

アーカイブに同梱されているファイルのオリジナル配付サイト
  - 東雲 ビットマップフォントファミリー
    http://openlab.ring.gr.jp/efont/shinonome/

ファイルの説明
  - FONT.ROM
  - shnm8x16a.bdf
    Shinonome 16dot font for ISO 8859-1
    オリジナルファイル：shinonome-0.9.11p1.tar.bz2
  - shnm8x16r.bdf
    Shinonome 16dot font for JISX 0201, 1976
    オリジナルファイル：shinonome-0.9.11p1.tar.bz2
  - shnmk16.bdf
    Shinonome 16dot font for JISX 0208, 1983/1990
    オリジナルファイル：shinonome-0.9.11p1.tar.bz2
  - data/CP932.TXT
    オリジナルファイル：
    http://www.unicode.org/Public/MAPPINGS/VENDORS/MICSFT/WINDOWS/CP932.TXT
  - data/JIS0201.TXT
    オリジナルファイル：
    http://www.unicode.org/Public/MAPPINGS/OBSOLETE/EASTASIA/JIS/JIS0201.TXT
  - Uni2JIS
    オリジナルファイル：
    http://kanji.zinbun.kyoto-u.ac.jp/~yasuoka/ftp/CJKtable/Uni2JIS.Z
  - data/EXT.TXT

