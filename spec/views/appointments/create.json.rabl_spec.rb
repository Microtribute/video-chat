require 'spec_helper'

describe "/appointments/create" do

  before(:each) do
    assign(:appointment, AppointmentDecorator.new(appointment))
  end

  let(:appointment) do
    Appointment.new.tap do |a| 
      a.stubs({
        :attorney_name => "Dan Langevin",
        :contact_number => "2035544552"
      })
    end
  end
  
  it "should render the appropriate fields of the appointment" do
    render
    json = JSON.parse(rendered)
    %w{time attorney_name}.each do |field|
      json["appointment"].should have_key(field)
    end
  end


  it "should render errors where appropriate" do
    appointment.stubs(:errors => {:field => ["err1"]})
    render
    json = JSON.parse(rendered)

    json["appointment"].should have_key("errors")
    json["appointment"]["errors"].should eql({
      "field" => ["err1"]
    })
  end

end