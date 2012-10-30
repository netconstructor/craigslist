require 'sqlite3'

module DBSaver
  extend self

  def save(object)
    open_database
    case object
    when SearchResult
      save_search_result(object)
      save_postings(object)
    end
  end


  private
  def open_database
    @db = SQLite3::Database.new('./craigslist.db')
  end

  def save_search_result(search_result)
    @db.execute("INSERT INTO search_results (search_query, search_url, scraped_at, created_at, updated_at)
                VALUES (?, ?, ?, DATETIME('now'),DATETIME('now'))", search_result_attributes(search_result))
  end

  def save_postings(search_result)
    search_result.postings.each do |posting|
      save_posting(posting)
    end
  end

  def save_posting(posting)
    @db.execute(
      "INSERT INTO postings (title, date_posted, price, location, url, search_result_id,created_at,updated_at)
      VALUES (?, ?, ?, ?, ?, ?, DATETIME('now'), DATETIME('now'))", posting_attributes(posting))
  end

  def search_result_attributes(search_result)
    search_query = search_result.search_query
    search_url = search_result.url
    scraped_at = search_result.time_scraped
    [search_query, search_url, scraped_at]
  end

  def posting_attributes(posting)
    title = posting.title
    date_posted = posting.date_posted
    price = posting.price
    location = posting.location
    url = posting.url
    [title, date_posted, price, location, url, search_result_id]
  end

  def search_result_id
    @search_result_id ||= @db.execute("select last_insert_rowid();").first.first
  end
end

