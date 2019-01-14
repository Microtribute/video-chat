require 'spec_helper'

describe "general question for lawyers", :integration do

  context "when is signed in" do
    it "should show question form" do
      sign_in
      page.body.should have_selector("div.question-container")
    end
  end

  def sign_in
    user = FactoryGirl.create(:user)
    visit login_path
    page.fill_in "email", with: user.email
    page.fill_in "password", with: "secret"
    click_button "submit_login"
  end
end

describe "lawyer specific question" do
  before :each do
    @lily = FactoryGirl.create(:lawyer, 
      first_name: 'Lily', last_name: 'Smith'
    )
    visit attorney_path(@lily.to_param, slug: @lily.slug)
    click_link "Send a note or ask a question"
  end

  context "when user is not signed in" do
    it "should redirect to sign up page when send a question link clicked" do
      page.should have_content("Who are you?")
    end

    it "should redirect back to lawyer profile after user signs up\in" do
      @bill = FactoryGirl.create(:user, email: "bill@gmail.com", password: "secret")

      visit new_session_path
      page.fill_in 'email', with: @bill.email
      page.fill_in 'password', with: 'secret'
      click_button "Log In"

      page.should have_content(@lily.full_name)
    end
  end
end
