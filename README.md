Craigslist Scraper Challenge
==========
Welcome to your first Group Project! In this project, you will be building a Ruby application to improve the Craigslist search experience.

Wouldn't it be great if you could send search requests to Craigslist from your command line and receive a daily email with a summary of the most relevant postings? Wish no more–let's build it!

##Core Features
Send a search request to Craigslist from your command line
Scrape the search results page and save the data in a local database
Send an email to the user with a summary of the most attractive postings
You will be TDD-ing your way through each objective. You will be making use of mocks and stubs, especially when it comes to sending HTTP requests and email. Strive for 100% coverage.

Think about strategy and project design. With a team of four (i.e. two pairs), it is important that everyone have a clear picture of what they need to be doing and how their work will integrate with the other pair. Agree on your interface and schema. Identify goals and aims for each pair before you dive in.

When pairing, try out ping-pong programming: one person writes a few specs, the other makes them pass and then writes the next set of specs, then you switch again, and so on.

##Learning Goals
Send HTTP requests from Ruby
Parse HTML using Nokogiri
Build a database to store history
Send emails using IMAP
Tools
Nokogiri
SQLite3 and SQLite3-ruby gem
Mail gem or ActionMailer
Resources
Blog post on using ActionMailer outside of Rails
RailsCasts: Screen Scraping with NokoGiri