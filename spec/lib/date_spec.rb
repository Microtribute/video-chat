require 'spec_helper'

describe Date do
  
  its "to_time method should be in the current time zone" do
    Date.today.to_time.midnight.should eql Time.zone.now.midnight
  end

end