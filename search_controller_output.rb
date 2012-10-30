

def summary_content
  #some loop over search results
  puts "Daily summary email #{@search_query}"
  puts "#{@time_scraped}"
  puts "Title\tPrice\tLocation\tLink"
    #some loop over postings
    puts "#{@postings.title}"
    print "#{@postings.price}" + "\t"
    print "#{@postings.location}" + "\t"
    print "#{@postings.links}" + "\t"
    puts
    #end posting def loop
  #end search result loop
end