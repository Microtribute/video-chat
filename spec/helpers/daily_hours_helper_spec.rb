require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the DailyHoursHelper. For example:
#
# describe DailyHoursHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe DailyHoursHelper do


  context "#daily_hours_time_select" do

    before(:each) do
      lawyer = Lawyer.new
      assign(:lawyer, lawyer)
      assign(:daily_hours, lawyer.daily_hours)
    end
    
    it "should create a time select on the half hour" do
      str = helper.daily_hours_time_select("start_time", 1)
      str.should have_selector("option[value='1830'][text()=' 6:30PM']")
    end

    it "should auto-select the correct time" do
      lawyer = Lawyer.new
      lawyer.daily_hours << DailyHour.new(:wday => 1, :start_time => 1000)

      assign(:daily_hours, lawyer.daily_hours)

      str = helper.daily_hours_time_select("start_time", 1)

      str.should have_selector("option[value='1000'][selected='selected']")

    end

  end

end
