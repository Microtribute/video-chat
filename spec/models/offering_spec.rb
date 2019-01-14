require 'spec_helper'

describe Offering do
  DatabaseCleaner.clean
  specify { should belong_to(:practice_area) }
  specify { should belong_to(:user) }
  subject { FactoryGirl.create(:offering) }

  describe "validation" do
    it "should be valid" do
      subject.should be_valid
    end
  end

  describe "search", :integration => true do

    describe "search by state" do

      it "should find by state" do
        FactoryGirl.create(:state, :name => 'Arizona')
        state = FactoryGirl.create(:state, :name => 'Pennsylvania')
        subject.user.states<< state
        subject.user.states.count.should == 1
        subject.get_state_name.should == state.name
        subject.get_state_ids.should == subject.user.state_ids
        assert subject.reindex!
        search = Offering.search do
          with(:state_ids, [state.id])
        end
        search.total.should == 1
      end

    end

    describe "search by practice_area" do

      it "should find by practice_area" do
        FactoryGirl.create(:practice_area, :name => 'Bankruptcy')
        FactoryGirl.create(:practice_area, :name => 'Business and Startups')
        practice_area = FactoryGirl.create(:practice_area, :name => 'Employment')
        offering = FactoryGirl.create(
          :offering, 
          :practice_area => practice_area
        )
        # reindex our offering
        offering.reindex!

        search = Offering.search do
          with :practice_area_id, practice_area.id
        end
        search.total.should == 1
        PracticeArea.name_like(practice_area.name).count.should == 1
      end

    end

    describe "search by keyword" do

      it "should find by keyword" do
        offering = FactoryGirl.create(:offering, :name => 'Find me')
        search = Offering.search do
          fulltext offering.name
        end
        search.total.should == 1
      end
    end

  end

end
