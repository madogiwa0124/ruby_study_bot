require_relative 'tweet'
require 'dotenv/load'
require 'date'

# ツイートを実行
if __FILE__ == $0
  Tweet.new.send_tweet
end
