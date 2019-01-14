FactoryGirl.define do
  factory :conversation do
    client
    lawyer
    call
    start_date Time.now
    end_date 1.hour.from_now
    consultation_type "video"
    billable_time 20
    lawdingo_charge{AppParameter.service_charge_value}
  end
end
