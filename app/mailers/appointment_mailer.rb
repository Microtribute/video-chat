class AppointmentMailer < ApplicationMailer

  default :from => "appointments@lawdingo.com",
    :bcc => ["offline@lawdingo.com", "nikhil.nirmel@gmail.com", "info@lawdingo.com"]

  def appointment_created(appointment)
    @appointment = appointment
    mail(
      :to => appointment.attorney_email,
      :subject => "Client Appointment Request on Lawdingo."
    )
  end
end