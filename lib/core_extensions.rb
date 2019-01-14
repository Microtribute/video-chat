Date.class_eval do
  # makes it so Date.today.to_time is midnight in the current time_zone
  def to_time_with_time_zone
    # adjust to UTC, then put in the correct time zone
    Time.zone.local_to_utc(self.to_time_without_time_zone).in_time_zone
  end
  alias_method_chain :to_time, :time_zone
end