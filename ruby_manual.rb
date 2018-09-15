class RubyReferenceManual
  require 'open-uri'
  require 'nokogiri'

  RUBY_VERSION = "2.5.0"
  MANUAL_URL = "https://docs.ruby-lang.org/ja/#{RUBY_VERSION}/class/"
  CLASS_LIST = [String, Numeric, Array, Hash, IO]

  class << self
    def sample_target
      target_class = CLASS_LIST.sample
      method = method_list(target_class).sample
      id = "#I_#{url_encode_text(method.to_s.upcase)}"
      {
        class:  target_class,
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

    def page_parsed_object(url)
      charset = nil
      html = open(url) do |f|
        charset = f.charset
        f.read
      end
      Nokogiri::HTML.parse(html, nil, charset)
    end

    def url_encode_text(text)
      text
      .gsub('?','--3F')
      .gsub('=','--3D')
      .gsub('<','--3C')
      .gsub('>','--3E')
      .gsub('!','--21')
      .gsub('%','--25')
      .gsub('@','--40')
      .gsub('[','--5b')
      .gsub(']','--5d')
      .gsub('~','--7e')
      .gsub('*','--2a')
      .gsub('+','--2b')
    end
  end
end
