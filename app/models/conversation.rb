class Conversation < ActiveRecord::Base
  belongs_to :client
  belongs_to :lawyer
  has_many :reviews
  has_one :call

  after_create :process_payment

  def self.create_conversation input_params
    client_id       = input_params[:client_id]
    lawyer_id       = input_params[:lawyer_id]
    start_date      = input_params[:start_date]
    end_date        = input_params[:end_date]
    consultation_type = input_params[:consultation_type]
    billable_time   = input_params[:billable_time] || "0"
    lawdingo_charge = AppParameter.service_charge_value

    begin
      lawyer = Lawyer.find(lawyer_id)
    rescue
      logger.info("No Lawyer found")
      lawyer = nil
    end

    if lawyer
      billing_rate  = lawyer.rate
      # calculate billing amount
      billed_amount = billable_time.to_f * (billing_rate + lawdingo_charge)

      conversation = self.create(:client_id =>client_id, :lawyer_id =>lawyer_id, :lawyer_rate =>billing_rate,
        :start_date =>start_date, :end_date =>end_date,:billable_time =>billable_time,:consultation_type => consultation_type,
        :lawdingo_charge =>lawdingo_charge, :billed_amount =>billed_amount, :paid_to_lawyer =>false )
  else
      conversation = nil
    end
    conversation
  end

  def lawyer_name
    lawyer = self.lawyer
    full_name = "#{lawyer.first_name} #{lawyer.last_name}"
    lawyer ? full_name : "-"
  end

  def client_name
    client = self.client
    full_name = "#{client.first_name} #{client.last_name}"
    client ? full_name : "-"
  end

  # in minute
  def duration
    self.end_date - self.start_date
  end

  def lawyer_earning
    self.lawyer_rate * self.billable_time
  end

  # in seconds
  def billed_time
    self.billable_time * 60
  end

  #--------------- Payment Part ---------------------#
  def process_payment
    begin
      user = User.find(self.client_id)
    rescue
      user = nil
    end
    if user
      if self.billable_time > 0
        payment_obj = self.class.process_card user.get_stripe_customer_id, self.id, self.billed_amount
      end
      # change payment status
      self.update_attributes(:has_been_charged => true, :payment_params =>payment_obj.to_json) if payment_obj
      UserMailer.session_notification(self).deliver
    end
  end

  # actual process for payment
  def self.process_card customer_id, conversation_id, billed_amount
    begin
      # create the charge on Stripe's servers - this will charge the user's card
      charge = Stripe::Charge.create(
            :amount => (billed_amount * 100).to_i, # amount in cents
            :currency => "usd",
            :customer => customer_id
        )
    rescue Exception =>exp
      charge = nil
      logger.error("Unable to charge conversation with id: #{conversation_id}\n" + exp.message)
    end
    charge
  end

  #--------------------------------------------------#
end

