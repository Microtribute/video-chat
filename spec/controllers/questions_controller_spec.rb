require 'spec_helper'

describe QuestionsController do
  DatabaseCleaner.clean

  context "on asking a question" do
    context "when user is signed in" do
      before :each do
        @brian = FactoryGirl.create(:user, email: "brian@lawdingo.com")
        session[:user_id] = @brian.to_param
      end

      it "should notify admin by email" do
        expect {
          ask_question
        }.to change(ActionMailer::Base.deliveries, :size).by(1)

        question_email = ActionMailer::Base.deliveries.last
        question_email.to[0].should == "nikhil.nirmel@gmail.com"
      end

      it "should render notice template" do
        ask_question
        should render_template "create"
      end
    end

    context "when user is not signed in" do
      before :each do
        ask_question
      end

      it "should remember a question id" do
        session[:question_id].should be_present
      end

      it "should redirect to sign up page" do
        response.should redirect_to(
          new_client_path(question_notice: true)
        )
      end
    end
  end

  def ask_question
    question = FactoryGirl.create(:question)
    xhr :get, :create, question: question.attributes
  end
end
