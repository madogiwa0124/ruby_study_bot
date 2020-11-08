require 'minitest/autorun'
require 'timecop'
require_relative '../lib/tweet.rb'

class TweetTest < Minitest::Test
  def test_ruby_manual_text
    Timecop.travel(Time.new(2018, 9, 15, 9))
    assert Tweet.new.text.match?(/rubyのメソッド/)
  end

  def test_ruby_magazine_text
    Timecop.travel(Time.new(2018, 9, 15, 15))
    assert Tweet.new.text.match?(/本日のるびま/)
  end

  def test_week_text
    Timecop.travel(Time.new(2018, 9, 15, 7))
    assert Tweet.new.text.match?(/どっどっどようび/)
  end
end
