# img_to_mp3 とは？

## 概要
音楽CDをリッピングして生成した.bin と .cue ファイルから、mp3ファイルを生成するスクリプトです。

## 目的
音楽CDをISOファイル（.binファイル）に変換して保存していますが、mp3ファイルにしたいときにマウントしてリッピングが出来ず手間がかかりました。
（いったん、CD-RやCD-RWに書き込んでからmp3にリッピングしている）  
  
この手間を省くために、.bin と .cueファイルからトラック情報を読み込み、.flacや.mp3ファイルを生成するシェルスクリプトをつくりました。

## 使い方
このシェルスクリプトを .bin と .cue ファイルのある場所に置いて、実行します。  
ディレクトリ内の .bin と .cue ファイルを探して、.mp3ファイルに変換します。

***参考例***  
$ chmod +x create_mp3.sh
$ ls
image.bin
image.cue
create.sh

$ ./create_mp3.sh
:  
:  
track01.mp3  
track02.mp3  

...  
track14.mp3  
  
のようにCUEファイルの内容にしたがってmp3ファイルが生成されます。  

## 事前準備
下記のパッケージが必要です  
- shnsplit
- shntool
- cuetools
- flac
- ffmpeg

```
# apt install -y shnsplit shntool cuetools flac ffmpeg
```

## 開発環境
Ubuntu 20.04 LTS  
cuetools/focal,now 1.4.1-0.2 amd64 [installed]  
flac/focal,now 1.3.3-1build1 amd64 [installed]  
libflac8/focal,now 1.3.3-1build1 amd64 [installed,automatic]  
cmus-plugin-ffmpeg/focal,now 2.8.0-2 amd64 [installed,automatic]  
ffmpeg/focal-updates,focal-security,now 7:4.2.4-1ubuntu0.1 amd64 [installed]  
shnsplit mode module 3.0.10
shntool/focal,now 3.0.10-1 amd64 [installed]
