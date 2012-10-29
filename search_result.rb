require 'rubygems'
require 'nokogiri'
require 'open-uri'


class SearchResult
  attr_reader :url, :time_scraped, :post_urls, :query

  def initialize(url)
    @url = url
    @time_scraped = Time.now
    @post_urls = []
  end

  def query
    @url.gsub(/.+query=(.+)&srchType.+/){
      $1.split("+").join(" ")  }
  end

 def parse_search_result
    page = Nokogiri::HTML(open(url))
    page.css('p[class=row] a').each do |node|
      if node['href'].length > 5
        @post_urls << node['href']
      end
    end
  end

end


































# agent = Mechanize.new
# page = agent.get("http://sfbay.craigslist.org/search/sss?query=used+cars+honda+civic+2006&srchType=A&minAsk=&maxAsk=")
#
# info = []
#
# info << page.search('p').content='row'# .map{ |i| [i[:href], i.text] }
#
# p info

# page.css('//p[@class = "row"]', '//p[@class = "row"]//a').each do |node|
#   puts node.text
#   puts node['href']
# end
# posting_info = []
# page.css('p[class=row]').each do |node|
#   divided = node.text.split("\n")
#   divided = divided.map {|x| x.gsub(/\t/, '')}
#   divided = divided.map { |x| x.strip }
#   divided.reject!{|e| e.length <= 1}.pop
#   posting_info << divided
# end
#