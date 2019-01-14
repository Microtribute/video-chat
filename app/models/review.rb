class Review < ActiveRecord::Base
  belongs_to :conversation,
    :touch => true
  belongs_to :lawyer,
    :touch => true
end
