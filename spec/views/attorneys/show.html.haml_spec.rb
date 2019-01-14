require 'spec_helper'

describe "/attorneys/show" do

  before(:each) do
    assign(:attorney, lawyer)
    view.stubs(:logged_in? => true)
  end
  
  let(:lawyer) do
    FactoryGirl.build_stubbed(:lawyer).tap do |lawyer|
      lawyer.stubs(:next_available_days).with(4).returns([
        Date.today, Date.tomorrow, Date.today + 2, Date.today + 3
      ])
      lawyer.stubs(:available_times).returns([
        Time.now, 
        Time.now + 30.minutes, 
        Time.now + 60.minutes
      ])
      lawyer.stubs(:daily_hours => [DailyHour.new])
    end
  end
  
  it "should render the appointment_form" do
    render
    view.should render_template(:partial => "_appointment_form")
  end

  it "should render the base views for the next four days of appointments" do
    render
    lawyer.next_available_days(4).each do |day|
      lawyer.available_times.each do |t|
        rendered.should have_selector("a[data-time='#{t.to_s(:db)}']")
      end
    end
  end

end