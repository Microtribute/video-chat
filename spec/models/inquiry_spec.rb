require 'spec_helper'

describe Inquiry do
  DatabaseCleaner.clean

  it "is expired when there's no time left for biding" do
    # Inquiry life time is set to 12 hours (models/inquiry#expired_at)
    @expired_inquiry = FactoryGirl.build(:inquiry, created_at: 2.days.ago)
    @expired_inquiry.expired?.should be_true
  end

  it "returns the third highest bid + 1 as a minimum bid if there are 2 or more bids" do
    @inquiry = FactoryGirl.create(:inquiry)

    [10, 12, 15, 40].each do |amount|
      FactoryGirl.create(:bid, inquiry_id: @inquiry.to_param, amount: amount)
    end

    @inquiry.minimum_bid.should eq(13)
  end

  context "on closing an inquiry", :charging do
    before :each do
      # TODO: Remove somehow the duplication in creating lawyers and their bids
      @inquiry = FactoryGirl.create(:inquiry)

      @stefan = FactoryGirl.create(:lawyer, first_name: "Stefan")
      @tom = FactoryGirl.create(:lawyer, first_name: "Tom")
      @oldos = FactoryGirl.create(:lawyer, first_name: "Oldos")
      @michael = FactoryGirl.create(:lawyer, first_name: "Michael")

      @inquiry.bids.create(lawyer_id: @stefan.to_param, amount: 10)
      @inquiry.bids.create(lawyer_id: @tom.to_param, amount: 20)
      @inquiry.bids.create(lawyer_id: @oldos.to_param, amount: 32)
      @inquiry.bids.create(lawyer_id: @michael.to_param, amount: 8)
    end

    it "returns lawyers of three highest bids in #winners" do
      @inquiry.winners.should include @stefan
      @inquiry.winners.should include @tom
      @inquiry.winners.should include @oldos
      @inquiry.winners.should_not include @michael
    end

    it "doesn't send notification if there are no bids" do
      @inquiry.bids.destroy_all

      expect {
        @inquiry.notify_admin
      }.to_not change(ActionMailer::Base.deliveries, :size)
    end

    it "notifies admin about inquiry closing" do
      expect {
        @inquiry.notify_admin
      }.to change(ActionMailer::Base.deliveries, :size).by(1)

      email = ActionMailer::Base.deliveries.last
      email.to.should include "nikhil.nirmel@gmail.com"
      email.to.should include "info@lawdingo.com"
    end

    it "closes inquiry" do
      expect {
        @inquiry.close
      }.to change(@inquiry, :is_closed).to(true)
    end
  end
end
