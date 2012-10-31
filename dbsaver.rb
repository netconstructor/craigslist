require 'sqlite3'
require './search_result'
require './posting'

Query = Struct.new(:title,:scraped_at)
Post = Struct.new(:title, :price, :location, :url)


module DBSaver
  extend self

  def save(search_result)
    open_database
    case search_result
    when SearchResult
      search_result_exists?(search_result) ? update_search_result_time(search_result) : save_search_result(search_result)
      save_postings(search_result)
    end
  end

  def update_database
    search_result_urls_and_emails.each do |result|
      SearchResult.new(result[0],result[1]).save
    end
  end

  def emails
    open_database
    @db.execute("SELECT email FROM users").flatten
  end

  def user_queries(email)
    open_database
    @db.execute("SELECT search_query, updated_at FROM search_results WHERE user_email='#{email}'").map do |query|
      Query.new(query[0],query[1])
    end
     #=> [["yacht", "2012-10-30 23:57:48"], ["yacht", "2012-10-30 23:57:48"]]
  end


  def query_postings(email,query)
    open_database
    results = []
    @db.execute("SELECT title,price,location,url
    FROM postings
    JOIN search_result_postings
    ON postings.id=search_result_postings.posting_id
    JOIN search_results
    ON search_result_postings.search_result_id=search_results.id
    JOIN users
    ON search_results.user_email=users.email
    WHERE users.email='#{email}' AND search_results.search_query='#{query}' AND postings.created_at > users.emailed_at").each do |posting|
      results << Post.new(posting[0],posting[1],posting[2],posting[3])
    end

    @db.execute("UPDATE users SET emailed_at=DATETIME('now') WHERE email='#{email}'")

    return results
  end

  def new_user(email)
    open_database
    if !user_exists?(email)
      @db.execute("INSERT INTO users (email, created_at, updated_at)
                  VALUES (?,DATETIME('now'),DATETIME('now'))", email)
    end
  end

  def user_exists?(email)
    @db.execute("SELECT * FROM users WHERE email='#{email}'").flatten.length > 0
  end


  private
  def open_database
    @db = SQLite3::Database.new('./craigslist.db')
  end

  def update_search_result_time(search_result)
    @db.execute("UPDATE search_results SET updated_at=DATETIME('now') WHERE search_url='#{search_result.url}'")
  end

  def save_search_result(search_result)
    @db.execute("INSERT INTO search_results (search_query, search_url, created_at, updated_at, user_email)
                VALUES (?, ?, DATETIME('now'),DATETIME('now'), ?)", search_result_attributes(search_result))
  end

  def search_result_urls_and_emails
    open_database
    @db.execute("SELECT search_url, user_email FROM search_results") #=> [[user_email, url], [user_email, url]]
  end


  def save_postings(search_result)
    search_result.postings.each do |posting|
      unless posting_exists?(posting)
        save_posting(posting)  #postings table
        save_search_result_posting(posting, search_result) #join table (many<->many) search_result_postings
      end
    end
  end

  def save_posting(posting)
    @db.execute(
      "INSERT INTO postings (title, date_posted, price, location, url,created_at,updated_at)
      VALUES (?, ?, ?, ?, ?, DATETIME('now'), DATETIME('now'))", posting_attributes(posting))
  end

  def save_search_result_posting(posting, search_result)
    @db.execute(
    "INSERT INTO search_result_postings (posting_id, search_result_id)
    VALUES (?, ?)", posting_id(posting), search_result_id(search_result)
    )
  end

  def posting_id(posting)
    @db.execute(
     "SELECT id FROM postings
      WHERE url='#{posting.url}'").flatten.first
  end

  def posting_exists?(posting)
    @db.execute("SELECT url FROM postings WHERE url='#{posting.url}'").flatten.length > 0
  end

  def search_result_exists?(search_result)
    @db.execute("SELECT id FROM search_results WHERE search_url='#{search_result.url}' AND user_email='#{search_result.email}'").flatten.length > 0
  end

  def search_result_attributes(search_result)
    search_query = search_result.search_query
    search_url   = search_result.url
    email        = search_result.email
    [search_query, search_url, email]
  end

  def posting_attributes(posting)
    title = posting.title
    date_posted = posting.date_posted
    price = posting.price
    location = posting.location
    url = posting.url
    [title, date_posted, price, location, url]
  end

  def search_result_id(search_result)
    @db.execute(
    "SELECT id FROM search_results
     WHERE user_email='#{search_result.email}'
     AND search_url='#{search_result.url}'").flatten.last
  end



end

