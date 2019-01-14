FactoryGirl.define do
  factory :question do
    body "Are you my mommy?"
    type "advice"
    user
  end
end
