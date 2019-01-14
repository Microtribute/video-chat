class UserMailer < ApplicationMailer
  default :from => "lawdingo@gmail.com",
          :bcc => "offline@lawdingo.com"

  def schedule_session_email(user, lemail, msg)
    @user = user
    @msg = msg
    #attachments.inline['logo.png'] = File.read("#{Rails.root}/app/assets/images/logo.png")
    mail(
      :from => user.email,
      :to => lemail,
      :return_path => user.email,
      :subject => "An inquiry from a client on Lawdingo"
    )
  end

  def notify_lawyer_application(user)
    @lawyer = user
    mail(
      :to => "nikhil.nirmel@gmail.com",
      :subject => "New lawyer applied"
    )
  end

  def notify_client_signup(user)
    @client = user
    mail(
      :to => "nikhil.nirmel@gmail.com",
      :subject => "New client signed up"
    )
  end

  def session_notification(conversation)
    @conversation = conversation
    mail(
      :to => "nikhil.nirmel@gmail.com",
      :subject => "New session created"
    )
  end

  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => "Password Reset"
  end

  def new_question_email(question)
    @question = question
    @type = @question.type == "lawyer" ? "advice" : "service"

    mail(to: "nikhil.nirmel@gmail.com", subject: "Question ##{@question.id}")
  end

  def closed_inquiry_notification(inquiry)
    @inquiry = inquiry
    @inquiry_url = inquiry_url(@inquiry)

    mail(to: %w(nikhil.nirmel@gmail.com info@lawdingo.com), subject: "Inquiry ##{@inquiry.id} closed")
  end

  def new_bid_notification(bid)
    @bid = bid
    @inquiry_url = inquiry_url(@bid.inquiry)

    mail(to: "nikhil.nirmel@gmail.com", subject: "Bid ##{@bid.id} submitted")
  end

  def free_inquiry_email(question, lawyer)
    @question = question
    @lawyer = lawyer

    mail(to: @lawyer.email, subject: "Inquiry: #{@question.practice_area} in #{@question.state_name}")
  end

  def auction_inquiry_email(question, lawyer)
    @question = question
    @lawyer = lawyer

    @inquiry_url = inquiry_url(@question.inquiry)
    @login_url = login_url

    mail(to: @lawyer.email, subject: "Premium Inquiry: #{@question.practice_area} in #{@question.state_name}")
  end

  def lawyer_request_email(request_body)
    @request_body = request_body

    mail(to: "info@lawdingo.com", subject: "New lawyer request")
  end

end
