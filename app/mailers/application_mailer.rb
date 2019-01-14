class ApplicationMailer < ActionMailer::Base
  
  # Draper requires that we set the current_view_context
  def mail(*args, &block)
    self.set_current_view_context 
    super
  end

end