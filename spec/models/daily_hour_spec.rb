require 'spec_helper'

describe DailyHour do
  
  subject{FactoryGirl.build_stubbed(:daily_hour)}

  context "validation" do

    before(:each) do
      subject.wday = 1
    end

    it "should require that its end_time be greater than its
      start time" do
      subject.start_time = 800
      subject.end_time = 700

      subject.should_not be_valid

      subject.errors.full_messages.should include(
        "Start time must be before end time."
      )
    end

    it "should require that both times be -1 if either is" do
      subject.start_time = -1
      subject.end_time = 700

      subject.should_not be_valid

      subject.errors.full_messages.should include(
        "You must mark both the start time and end time " +
        "as closed for a day."
      )
    end

    it "should allow both start and end time to be -1" do

      subject.start_time = -1
      subject.end_time = -1

      subject.should be_valid

    end

  end

  context "#bookable_at_time?" do

    it "should not be bookable if it starts with -1" do
      subject.start_time = -1
      subject.wday = Date.today.wday
      subject.bookable_at_time?(Time.zone.now + 10.hours).should be false
    end

    it "should not be bookable if it ends with -1" do
      subject.end_time = -1
      subject.wday = Date.today.wday
      subject.bookable_at_time?(Time.zone.now + 10.hours).should be false
    end

    it "should be bookable on a day if the day has hours 
      and is in the future" do
      subject.wday = Time.zone.now.wday
      time_to_check = Time.zone.now.midnight + 7.days + 11.hours
      subject.bookable_at_time?(time_to_check).should be true
    end

    it "should not be bookable if the wday doesn't match up" do
      subject.wday = Time.zone.now.wday
      time_to_check = Time.zone.now.midnight + 1.day + 11.hours
      subject.bookable_at_time?(time_to_check).should be false
    end

  end

  context "#bookable_on_day?" do
    
    it "should not be bookable if it starts with -1" do
      subject.start_time = -1
      subject.wday = Date.today.wday
      subject.bookable_on_day?(Time.zone.now + 10.hours).should be false
    end

    it "should not be bookable if it ends with -1" do
      subject.end_time = -1
      subject.wday = Date.today.wday
      subject.bookable_on_day?(Time.zone.now + 10.hours).should be false
    end

    it "should be bookable on a day if the day has hours 
      and is in the future" do
      subject.wday = Date.today.wday
      subject.bookable_on_day?(Date.today + 7).should be true
    end

    it "should not be bookable if the wday doesn't match up" do
      subject.wday = Date.today.wday
      subject.bookable_on_day?(Date.today + 1).should be false
    end

    it "should not be bookable on a day if the day is today and the end
      time is in the past" do
      subject.wday = Date.today.wday
      subject.end_time = 1430
      t = Time.zone.now + 15.hours
      Time.stubs(:now => t)

      subject.bookable_on_day?(Date.today).should be false
    end

  end

  context "closed?" do
    it "should be closed if its start_time is -1" do
      subject.start_time = -1
      subject.should be_closed
    end

    it "should be closed if its end_time is -1" do
      subject.end_time = -1
      subject.should be_closed
    end
  end

  context "#end_time_on_date" do

    it "should return nil if it is the wrong wday" do
      t = Time.zone.now
      t.stubs(:wday => 3)
      subject.stubs(:wday => 4)
      subject.end_time_on_date(t).should be_nil
    end

    it "should return nil if it is the wrong wday" do
      t = Time.zone.now.midnight
      t.stubs(:wday => 3)
      subject.stubs(
        :wday => 3,
        :end_time => 1230
      )
      subject.end_time_on_date(t).should eql(
        t + 12.hours + 30.minutes
      )
    end

  end

  context "#start_time_on_date" do

    it "should return nil if it is the wrong wday" do
      t = Time.zone.now
      t.stubs(:wday => 3)
      subject.stubs(:wday => 4)
      subject.start_time_on_date(t).should be_nil
    end

    it "should return nil if it is the wrong wday" do
      t = Time.zone.now.midnight
      t.stubs(:wday => 3)
      subject.stubs(
        :wday => 3,
        :start_time => 1230
      )
      subject.start_time_on_date(t).should eql(
        t + 12.hours + 30.minutes
      )
    end

  end

end
