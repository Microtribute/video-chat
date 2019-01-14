require 'spec_helper'

describe Appointment do

  context "#attorney_name" do

    it "should delegate the call to the attorney's full name" do
      lawyer = Lawyer.new
      lawyer.stubs(:full_name => "Dan Langevin")

      subject.stubs(:lawyer => lawyer)
      subject.attorney_name.should eql("Dan Langevin")
    end

  end

  context "#client_name" do

    it "should delegate the call to the client's full name" do
      client = Client.new
      client.stubs(:full_name => "Dan Langevin")

      subject.stubs(:client => client)
      subject.client_name.should eql("Dan Langevin")
    end

  end
  
  context "#contact_number" do

    it "should be blank if the contact number is nil" do
      subject.contact_number.should eql("")
    end

    it "should show contact numbers in a standard format" do
      subject.contact_number = "1234567890"
      subject.contact_number.should eql("(123) 456-7890")
    end

  end

  context "#contact_number=" do

    it "should remote all non-digit characters" do
      subject.contact_number = "(123) 456 - 7890"
      subject.contact_number.should eql("(123) 456-7890")
    end

  end

  context "#free_minutes" do

    it "should delegate the call to the attorney's full name" do
      lawyer = Lawyer.new
      lawyer.stubs(:free_consultation_duration => 10)

      subject.stubs(:lawyer => lawyer)
      subject.free_minutes.should eql(10)
    end

  end

  context "#per_minute_rate" do

    it "should delegate the call to the attorney's full name" do
      lawyer = Lawyer.new
      lawyer.stubs(:rate => 1.5)

      subject.stubs(:lawyer => lawyer)
      subject.per_minute_rate.should eql(1.5)
    end

  end

end
