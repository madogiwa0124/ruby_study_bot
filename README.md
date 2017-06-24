# ruby_study_bot
Twitterの[@ruby_study_bot](https://twitter.com/ruby_study_bot)のリポジトリです。

# 機能
* TwitterAPIを使って下記を投稿します。
  - rubyのクラス
  - クラスに属するメソッド
  - rubyリファレンスマニュアルの該当ページ
* herokuで運用してます。heroku schedulerを使って1時間に一回つぶやきを投稿してます。

# 今後追加したい機能
* rubyにまつわる知識や雑学を投稿する機能
```
Ruby作者の理念
Rubyをシンプルなものではなく、自然なものにしようとしている。
Rubyの外観はシンプルです。けれど、内側はとても複雑なのです。
それはちょうど私たちの身体と同じようなものです。
https://www.ruby-lang.org/ja/about/
```
* 曜日を判定して、モチベーション上げるような内容を毎日朝に投稿
```
 木曜日：もくもく木曜日ー、もくもくrubyを勉強しましょう！φ(..)
```
* rubyのクラスを聞かれたら、rubyリファレンスマニュアルのページを返すリプライ対応
```
@ruby_study_bot String
@user Stringのマニュアルはこちらです(o・ω・o)
https://docs.ruby-lang.org/ja/2.3.0/class/String.html
```
* はてなブログ等でrubyにまつわる内容が投稿されたらツイートで共有
```
はてなブログに「ruby:Rubocopの使い方と警告について」が投稿されました！
http://madogiwa0124.hatenablog.com/entry/2017/06/22/233036
```