require_relative '../posting'
require 'fakeweb'

describe Posting do
  before(:all) do
    @page = File.open('./posting.txt').read
    FakeWeb.register_uri(:get, "http://www.example.com/", :response => @page)
  end

  context "Initialization" do
    describe "scrapes URL and returns correct attributes" do
      before(:all) { @post = Posting.new('http://www.example.com/') }

      it "should have the correct date_posted" do
        # Change to test for DateTime
        @post.date_posted.should eq('2012-10-29')
      end
      it "should have the correct time_posted" do
        # Change to test for DateTime
        @post.time_posted.should eq('2:57PM PDT')
      end
      it "should have the correct title" do
        @post.title.should eq("Vintage Peugeot Road Bike - Great Condition")
      end
      it "has the correct price" do
        @post.price.should eq("$400")
      end
      it "has the correct location" do
        @post.location.should eq('albany / el cerrito')
      end
    end
    it "saves attributes"
  end
end