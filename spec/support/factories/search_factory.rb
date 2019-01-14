FactoryGirl.define do
  factory(:search) do
    query "bankruptcy"
    association :user
    count 1
  end
end