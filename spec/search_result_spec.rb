require 'simplecov'
SimpleCov.start
require '../search_result.rb'
require 'fakeweb'

describe SearchResult do
  before :each do
    url = "http://sfbay.craigslist.org/search/sss?query=used+cars+honda+civic+2006&srchType=A&minAsk=&maxAsk="
    page = "./query_page.txt"
    FakeWeb.register_uri(:get, url, :response => page)
    @search = SearchResult.new(url)
  end


  context "#initialize" do
    it "should initialize with the url" do
      @search.url.should eq("http://sfbay.craigslist.org/search/sss?query=used+cars+honda+civic+2006&srchType=A&minAsk=&maxAsk=")
    end

    it "should initialize time scraped" do
      @search.time_scraped.should be_an_instance_of(Time)
    end
  end

  context "#query" do
    it "should parse url and return the search query" do
      @search.query.should eq "used cars honda civic 2006"
    end
  end

  context "#parse_search_result" do
    it "should populate the post_urls array with urls" do
      expect {@search.parse_search_result}.to change {@search.post_urls.length}.from(0).to(3)
    end
  end


end