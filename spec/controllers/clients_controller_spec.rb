require 'spec_helper' 


describe ClientsController do 

  context "GET #new" do

    it "should store return_path in the session as return_to 
      TODO: standardize" do

      get(:new, :return_path => "/a/path")
      session[:return_to].should eql("/a/path")

    end

    it "should empty the return_to param if the user is coming from
      the root_url" do

      request.env["HTTP_REFERER"] = root_url
      session[:return_to] = "/a/path"

      get(:new)
      session[:return_to].should be_nil

    end
  end

  context "POST #create" do

    it "should send a signup notification" do
      Client.any_instance.stubs(:save => true, :id => 132)
      UserMailer.expects(:notify_client_signup)
        .with(instance_of(Client))
        .returns(stub(:deliver => true))
      post(:create)
    end

    it "should log in the user by setting the session[:user_id]
      and @current_user" do
      Client.any_instance.stubs(:save => true, :id => 132)
      post(:create)

      session[:user_id].should eql(132)
      assigns[:current_user].should be_instance_of(Client)
    end

    it "should redirect to the lawyers path by default" do
      Client.any_instance.stubs(:save => true)
      post(:create)
      response.should redirect_to(lawyers_path)
    end

    it "should redirect to the return_to in the session if 
      that is set" do

      session[:return_to] = "/a/path"

      Client.any_instance.stubs(:save => true)
      post(:create)
      
      response.should redirect_to("/a/path")
      # should also clear it out
      session[:return_to].should be_nil

    end

  end

end