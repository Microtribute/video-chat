class Appointment < ActiveRecord::Base

  # Associations
  belongs_to :client
  belongs_to :lawyer


  # Validations

  # REMOVED FOR NOW - WILL COME BACK
  # validates :appointment_type, :inclusion => {
  #   :in => %w{phone video},
  #   :message => "%{value} is not a valid type of appointment"
  # }
  # validates :contact_number, :format => {
  #   :with => /\d{10}/,
  #   :message => "Must be a valid phone number (999) 999 9999",
  #   :if => Proc.new{|record| record.appointment_type == "phone"}
  # }
  validates :client, :presence => true
  validates :lawyer, :presence => true
  validates :time, :presence => true

  delegate :email,
    :to => :lawyer,
    :prefix => :attorney,
    :allow_nil => true

  # full name of this appointment's attorney
  def attorney_name
    return nil if self.lawyer.blank?
    return self.lawyer.full_name
  end

  # full name of this appointment's attorney
  def client_name
    return nil if self.client.blank?
    return self.client.full_name
  end

  # standardize format of contact number
  def contact_number
    num = read_attribute(:contact_number)
    return "" if num.blank?
    return "(#{num[0..2]}) #{num[3..5]}-#{num[6..9]}"
  end
  
  # setter for contact_number - remove all non-digit characters
  def contact_number=(new_number)
    write_attribute(:contact_number, new_number.gsub(/[^\d]/,''))
  end

  # number of free minutes for this appt
  def free_minutes
    return nil if self.lawyer.blank?
    return self.lawyer.free_consultation_duration
  end

  # per-minute rate for this appt
  def per_minute_rate
    return nil if self.lawyer.blank?
    return self.lawyer.rate
  end

end
