require 'simplecov'
SimpleCov.start
require '../search_result.rb'
require 'fakeweb'

describe SearchResult do
  before :each do
    #Time cannot be stubbed in a before(:each)--it's a bug in RSpec
    time = Time.new('2012', month=12, day=30, hour=12, min=30, sec=0)
    Time.stub(:now).and_return(time)
    url = "http://sfbay.craigslist.org/search/sss?query=used+cars+honda+civic+2006&srchType=A&minAsk=&maxAsk="
    page = "./query_page.txt"
    FakeWeb.register_uri(:get, url, :response => page)
    @search = SearchResult.new(url)
  end


  context "#initialize" do
    it "should initialize with the url" do
      @search.url.should eq("http://sfbay.craigslist.org/search/sss?query=used+cars+honda+civic+2006&srchType=A&minAsk=&maxAsk=")
    end

    it "should initialize with time scraped" do
      @search.time_scraped.should eq("2012-12-30 12:30:00")
    end
  end

  context "#query" do
    it "should parse url and return the search query" do
      @search.search_query.should eq "used cars honda civic 2006"
    end
  end

  context "#post_objects" do
    it "should create an array of post objects" do
      # @search.parse_search_result
      # @search.create_postings
      @search.postings.first.should be_an_instance_of(Posting)
    end
  end


end