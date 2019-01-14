require 'spec_helper'

describe SessionsController do
  DatabaseCleaner.clean

  context "POST /create" do
    context "logged in as client" do
      before :each do
        @adam = FactoryGirl.create(:client, first_name: "Adam")
        User.expects(authenticate: @adam)
      end

      it "redirects to lawyers page" do
        post :create, email: @adam.email, password: @adam.password
        response.should redirect_to(lawyers_url)
      end
    end
  end
end
