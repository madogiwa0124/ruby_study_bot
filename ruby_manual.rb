require 'open-uri'
require 'nokogiri'

class RubyReferenceManual

  attr_reader :class_list

  RUBY_VERSION = "2.4.0"
  MANUAL_URL = "https://docs.ruby-lang.org/ja/#{RUBY_VERSION}/class/"
  CLASS_LIST = [String, Numeric, Array, Hash, IO]

  def initialize
    @class_list = CLASS_LIST
  end

  def get_class_page(target_class)
    unless @class_list.include?(target_class)
      raise "クラスは#{@class_list.join(',')}のいずれかを指定してください。"
    end
    url = "#{MANUAL_URL}/#{target_class}.html"
    class_page = get_page_parsed_object(url)
    class_page
  end

  def method_list(target_class)
    class_page = get_class_page(target_class)
    methods = class_page.css('dl').css('dd').css('a').map{ |m| m.text }
    # 開始文字が不正なものは除外
    methods = methods.grep(/^([a-z]|%|\*|\+|<|=|\+|\[).*/)
    # [数字を含む文字列]、(数字を含む文字列)が含まれているものは除外
    methods -= methods.grep(/(\(|\[).*\d(\)|\])/)
    # http始まりのものは削除
    methods -= methods.grep(/http.*/)
    # 日本語が含まれるものは削除
    methods -= methods.grep(/[^\x01-\x7E]/)
    # 正規表現で判定出来ないため苦肉の策でbase64は直接削除
    methods.delete('base64')
    methods
  end

  def get_page_parsed_object(url)
    charset = nil    
    html = open(url) do |f|
      charset = f.charset
      f.read
    end
    doc = Nokogiri::HTML.parse(html, nil, charset)
    doc
  end
end
