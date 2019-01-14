require 'spec_helper'

describe Bid do
  DatabaseCleaner.clean

  context "on charging a bid" do
    
    it "returns Stripe::Charge object with paid: true: if 
      payment was successful", :integration do

      bid = FactoryGirl.build_stubbed(:bid, 
        :lawyer => FactoryGirl.build_stubbed(:lawyer,
          stripe_customer_token: "cus_PqhSJctocrjC3B"
        )
      )
      bid.charge.should be_kind_of Stripe::Charge
      bid.charge.paid.should be_true
    end
  end
end
