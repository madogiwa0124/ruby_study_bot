class RubyMagazine
  require 'open-uri'
  require 'nokogiri'

  URL = 'http://magazine.rubyist.net/'

  class << self

    def get_magazine_page
      top_page = get_page_parsed_object(URL)
      get_magazine_url_list = get_magazine_url_list(top_page)
      get_magazine_url_list.sample
    end

    private

    def get_magazine_url_list(top_page)
      top_page_links = top_page.css('div.main').css('ul li a')
      top_page_links = top_page_links.map do |link|
        {
          url:   URL + link.attribute('href').value.sub('./',''),
          title: link.text
        }
      end
      top_page_links.select{ |link| link[:url].match?(/articles/) }
    end

    def get_page_parsed_object(url)
      charset = nil
      html = open(url) do |f|
        charset = f.charset
        f.read
      end
      Nokogiri::HTML.parse(html, nil, charset)
    end
  end
end
