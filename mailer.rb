require 'action_mailer'

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
   :address   => "smtp.gmail.com",
   :port      => 587,
   #:domain    => "domain.com.ar",
   :authentication => :plain,
   :user_name      => "scrapegoats.dbc@gmail.com",
   :password       => "scrapegoats4",
   :enable_starttls_auto => true
  }

class Mailer < ActionMailer::Base

  def daily_summary_email(user='lreadewinner@gmail.com', body='summary_email.txt')
    if !valid_email?(user)
      raise 'Invalid email'
    else
      mail  :to         => user,
            :from       => "scrapegoats.dbc@gmail",
            :subject    => "daily craigslist updates",
            :body       => File.read(body)
    end
  end

  private
  def valid_email?(user)
    user['@'] == '@'
  end

end

#search = SearchController.new(user) #=> [user, summary email file for the user]

# user = search[0]
# body = search[1]

#Mailer.daily_summary_email(user, body).deliver