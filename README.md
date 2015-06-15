osu!Downloader_ruby
===========

##What is it?

osu!の譜面を自動で一括ダウンロードするプログラム。  
やばそうだったら消します。  
phpで作った奴を置き換えるつもりでしたが、apiからだと詳細な検索ができないため、ある条件を満たすものを”すべて”ダウンロードするという仕様になってます。  
検索結果からまとめてダウンロードする奴は、[osu!Downloader](https://github.com/flum1025/osu_Downloader)  
スレッド化してありますが、大量にダウンロードするためすごく時間がかかります。  
元からある譜面はダウンロードしないようにする機能もついてます。

  
動作確認はubuntu14.04 ruby1.9.3とOS X Yosemite ruby2.0.0です。

##How to Use
まず、osuの公式サイトからAPIキーを取得  
次にchromeとか使ってリクエストヘッダーの中身からcookieを抜き出す。  
その二つをosu_downloader.rbに指定し、詳細なダウンロードパラメータを$since, $param, $approvedに指定する。
デフォルトの設定では  
  
&m=3 osu!maniaの譜面の  
&a=1 変換譜面を含めたすべての中の  
$approved = [1] ranked譜面を  
$since = "2013-02-14"  2013-02-14から現在まで追加された  
すべての譜面をダウンロードする設定となっています。  
  
osu.exeと同じフォルダ(厳密にはSongsフォルダの一個上の階層)にexist.rbをいれプロンプトから実行するとexistというファイルができるので、そのファイルをosu_downloader.rbと同じフォルダに入れると元からある譜面はダウンロードしなくなります。  
windows環境にrubyが入ってない場合はSongsフォルダをlinuxに一時的に移すか、[ここ](https://github.com/flum1025/flumtter2#environmental-constructionwindows)をみてwindowsにrubyをインストールしてください。  
実行した後./oszの中に譜面データが格納されているはずです。  
```
> git clone https://github.com/flum1025/osu_Downloader_ruby.git
> cd osu_Downloader_ruby
> ruby osu_downloader.rb

```


質問等ありましたらTwitter:[@flum_](https://twitter.com/flum_)までお願いします。

##License

The MIT License

-------
(c) @2015 flum_
