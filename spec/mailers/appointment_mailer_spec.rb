require 'spec_helper'

describe AppointmentMailer do

  let(:decorator) do
    AppointmentDecorator.new(appointment)
  end

  let(:appointment) do
    Appointment.new.tap do |a|
      a.stubs({
        :time => Time.zone.parse("2011-01-01 15:00:00"),
        :attorney_name => "Dan Langevin",
        :attorney_email => "dan@test.com",
        :client_name => "A. Client",
        :message => "Hi there",
        :free_minutes => 10,
        :per_minute_rate => 1.5
      })
    end
  end

  context "#appointment_created" do

    it "should display the appointment details" do
      mailer = AppointmentMailer.appointment_created(decorator)
      mailer.subject.should eql "Client Appointment Request on Lawdingo."
      mailer.to.should eql(["dan@test.com"])
      mailer.body.should =~ /Hi there/
      mailer.body.should =~ /A. Client/
      mailer.body.should =~ /3:00 PM on Saturday, 1\/1/
      mailer.body.should =~ /10 minutes will be free/
      mailer.body.should =~ /will earn \$1.50 per minute/
    end

  end

end