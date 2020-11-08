class Tweet
  require 'twitter'
  require_relative 'webpage/ruby_manual'
  require_relative 'webpage/ruby_magazine'

  def initialize
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
    @client.update(text)
  rescue => e
    p e # エラー時はログを出力
  end

  # ツイート本文の生成
  def text
    # 投稿を1時間毎から変更する場合は条件を修正する必要あり
    case DateTime.now.hour
    # AM7:00は、曜日毎のメッセージを投稿
    when 7 then create_week_text
    # PM15:00は、るびまのバックナンバーを投稿
    when 15 then create_ruby_magazine_text
    # クラス、メソッド、リファレンスマニュアルのページを投稿
    else create_class_method_text
    end
  end

  private

  # るびまのバックナンバーのタイトルとURLを生成
  def create_ruby_magazine_text
    target = RubyMagazine.sample_magazine_page
    <<~END
      本日のるびま(RubyistMagazine)のバックナンバーですφ(..)
      タイトル:#{target[:title]}
      URL:#{target[:url]}
    END
  end

  # クラスとメソッド、rubyリファレンスマニュアルへのリンクを生成
  def create_class_method_text
    target = RubyReferenceManual.sample_target
    <<~END
      rubyのメソッド、調べて勉強φ(..)！(ver#{ RubyReferenceManual::RUBY_VERSION })
      Class  : #{ target[:class] }
      Method : #{ target[:method] }
      Manual :#{ target[:manual] }
    END
  end

  # 曜日毎のメッセージを設定
  def create_week_text
    case Date.today.wday
    when 0 then "にっこりにちようび〜、週の終わりまで勉強がんばってえらい！(o・ω・o)"
    when 1 then "げつげつげつようび〜、週初めから勉強頑張ってえらい！(o・ω・o)"
    when 2 then "かっかっかようび〜、やる気も燃え上がるー(｀・ω・´)！"
    when 3 then "すいすいすいようび〜、勉強もすいすい進むよ〜(・ω・ 　⊃ 　)⊃≡"
    when 4 then "もくもくもくようび〜、もくもく勉強だー！φ(..)"
    when 5 then "きんきんきんようび〜、明日から休み、がんばろー(/･ω･)/"
    when 6 then "どっどっどようび〜、どんどん勉強を進めていこーφ(..)"
    end
  end
end
