require_relative 'tweet.rb'

# クライアントの生成
tweet_bot = Tweet.new

# Class名からマニュアルページのリンクテキストを生成
def create_class_reply_text(content)
  url = case content
  when CLASS_LIST[0].to_s then MANUAL_URL + "#{CLASS_LIST[0].to_s}.html"
  when CLASS_LIST[1].to_s then MANUAL_URL + "#{CLASS_LIST[1].to_s}.html"
  when CLASS_LIST[2].to_s then MANUAL_URL + "#{CLASS_LIST[2].to_s}.html"
  when CLASS_LIST[3].to_s then MANUAL_URL + "#{CLASS_LIST[3].to_s}.html"
  end
  text = <<-END
  「#{content}」ですね！(o・ω・o)
  マニュアルのページはこちらです！φ(..)
  #{url}
  END
end

begin 
  # タイムラインの取得
  tweet_bot.timeline.userstream do |status|
    # タイムラインの各値の取得
    twitter_id = status.user.screen_name
    user_name  = status.user.name
    content    = status.text
    status_id  = status.id
    # RTの場合はリプライしない
    if !content.index("RT")
      # 反応するのは、自分自身へのreplyのみ
      if content =~ /^@ruby_study_bot\s*/
        # contentからアカウントとスペース部分を削除
        content = content.gsub("@ruby_study_bot","").gsub(" ","")
        # 定義したクラス名に一致する場合
        if CLASS_LIST.map{ |c| c.to_s }.index(content)
          # reply用のテキストを生成
          text = create_class_reply_text(content)
        else
          text = "すいません、わかりません。。。"
        end
        # reply処理の呼び出し
        tweet_bot.reply(text, twitter_id, status_id)
      end
    end
  end

rescue => em
  puts Time.now
  p em
  retry

rescue Interrupt
  exit 1
end