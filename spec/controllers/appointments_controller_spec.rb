require 'spec_helper'

describe AppointmentsController do

  context "POST /appointments" do

    before(:each) do
      controller.stubs(:current_user => current_user)
      controller.stubs(:authenticate => true)
    end

    let(:current_user) do
      Client.new do |c|
        c.stubs(:id => 1, :new_record? => false, :becomes => c)
      end
    end

    let(:appointment) do
      Appointment.new.tap do |appt|
        appt.stubs(:id => 1, :new_record? => false, :save => true)
      end
    end

    let(:appt_data) do
      {
        "time" => (Time.now + 1.day).to_s, 
        "contact_number" => "180097JENNY",
        "lawyer_id" => "123",
        "appointment_type" => "videochat"
      }
    end

    it "should create a new appointment" do
      Appointment.expects(:create)
        .with(appt_data.merge("client" => current_user))
        .returns(appointment)

      AppointmentMailer.expects(:appointment_created)
        .returns(stub("Mailer", :deliver => true))

      post(:create, :appointment => appt_data, :format => :json)
      response.status.should eql 201
    end

  end

end
