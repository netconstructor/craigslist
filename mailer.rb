require 'action_mailer'
require './search_controller'

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



  def email_everyone
    users = SearchController::users
    users.each do |user|
      daily_summary_email(user.email,user.body).deliver
    end
  end


  def daily_summary_email(user, body)
    if !valid_email?(user)
      raise 'Invalid email'
    else
      mail  :to         => user,
            :from       => "scrapegoats.dbc@gmail",
            :subject    => "daily craigslist updates",
            :body       => body
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

Mailer.email_everyone