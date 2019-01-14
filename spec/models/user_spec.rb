require 'spec_helper'

describe User do
  subject { FactoryGirl.create(:user) }
  specify { should belong_to(:school) }
  specify { should have_many(:offerings) }
  specify { should have_many(:questions) }
  specify { should validate_presence_of(:first_name) }
  specify { should validate_presence_of(:last_name) }
  specify { should validate_presence_of(:email) }
  specify { should validate_presence_of(:user_type) }
  specify { should validate_presence_of(:rate) }
  specify { should validate_uniqueness_of(:email) }
  specify { should_not allow_value("asdfghj").for(:phone) }
  specify { should be_valid }

  subject { FactoryGirl.create(:user) }

  describe "timezone" do

    it "timezone_utc_offset" do
      subject.time_zone = 'Lima'
      subject.timezone_utc_offset.should == -5
    end

    it "timezone_abbreviation" do
      subject.time_zone = 'Atlantic Time (Canada)'
      subject.timezone_abbreviation.should == "ADT"
    end

  end   

  describe "methods" do

    it "#normalize_name" do
      subject.first_name = "\n rick "
      subject.last_name = "\n geiger "
      subject.save
      subject.first_name.should eql('Rick')
      subject.last_name.should eql('Geiger')

      subject.first_name = "\n JEFFREY    "
      subject.last_name = " BRAXTON \n "
      subject.save
      subject.first_name.should eql('Jeffrey')
      subject.last_name.should eql('Braxton')

      subject.first_name = 'tESt   '
      subject.save
      subject.first_name.should eql('Test')

    end

  end

end
