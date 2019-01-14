task :populate_free_consultation_duration => :environment do
  User.where(user_type: 'LAWYER').each do |lawyer|
    lawyer.update_attribute :free_consultation_duration, 15
  end
  puts "\nPopulation done."
end

task :set_inquiries_closed_value => :environment do
  Inquiry.all.each do |inquiry|
    inquiry.update_attributes({ is_closed: inquiry.expired? })
  end
end
