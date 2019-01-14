FactoryGirl.define do
  sequence :lawyer_email do |n|
    "lawyer#{n}@lawdingo.com"
  end

  factory :lawyer do
    first_name "Dan"
    last_name "Langevin"
    email { generate :lawyer_email }
    password "123456"
    user_type{User::LAWYER_TYPE}
    free_consultation_duration 10
    is_approved true
    time_zone "Pacific Time (US & Canada)"
    is_online false
    is_available_by_phone true
    payment_status 'free'
  end
end
