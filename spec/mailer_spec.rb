#scrapegoats.dbc@gmail.com
#password: scrapegoats4
require_relative '../mailer'
require 'action_mailer'

describe Mailer do
  context "initialization" do
    it "is an ActionMailer object" do
      Mailer.ancestors.should include ActionMailer::Base
    end
  end

  context "sending emails" do
    describe "#daily_summary_email" do
      it "raises error if email is invalid" do
        #Mailer.should_receive(:daily_summary_email).with('asdasfd').and raise_error
        #Mailer.daily_summary_email('asdasfd')
        # Mailer.daily_summary_email('asdasfd').should raise_error(RuntimeError ["Invalid email"])
        expect {Mailer.daily_summary_email('asdflksd')}.to raise_error
      end
      it "sends an email" do
      end
    end
  end

end
