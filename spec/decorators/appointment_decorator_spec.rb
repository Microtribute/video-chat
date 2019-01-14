require 'spec_helper'

describe AppointmentDecorator do

  subject do
    AppointmentDecorator.new(appointment)
  end

  let(:appointment) do
    Appointment.new.tap do |a|
      a.stubs(:time => time, :per_minute_rate => 10)
    end
  end

  let(:time) do
    Time.zone.parse("2012-01-01 15:00:00")
  end

  context "#per_minute_rate" do

    it "should be formatted as currency" do
      subject.per_minute_rate.should eql("$10.00")
    end

  end

  context "#time" do

    it "should format the time as human-readable" do
      formatted_time = "3:00 PM on Sunday, 1/1"
      subject.time.should eql(formatted_time)
    end

  end

end