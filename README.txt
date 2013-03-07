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
  - ユニコードコンソーシアムの変換表
    http://www.unicode.org/Public/MAPPINGS/
  - 安岡孝一 (Koichi Yasuoka)
    http://kanji.zinbun.kyoto-u.ac.jp/~yasuoka/

ファイルの説明
  - data/FONT.ROM
    ダミーのフォントROMです。PC-98から吸い出したフォントROMのイメージで
    置き換えてください。
  - data/shnm8x16a.bdf
    東雲フォント（Shinonome 16dot font for ISO 8859-1）
    オリジナルファイル：shinonome-0.9.11p1.tar.bz2
  - data/shnm8x16r.bdf
    東雲フォント（Shinonome 16dot font for JISX 0201, 1976）
    オリジナルファイル：shinonome-0.9.11p1.tar.bz2
  - data/shnmk16.bdf
    東雲フォント（Shinonome 16dot font for JISX 0208, 1983/1990）
    オリジナルファイル：shinonome-0.9.11p1.tar.bz2
  - data/CP932.TXT
    ユニコードコンソーシアムの変換表（CP932からUnicode）
    オリジナルファイル：VENDORS/MICSFT/WINDOWS/CP932.TXT
  - data/JIS0201.TXT
    ユニコードコンソーシアムの変換表（JIS X 0201-1976からUnicode）
    オリジナルファイル：OBSOLETE/EASTASIA/JIS/JIS0201.TXT
  - data/Uni2JIS
    安岡孝一さんの変換表（UnicodeからJIS C 6226-1978）
    オリジナルファイル：
    http://kanji.zinbun.kyoto-u.ac.jp/~yasuoka/ftp/CJKtable/Uni2JIS.Z
  - data/EXT.TXT
    PC-98の文字セットからUnicodeへの変換表
