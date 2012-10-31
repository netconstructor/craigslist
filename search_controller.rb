require './dbsaver'

module SearchController
  extend self
  User = Struct.new(:email,:body)

  def users
    DBSaver.update_database

    users = []
    DBSaver.emails.each do |email|
      users << User.new(email,body(email))
    end

    users
  end

#body =
=begin
  Search query1: Scraped @ Time scraped

    Posting 1(title): Price, Location, URL
    Posting 2(title): Price, Location, URL
  ....

  Search query2: Scraped @ Time scraped

    Posting 1(title): Price, Location, URL
    Posting 2(title): Price, Location, URL
  ....

=end

  def body(email)
    body = ""
    user_queries(email).each do |query|
      body << "#{query.title}: Scraped at #{query.scraped_at}\n" << postings_formatted(email,query)
    end
    body
  end

  def user_queries(email)
    # [query1, query2, query3]
    DBSaver.user_queries(email)
  end

  def postings_formatted(email,query)
    postings = ""
    DBSaver.query_postings(email,query.title).each do |posting|
      postings << "#{posting.title}: #{posting.price}, #{posting.location}, #{posting.url}\n"
    end
    postings
  end


end

