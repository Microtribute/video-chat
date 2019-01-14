require 'spec_helper'

describe "/daily_hours/index" do

  before(:each) do
    view.stubs(
      :current_user => lawyer,
      :action_name => "index",
      :controller_name => "daily_hours"
    )
    assign(:lawyer, lawyer)
    assign(:daily_hours, lawyer.daily_hours)
  end

  let(:lawyer) do
    lawyer = Lawyer.new
    lawyer.stubs(:id => 14)
    lawyer
  end

  it "should have a form to PUT an update to the lawyer's daily hours" do
    render

    path = user_daily_hours_path(:user_id => lawyer.id)
    rendered.should have_selector("form[action='#{path}']") do
      (0..6).each do |i|
        with_selector("select[name='daily_hours[#{i}][start_time]]'") do
          with_selector("option[value='900'][selected='selected']")
        end
        with_selector("select[name='daily_hours[#{i}][end_time]]'") do
          with_selector("option[value='1700'][selected='selected']")
        end
      end
    end

  end

end