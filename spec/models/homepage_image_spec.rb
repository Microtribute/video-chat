require 'spec_helper'

describe HomepageImage do
  DatabaseCleaner.clean
  specify { should belong_to(:lawyer) }
  subject { FactoryGirl.create(:homepage_image) }

  describe "validation" do
    it "should be valid" do
      subject.should be_valid
    end
  end
end
  