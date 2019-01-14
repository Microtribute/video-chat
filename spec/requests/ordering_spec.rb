require 'spec_helper'
require 'pp'

describe "Sorting" do

  include Rails.application.routes.url_helpers
  
  before(:all) do
    DatabaseCleaner.clean
    AppParameter.set_defaults
  end

  it "should sort right" do
    lawyer1 = FactoryGirl.create(:lawyer, :first_name => 'First keyword', :is_online => false, :is_available_by_phone => false)
    lawyer2 = FactoryGirl.create(:lawyer, :first_name => 'Second keyword', :is_online => true, :is_available_by_phone => false)
    lawyer3 = FactoryGirl.create(:lawyer, :first_name => 'Third keyword', :is_online => true, :is_available_by_phone => true)
    Lawyer.reindex
    Lawyer.all.count.should == 3
    visit lawyers_path
    # save_and_open_page  
    page.should have_selector('div.results#results')
    page.should have_selector("div.results#results div.lawyer:eq(1) h1 a", content: lawyer3.full_name)
    page.should have_selector("div.results#results div.lawyer:eq(2) h1 a", content: lawyer2.full_name)
    page.should have_selector("div.results#results div.lawyer:eq(3) h1 a", content: lawyer1.full_name)
  end
end
