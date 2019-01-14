require 'spec_helper'

describe Search do
	DatabaseCleaner.clean
  	specify { should belong_to(:user) }
  	subject { FactoryGirl.create(:search) }

	describe "validation" do
		it "should be valid" do
			subject.should be_valid
		end
	end
end
