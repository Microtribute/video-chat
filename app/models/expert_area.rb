class ExpertArea < ActiveRecord::Base
  belongs_to :lawyer,
    :touch => true
  belongs_to :practice_area,
    :touch => true
end

