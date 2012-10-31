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

  def postings_formatted(email,query) #query is coming in as a Struct object
    postings = ""
    DBSaver.query_postings(email,query.title).each do |posting|
      postings << "%s\nPrice: %s \tLocation: %s \n %s\n\n" % [posting.title, posting.price, posting.location, posting.url]
    end
    postings
  end


end

