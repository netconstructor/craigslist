require 'nokogiri'
require 'open-uri'

class Posting
  attr_reader :date_posted, :title, :price, :location, :url, :time_posted
  def initialize(url)
    @url           = url
    @scrape_result = scrape(url)
    @title         = scrape_title
    @date_posted   = scrape_date_posted
    @time_posted   = scrape_time_posted
    @price         = scrape_price
    @location      = scrape_location
  end

  private
  def scrape(url)
    Nokogiri::HTML(open(url))
  end

  def scrape_title
    result = @scrape_result.css('title').text
  end

  def scrape_price
    @scrape_result.css('h2').text[/\$\d+/] || 'none'
  end

  def scrape_date_posted
    date_posted_messy = date_and_time_unformatted[0]
    date_posted_messy[/\d{4}[-]\d{2}[-]\d{2}/] ##YYYY-MM-DD
  end

  def scrape_time_posted
    time_posted_messy = date_and_time_unformatted[1]
    time_posted_messy.strip
  end

  def scrape_location
    result = @scrape_result.css('h2').text.gsub(title, "")
    result = result.match(/\(.+\)/) || 'none'
    result[0].gsub(/[\(\)]/,'')
  end

  def date_and_time_unformatted
    @scrape_result.css('span.postingdate').text.split(',')
  end
end