class Message < ActiveRecord::Base
  belongs_to :client
  belongs_to :lawyer
end
