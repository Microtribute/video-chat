require 'spec_helper'

  describe "StripeController::Routing" do
  it "should provide route /paid for the subscribe_lawyer page" do
    {:get => subscribe_lawyer_path}.should route_to({
      :controller => "stripe",
      :action => "subscribe_lawyer"
    })

  end
end