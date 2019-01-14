require 'spec_helper'

describe "UsersController::Routing" do
  it "should provide routes for the main search page" do

    url = "/lawyers/Legal-Services/New-York-lawyers/Blah"

    {:get => url}.should route_to({
      :controller => "users",
      :action => "home",
      :state => "New-York-lawyers",
      :service_type => "Legal-Services",
      :practice_area => "Blah"
    })

  end
end