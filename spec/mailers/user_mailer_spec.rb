require 'spec_helper'

describe UserMailer do
  context "#notify_lawyer_application" do
    before :each do
      @brian = FactoryGirl.create(:lawyer, first_name: "Brian", last_name: "Adams", email: "brian.adams@gmail.com")
      @mailer = UserMailer.notify_lawyer_application(@brian)
    end

    it "should display lawyer email address" do
      @mailer.body.should =~ /#{@brian.email}/
    end

    it "should display lawyer full name" do
      @mailer.body.should =~ /#{@brian.full_name}/
    end
  end

  context "#notify_client_signup" do
    before :each do
      @hanna = FactoryGirl.create(:user, first_name: "Hanna", last_name: "Marciniak", email: "hanka@honestplace.com")
      @mailer = UserMailer.notify_client_signup(@hanna)
    end

    it "should display client email address" do
      @mailer.body.should =~ /#{@hanna.email}/
    end

    it "should display client full name" do
      @mailer.body.should =~ /#{@hanna.full_name}/
    end
  end

  context "#session_notification" do
    before :each do
      @conversation = FactoryGirl.create(:conversation, start_date: Time.now, end_date: 20.minutes.from_now, billable_time: 5)
      @mailer = UserMailer.session_notification(@conversation)
    end

    it "should display client email address" do
      @mailer.body.should =~ /#{@conversation.client.email}/
    end

    it "should display lawyer email address" do
      @mailer.body.should =~ /#{@conversation.lawyer.email}/
    end

    it "should display session duration" do
      @mailer.body.should =~ /Duration : 20/
    end
  end
end
