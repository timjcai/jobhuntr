#  Stage 1: linkedin_scraper: company name
#  get the urls for each search query on linkedin

# Company name logic
# Single word = word
# Double word = double%20word (join together using %20 for any space)

require 'open-uri'
require 'nokogiri'
require 'csv'

def load_csv(filepath)
  ruby_array = []
  CSV.foreach(filepath) do |row|
    ruby_array << row
  end
  ruby_array
end

def url(company_name)
  "https://www.linkedin.com/search/results/companies/?keywords=#{company_name}&origin=SWITCH_SEARCH_VERTICAL&sid=4xI"
end

def linkedin_search_urls(array)
  search_urls = []
  array.each do |sub_array|
    search_urls << url(sub_array.join.downcase.split(' ').join("%20"))
  end
  search_urls
end

# stored_companies = load_csv(filepath)
# p linkedin_search_urls(stored_companies)

# Stage 2 - find the first option that appears
# class = ".app-aware-link.search-nec__hero-kcard-v2-link-wrapper.link-without-hover-state.link-without-visited-state.t-normal.t-black--light"

def company_linkedin_profile(url, html_class)
  html_file = URI.open(url, "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36").read
  p html_doc = Nokogiri::HTML.parse(html_file)
  html_doc.search(html_class).each do |element|
    puts element.attribute("href").value
  end
end

def save_csv(array, filepath)
  CSV.open(filepath, 'wb+') do |csv|
    csv << ['Company Name', 'Linkedin']
    array.each do |element|
      csv << [element]
    end
  end
end

def generate_company_linkedin_urls
  html_class = '.app-aware-link.search-nec__hero-kcard-v2-link-wrapper.link-without-hover-state.link-without-visited-state.t-normal.t-black--light'
  filepath = 'companies_copy.csv'

  stored_companies = load_csv(filepath)
  p array1 = linkedin_search_urls(stored_companies)

  linkedin_urls_final = []
  counter = 0

  array1.each do |url|
    p linkedin_urls_final << [stored_companies[counter].join, company_linkedin_profile(url, html_class)]
    sleep 5
  end
  save_csv(linkedin_urls_final, 'test.csv')
end

# generate_company_linkedin_urls
test_url = "https://www.linkedin.com/search/results/companies/?keywords=google&origin=SWITCH_SEARCH_VERTICAL&sid=4xI"
# html_class = '.app-aware-link.search-nec__hero-kcard-v2-link-wrapper.link-without-hover-state.link-without-visited-state.t-normal.t-black--light'
html_class2 = 'entity-result__content.entity-result__divider.pt3.pb3.t-12.t-black--light'
p company_linkedin_profile(test_url, html_class2)
