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
    @text = 'sinatraで投稿テスト'
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
