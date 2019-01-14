require 'spec_helper'

describe InquiriesController do
  
  describe "GET show" do
    
    let(:inquiry) do
      FactoryGirl.build_stubbed(:inquiry)
    end

    let(:lawyer) do
      lawyer = FactoryGirl.build_stubbed(:lawyer, first_name: "Thom")
      lawyer.stubs(:becomes => lawyer)
      lawyer
    end

    before(:each) do
      Inquiry.stubs(:find).with(inquiry.id.to_s).returns(inquiry)
    end

    context "when logged in" do
      
      before :each do
        controller.stubs(:current_user => lawyer)
      end

      it "returns http success" do
        get :show, id: inquiry.to_param
        response.should be_success
        assigns(:bid).should be_present
      end

      it "assigns to @bid" do
        
      end
    end

    context "when logged out" do
      before :each do
        session[:user_id] = nil
        get :show, id: inquiry.to_param
      end

      it "redirects to login page" do
        response.should redirect_to(login_path)
      end

      it "sets a return url" do
        session[:return_to].should eq(inquiry_path(inquiry.to_param))
      end
    end
  end
end
