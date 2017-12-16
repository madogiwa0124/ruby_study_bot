require_relative 'tweet.rb'
require_relative 'ruby_manual.rb'

# クライアントの生成
tweet_bot = Tweet.new

# Class名からマニュアルページのリンクテキストを生成
def create_class_reply_text(target_class)
  url = get_manual_url(target_class)
  if url
    text = <<-END
    「#{target_class}」ですね！(o・ω・o)
    マニュアルのページはこちらです！φ(..)
    #{url}
    END
  else
    text = "すいません、わかりません。。。"
  end
  text
end

def get_manual_url(target_class)
  class_list = RubyReferenceManual.new.class_list
  url = case target_class
  when class_list[1].to_s then RubyReferenceManual::MANUAL_URL + "#{class_list[1].to_s}.html"
  when class_list[2].to_s then RubyReferenceManual::MANUAL_URL + "#{class_list[2].to_s}.html"
  when class_list[3].to_s then RubyReferenceManual::MANUAL_URL + "#{class_list[3].to_s}.html"
  when class_list[4].to_s then RubyReferenceManual::MANUAL_URL + "#{class_list[4].to_s}.html"
  else nil 
  end
  url
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
        text = create_class_reply_text(content)
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