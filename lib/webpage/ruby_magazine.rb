require_relative 'web_page_base'
class RubyMagazine < WebPageBase
  URL = 'http://magazine.rubyist.net/'

  class << self
    def sample_magazine_page
      top_page = page_parsed_object(URL)
      magazine_url_list(top_page).sample
    end

    private

    def magazine_url_list(top_page)
      top_page_links = top_page.css('div.main').css('ul li a')
      top_page_links = top_page_links.map do |link|
        {
          url:   URL + link.attribute('href').value.sub('./',''),
          title: link.text
        }
      end
      top_page_links.select{ |link| link[:url].match?(/articles/) }
    end
  end
end
