FactoryGirl.define do
  factory :homepage_image do
    photo { File.new(Rails.root + 'spec/support/factories/files/_5kb_size_gif.gif') }
    association :lawyer, :factory => :lawyer
  end
end
