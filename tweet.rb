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
    tweet = create_text
    update(tweet)
  end

  # ツイート本文の生成
  def create_text
    # 主要クラスを定義
    class_list = [String, Integer, Array, Hash]
    # 主要クラスから対象となるクラスをランダムに抽出
    target_class = class_list.sample
    # 対象クラスから基底クラスのメソッド以外を抽出
    method = target_class.instance_methods - Object.instance_methods
    # 投稿内容の作成
    @text = <<-END
      rubyのメソッド、調べて勉強φ(..)！(ver2.3.0)
      Class  : #{ target_class }
      Method : #{ method.sample }
      Manual : https://docs.ruby-lang.org/ja/2.3.0/class/#{target_class}.html
    END
  end

  private

  # Tweet投稿処理
  def update(tweet)
    begin 
      @client.update(tweet)
    rescue => e
      p e # エラー時はログを出力
    end
  end
end

# ツイートを実行
if __FILE__ == $0
  Tweet.new.send_tweet
end