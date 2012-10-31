require 'sqlite3'

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

