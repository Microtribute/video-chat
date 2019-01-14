require 'spec_helper'

describe "/layouts/application" do
  
  context "logged in" do

    let(:user) do
      User.new.tap do |u|
        u.stubs(:id => 1)
      end
    end

    before(:each) do
      view.stubs(:logged_in? => true, :current_user => user)
    end

    it "should add a class to the body" do
      render
      rendered.should =~ /<body[^>]* class=['"][^'"]*logged\-in[^'"]*["']/
    end

  end

  context "not logged in" do

    before(:each) do
      view.stubs(:logged_in? => false, :current_user => nil)
    end

    it "should add a class to the body" do
      render
      rendered.should_not have_selector("body.logged-in")
    end

  end

end