require_relative 'web_page_base'
require 'csv'
require 'net/http'
require 'benchmark'

class RubyReferenceManual < WebPageBase
  RUBY_VERSION = "2.6.0"
  MANUAL_URL = "https://docs.ruby-lang.org/ja/#{RUBY_VERSION}/class/"
  CLASS_LIST = [
    String,
    Numeric,
    Array,
    Hash,
    IO,
    Enumerable,
    Proc,
    Kernel,
    DateTime,
    Date,
    Range,
    CSV,
    Benchmark,
    Kernel,
    Fiber,
    Thread,
    TracePoint,
    Comparable,
    Process,
    Signal,

  ]

  class << self
    def sample_target
      target_class = CLASS_LIST.sample
      method = method_list(target_class).sample
      id = "#I_#{url_encode_text(method.to_s.upcase)}"
      {
        class: target_class,
        method: method,
        manual: "#{MANUAL_URL}#{target_class}.html#{id}"
      }
    end

    private

    def method_list(target_class)
      class_page = class_page(target_class)
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

    def class_page(target_class)
      unless CLASS_LIST.include?(target_class)
        raise "クラスは#{CLASS_LIST.join(',')}のいずれかを指定してください。"
      end
      url = "#{MANUAL_URL}/#{target_class}.html"
      page_parsed_object(url)
    end
  end
end
