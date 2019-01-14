class AppointmentDecorator < ApplicationDecorator

  decorates :appointment

  def per_minute_rate
    h.number_to_currency(appointment.per_minute_rate)
  end

  # formatted time 3:00 PM on Sunday, 1/1
  def time
    return "" if appointment.time.blank?
    return appointment.time.strftime(
      "%-l:%M %p on %A, %-m/%-e"
    )
  end

end