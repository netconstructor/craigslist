#!/Users/apprentice/.rvm/rubies/ruby-1.9.3-p194/bin/ruby

require './dbsaver'
require './search_result'

email = ARGV[0]
DBSaver::new_user(email)

url = ARGV[1]
SearchResult.new(url, email).save