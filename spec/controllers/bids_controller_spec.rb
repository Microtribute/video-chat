require 'spec_helper'

describe BidsController do
  DatabaseCleaner.clean

  context "#create" do
    
    let(:bid) do
      FactoryGirl.build_stubbed(:bid)
    end

    let(:bid_attrs) do
      {"amount" => 10}
    end

    it "send email notification when new bid submitted" do

      bid.stubs(:save_with_payment => true)
      Bid.expects(:new).returns(bid)
      
      expect {
        post :create, bid: bid_attrs
      }.to change(ActionMailer::Base.deliveries, :size).by(1)

      email = ActionMailer::Base.deliveries.last
      email.to.should include "nikhil.nirmel@gmail.com"
      email.subject.should match /Bid ##{bid.id} submitted/
    end
  end
end
