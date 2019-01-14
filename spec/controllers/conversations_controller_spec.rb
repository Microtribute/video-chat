require "spec_helper"

describe ConversationsController do
  DatabaseCleaner.clean
  render_views

  context "on conversation summary" do
    before :each do
      # sign in as Brian
      @brian = FactoryGirl.create(:user, email: "brian@lawdingo.com")
      session[:user_id] = @brian.to_param
    end

    context "if lawyer answers the phone" do
      context "and accepts a call"
      context "and refuses a call"
    end

    context "if lawyer doesn't answer the phone" do
      context "and call ends after ~30 seconds"
      context "and user ends a call"
    end
  end
end
