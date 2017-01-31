require 'HTTParty'
require 'Nokogiri'
require 'JSON'
require 'Pry'
require 'csv'

$titles_array = []

def parse_selected_page (pageURL)
    if (pageURL == 'https://www.reddit.com/r/news/')
        page = HTTParty.get(pageURL)
        parse_page = Nokogiri::HTML(page)
        counter = 0;
        parse_page.css('.content').css('.spacer').css('.sitetable').css('.thing').css('.entry').css('.title').css('.title').map do |title|
            counter += 1
            if (counter % 2 == 0 && counter <= 20)
                temp = title.text
                $titles_array.push(temp)
            end
        end
    end
    if (pageURL == 'https://www.thestar.com/news/world.html')
        page = HTTParty.get(pageURL)
        parse_page = Nokogiri::HTML(page)
        counter = 0;
        parse_page.css('span').css('.story__headline').map do |title|
            counter += 1
            if (counter <= 10)
                temp = title.text
                $titles_array.push(temp)
            end
        end
    end
    if (pageURL == 'http://www.theglobeandmail.com/news/world/')
        page = HTTParty.get(pageURL)
        parse_page = Nokogiri::HTML(page)
        counter = 0;
        parse_page.css('.articleTitle').map do |title|
            counter += 1
            if (counter <= 10)
                temp = title.text
                temp = temp[2, temp.length - 4]
                $titles_array.push(temp)
            end
        end
    end
end

pages_array = []
pages_array.push('https://www.reddit.com/r/news/')
pages_array.push('https://www.thestar.com/news/world.html')
pages_array.push('http://www.theglobeandmail.com/news/world/')

for item in pages_array
    parse_selected_page(item)
end

Pry.start(binding)

