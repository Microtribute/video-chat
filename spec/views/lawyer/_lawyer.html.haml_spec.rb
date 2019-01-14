require 'spec_helper'

describe "/lawyer/_lawyer" do

  before(:each) do
    view.stubs(:logged_in? => true)
  end
  
  let(:lawyer) do
    FactoryGirl.build_stubbed(:lawyer).tap do |lawyer|
      lawyer.stubs(:next_available_days).with(2).returns([
        Date.today, Date.tomorrow
      ])
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

  it "should render the base views for the next two days of appointments" do
    render(
      :partial => "/lawyer/lawyer", 
      :locals => {:lawyer => LawyerDecorator.new(lawyer)}
    )
    lawyer.next_available_days(4).each do |day|
      lawyer.available_times.each do |t|
        rendered.should have_selector("a[data-time='#{t.to_s(:db)}']")
      end
    end
  end

  it "should not render any appointment times if the lawyer doesn't
    have daily_hours" do

    lawyer.stubs(:daily_hours => [])
    render(
      :partial => "/lawyer/lawyer", 
      :locals => {:lawyer => LawyerDecorator.new(lawyer)}
    )
    rendered.should_not have_selector("a.appointments")

  end

end