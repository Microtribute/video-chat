require 'spec_helper'

describe DailyHoursController do

  let(:lawyer) do
    FactoryGirl.build_stubbed(:lawyer)
  end

  before(:each) do
    Lawyer.expects(:find).with(lawyer.id.to_s).returns(lawyer)
  end

  context "GET /users/:id/daily_hours" do

    it "should show all lawyer_daily_hours for a lawyer" do

      daily_hours = [DailyHour.new]
      
      lawyer.expects(:daily_hours).returns(daily_hours)

      get(:index, :user_id => lawyer.id)

      assigns["lawyer"].should eql(lawyer)
      assigns["daily_hours"].should eql(daily_hours)

    end

  end

  context "PUT /users/:id/daily_hours" do

    it "should create a new set of daily_hours for the lawyer" do

      dh = {
        "1" => {:start_time => 800, :end_time => 1200}
      }

      lawyer.stubs(:save => true)
    
      put(:update, :user_id => lawyer.id, :daily_hours => dh)

      assigns["lawyer"].should eql(lawyer)
      # should have 7 daily_hours

      lawyer.daily_hours.length.should eql(7)
      # default to -1
      lawyer.daily_hours_on_wday(2).start_time.should eql(-1)
      # except for the one we posted
      lawyer.daily_hours_on_wday(1).start_time.should eql(800)

    end

  end


end
