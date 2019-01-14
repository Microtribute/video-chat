class BarMembership < ActiveRecord::Base
  belongs_to :lawyer, :inverse_of => :bar_memberships
  belongs_to :state
end

