require 'rubygems'
require 'nokogiri'
require 'open-uri'
require_relative 'posting.rb'
require_relative 'dbsaver.rb'


class SearchResult
  attr_reader :url, :time_scraped, :post_urls, :search_query, :postings, :email

  def initialize(url,email)
    @email = email
    @url = url
    @time_scraped = Time.now.strftime("%Y-%m-%d %H:%M:%S") #YYYY-MM-DD HH:MM:SS
    @post_urls = []
    @search_query = search_term
    parse_search_result
    populate_postings
  end

  def search_term
    @url.gsub(/.+query=(.+)&srchType.+/){ $1.split("+").join(" ")  }
  end

  def save
    DBSaver.save(self)
  end

  private
  def populate_postings
    @postings = @post_urls.reduce([]) {|postings,url| postings << Posting.new(url) }
  end

  def parse_search_result
    page = Nokogiri::HTML(open(url))
    page.css('p[class=row] a').each do |node|
      @post_urls << node['href'] if node['href'].length > 5
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