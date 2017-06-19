require 'httparty'
require 'nokogiri'
require 'json'
require 'magic_cloud'

class Scraper
    
    $titles_array = []
    $hash = Hash.new(0)
    
    def parse_selected_page (pageURL)
        if (pageURL == 'https://www.reddit.com/r/news/')
            page = HTTParty.get(pageURL)
            parse_page = Nokogiri::HTML(page)
            counter = 0;
            parse_page.css('.content').css('.spacer').css('.sitetable').css('.thing').css('.entry').css('.title').css('.title').map do |title|
                counter += 1
                if (counter % 2 == 0 && counter <= 30)
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
                if (counter <= 15)
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
                if (counter <= 15)
                    temp = title.text
                    temp = temp[2, temp.length - 4]
                    $titles_array.push(temp)
                end
            end
        end
    end
    
    def setup
        $titles_array = []
        $hash = Hash.new(0)
    end
    
    def load
        setup()
        pages_array = []
        pages_array.push('https://www.reddit.com/r/news/')
        pages_array.push('https://www.thestar.com/news/world.html')
        pages_array.push('http://www.theglobeandmail.com/news/world/')
        
        for item in pages_array
            parse_selected_page(item)
        end
        
        for item in $titles_array
            words_array = item.split(' ')
            words_array.each { |single_word| $hash[single_word.downcase] += 1-$hash[single_word.downcase]/5 }
        end
        
        hash_array = $hash.to_a
        
        hash_array.delete_if { |x| x[1] < 2 }
        hash_array.delete_if { |x| "to on of and or a in the his her by who what where when why how with for has that we".include? x[0]}
        
        cloud = MagicCloud::Cloud.new(hash_array, palette: :category20, rotate: :free, scaling: :logarithmic)
        
        img = cloud.draw(500,500)
        
        img.write("#{Rails.root}/app/assets/images/output.jpg")
    end
end
