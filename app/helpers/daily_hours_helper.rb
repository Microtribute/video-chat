module DailyHoursHelper

  # time select for wday
  def daily_hours_time_select(name, wday)
    # get our relevant daily hour
    daily_hour = @daily_hours.select{|dh| dh.wday == wday}.first 
    daily_hour ||= DailyHour.new(:start_time => -1, :end_time => -1)

    opts = {
      :name => "daily_hours[#{wday}][#{name}]", 
      :class => daily_hour.errors.present? ? "error" : ""
    }

    content_tag(:select, opts) do
      ret = "".tap do |ret|
        t = 0
        ret << content_tag(:option, "Closed", :value => "-1")
        while t <= 2330
          # is this option selected
          selected = (t == daily_hour.send(name))
          ret << generate_option(t, selected)
          # increment by 30 or 70
          t += (t % 100 == 0 ? 30 : 70)
        end
        ret
      end
      ret.html_safe
    end
  end

  protected

  # helper to generate an option for the select
  def generate_option(value, selected)
    content_tag(:option, :value => value, :selected => selected) do
      hours, minutes = value.divmod(100)
      t = Time.now.midnight
      t = t + hours.hours + minutes.minutes
      t.strftime("%l:%M%p")
    end
  end

end
