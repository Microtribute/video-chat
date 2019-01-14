class TwilioController < ApplicationController

  def twilio_return_voice
    render :file=>"twilio/twilio_return_voice.xml", :content_type => 'application/xml', :layout => false
  end

  def process_gather
    @call = Call.find_by_sid(params[:CallSid])
    @call.update_attribute(:digits, params[:Digits].to_i) if params[:Digits]

    if params[:Digits].to_i == 1
      @call.update_attribute(:status,'connected')
      render :file=>"twilio/process_gather.xml", :content_type => 'application/xml', :layout => false
      return
    else
      @call.update_attribute(:status, 'ignored')
#      @client = Twilio::REST::Client.new 'ACc97434a4563144d08e48cabd9ee4c02a', '3406637812b250f4c93773f0ec3e4c6b'
#      @twilio_call = @client.account.calls.get(params[:CallSid])
#      @twilio_call.hangup
      render :file=>"twilio/gather_failure.xml", :content_type => 'application/xml', :layout => false
      return
    end

  end

  def dial_callback
    if params[:DialCallStatus] == 'completed'
    else
      @call = Call.find_by_sid(params[:CallSid])
      @call.update_attribute(:status, 'disconnected')
    end
    render :file=>"twilio/dial_response.xml", :content_type => 'application/xml', :layout => false
  end

  def call_end_url
    render :text => "", :layout => false
  end

  def fallback
    render :text => "", :layout => false
  end

  def callbackstatus
    @call = Call.find_by_sid(params[:CallSid])
    @call.update_attributes(:end_date => Time.now, :call_duration =>params[:CallDuration])
    input_params = Hash.new
    input_params[:client_id] = @call.client_id
    input_params[:lawyer_id] = @call.lawyer_id
    input_params[:start_date] = @call.start_date
    input_params[:end_date] = @call.end_date
    input_params[:consultation_type] = "phone"
    billable_time = @call.billing_start_time.present? ? (@call.end_date - @call.billing_start_time) : 0
    input_params[:billable_time] = (billable_time/60).ceil
    conversation = Conversation.create_conversation(input_params)
    @call.update_attributes(:conversation_id => conversation.id, :status => 'completed')
    render :text => "", :layout => false
  end

end

