class WebPageBase
  require 'open-uri'
  require 'nokogiri'

  class << self
    def page_parsed_object(url)
      charset = nil
      html = URI.open(url) do |f|
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
