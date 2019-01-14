require 'spec_helper'

describe UsersController do
  DatabaseCleaner.clean

  include Rails.application.routes.url_helpers

  let(:lawyers) do
    [Lawyer.new]
  end

  it "should build a list of all practice areas for the search" do
    practice_areas = [PracticeArea.new]
    PracticeArea.expects(:parent_practice_areas => practice_areas)
    get(:home)
    assigns["practice_areas"].should eql practice_areas
  end

  context "on sign up" do
    context "when a pending question exists" do
      before :each do
        @question = FactoryGirl.create(:question, user_id: nil)
        @stefan = FactoryGirl.build(:user, email: "stefan@lawdingo.com")
        session[:question_id] = @question.id
      end

      it "should update question user data" do
        post :create, user: @stefan.attributes
        @question.user_id.should == @stefan.id
      end

      # it "should notify admin by email" do
      #   expect {
      #     post :create, user: @stefan.attributes
      #   }.to change(ActionMailer::Base.deliveries, :size).by(1)

      #   question_email = ActionMailer::Base.deliveries.last
      #   question_email.subject.should match /Question ##{@question.id}/
      # end
    end
  end

  context "on starting a phone call" do
    before :each do
      @james = FactoryGirl.create(:client, first_name: "James", phone: "")
      @morgan = FactoryGirl.create(:lawyer, first_name: "Morgan")

      # sign in as James (client)
      session[:user_id] = @james.to_param
    end

    it "should remember client's phone number" do
      number = "1234567890"
      post :create_phone_call, { lawyer_id: @morgan.to_param, client_number: number }
      response.should redirect_to controller: "users", action: "start_phone_call", id: @morgan.to_param, notice: "Error: making a call"
      User.find(session[:user_id]).phone.should eq(number)
    end
  end

  context "came to sign up page from root" do
    before :each do
      @request.stubs(:referer).returns(root_url(host: "localhost"))
    end

    it "set session[:return_to] to nil" do
      get :new
      session[:return_to].should eq(nil)
    end
  end

  context "#send_email_to_lawyer" do
    render_views

    before :each do
      @amy = FactoryGirl.create(:client, first_name: "Amelia")
      @doctor = FactoryGirl.create(:lawyer, first_name: "The Doctor")
      @attributes = { l2: @doctor.to_param, email_msg: "Geronimo!" }
      session[:user_id] = @amy.to_param
    end

    it "save a message" do
      expect {
        get :send_email_to_lawyer, @attributes
      }.to change(Message, :count).by(1)

      message = Message.last
      message.lawyer_id.should eq(@doctor.id)
      message.client_id.should eq(@amy.id)
      message.body.should match /Geronimo!/
    end

    it "send an email to lawyer" do
      expect {
        get :send_email_to_lawyer, @attributes
      }.to change(ActionMailer::Base.deliveries, :size).by(1)

      email = ActionMailer::Base.deliveries.last
      email.to.should include @doctor.email
    end

    it "render 1 when message is sent" do
      get :send_email_to_lawyer, @attributes

      response.body.should eq "1"
    end
  end

  context "#create_lawyer_request" do
    it "should send an email with lawyer request" do
      expect {
        post :create_lawyer_request, request_body: "Something new."
      }.to change(ActionMailer::Base.deliveries, :size).by(1)

      email = ActionMailer::Base.deliveries.last
      email.to.should include "info@lawdingo.com"
      email.subject.should match /New lawyer request/
      email.body.should match /Something new/
    end
  end
end
