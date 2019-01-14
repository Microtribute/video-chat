FactoryGirl.define do
  factory :daily_hour do
    lawyer_id 0 # set lawyer_id on FactoryGirl.create(:daily_hour)
    wday 2
    start_time 1000
    end_time 1800
  end
end
