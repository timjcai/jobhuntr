require "open-uri"
require "nokogiri"
require "csv"

filepath = "companies.csv"

# saved details
# company_gd_profile = ".employer-short-name"
# company_name = ".d-inline-flex.align-items-center"
# website = ".css-1cnqmgc"

def url(number)
  "https://www.glassdoor.com.au/Reviews/index.htm?overall_rating_low=3.5&page=#{number}&sgoc=1011&occ=Software%20Engineer&filterType=RATING_OVERALL"
end

def scraper(url)
  scraped_array = []
  html_file = URI.open(url, "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36").read
  html_doc = Nokogiri::HTML.parse(html_file)

  html_doc.search("h2").each do |element|
    scraped_array << element.text.strip
  end
  scraped_array
end

def save_csv(array, filepath)
  CSV.open(filepath, "a+") do |csv|
    array.each do |element|
      csv << [element]
    end
  end
end

def initScraper(number, limit)
  while number < limit
    save_csv(scraper(url(number)), "companies.csv")
    sleep 5
    number += 1
  end
end

initScraper(1, 500)

# list_of_urls.each_value do |value|
#   save_csv(scraper(value, title), sku_filepath)
#   sleep 5
# end

# price and title
# def scraper2(url, idclass, title, price)
#   scraped_array = []
#   # entire_collection = []
#   html_file = URI.open(url).read
#   html_doc = Nokogiri::HTML.parse(html_file)

#   p html_doc.search(idclass).each do |element|
#     p item_title = element.search(title).value
#     p item_price = element.search(price).value
#     scraped_array << [item_title, item_price]
#   end
#   scraped_array
# end

# p scraper2(a, card_tile, title_dom, price)

# https://www.glassdoor.com.au/Jobs/Google-Jobs-E9079.htm?filter.countryId=16
