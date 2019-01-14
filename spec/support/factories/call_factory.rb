FactoryGirl.define do
  factory :call do
    sid Time.now
    status 'completed'
  end
end
