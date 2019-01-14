FactoryGirl.define do
  factory(:offering) do
    name "Offering"
    fee 100
    description { Faker::Lorem.sentence(1) }
    association :practice_area, :factory => :practice_area
    association :user, :factory => :lawyer
  end
end