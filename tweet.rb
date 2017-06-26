require 'date'
require 'twitter'
require 'dotenv/load'

class Tweet

  def initialize
    # 投稿内容の初期化
    @text = ""
    # クライアントの生成
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['CONSUMER_KEY']
      config.consumer_secret     = ENV['CONSUMER_SECRET']
      config.access_token        = ENV['ACCESS_TOKEN']
      config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
    end
  end

  # Tweetの投稿処理呼び出し
  def send_tweet
    create_text
    update
  end

  # ツイート本文の生成
  def create_text
    if DateTime.now.hour == 8
      # AM8:00は、曜日毎のメッセージを投稿
      # 投稿を1時間毎から変更する場合は条件を修正する必要あり
      create_week_text
    else
      # クラス、メソッド、リファレンスマニュアルのページを投稿
      create_class_method_text
    end
  end

  private

  # クラスとメソッド、rubyリファレンスマニュアルへのリンクを生成
  def create_class_method_text
    # 主要クラスを定義
    class_list = [String, Numeric, Array, Hash]
    # 主要クラスから対象となるクラスをランダムに抽出
    target_class = class_list.sample
    # 対象クラスから基底クラスのメソッド以外を抽出
    method = (target_class.instance_methods - Object.instance_methods).sample
    # メソッドへのリンクにしようされているIDを生成
    id = "#I_#{method.to_s.upcase.gsub('?','--3F').('=','--3D')}"
    # 投稿内容の作成
    @text = <<-END
    rubyのメソッド、調べて勉強φ(..)！(ver2.3.0)
    Class  : #{ target_class }
    Method : #{ method }
    Manual : https://docs.ruby-lang.org/ja/2.3.0/class/#{target_class}.html#{id}
    END
  end

  # 曜日毎のメッセージを設定
  def create_week_text
    week = Date.today.wday
    @text = case week
    when 0 then "にっこりにちようび〜、週の終わりまで勉強がんばってえらい！(o・ω・o)"
    when 1 then "げつげつげつようび〜、週初めから勉強頑張ってえらい！(o・ω・o)"
    when 2 then "かっかっかようび〜、やる気も燃え上がるー(｀・ω・´)！"
    when 3 then "すいすいすいようび〜、勉強もすいすい進むよ〜(・ω・ 　⊃ 　)⊃≡"
    when 4 then "もくもくもくようび〜、もくもく勉強だー！φ(..)"
    when 5 then "きんきんきんようび〜、明日から休み、がんばろー(/･ω･)/"
    when 6 then "どっどっどようび〜、どんどん勉強を進めていこーφ(..)"
    end
  end

  # Tweet投稿処理
  def update
    begin 
      @client.update(@text)
    rescue => e
      p e # エラー時はログを出力
    end
  end
end

# ツイートを実行
if __FILE__ == $0
  Tweet.new.send_tweet
end