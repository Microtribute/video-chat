class Call < ActiveRecord::Base
  belongs_to :client
  belongs_to :conversation

  CALL_STATUS =['dialing','ignored','connected','billed','disconnected','completed']
  validates_inclusion_of :status, :in => CALL_STATUS, :message => "Invalid call status"
end
