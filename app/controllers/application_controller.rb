class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_timezone
  helper_method :current_admin, :logged_in?, :logged_in_admin?

  def set_timezone
    Time.zone = current_user.try(:time_zone) || "Pacific Time (US & Canada)"
  end
  
  unless Rails.application.config.consider_all_requests_local
     rescue_from ActionController::RoutingError, with: :render_404
     rescue_from ActionController::UnknownController, with: :render_404
     rescue_from ActionController::UnknownAction, with: :render_404
     rescue_from ActiveRecord::RecordNotFound, with: :render_404
  end
  
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
  
  # log in a given user
  def log_in_user!(user)
    session[:user_id] = user.id
    @current_user = user
  end

  def update_tokbox_session user
    tokbox_info = get_tokbox_info
    tokbox_session_id = tokbox_info[0]
    tokbox_token = tokbox_info[1]

    user.update_attributes(
      :tb_session_id => tokbox_session_id,
      :tb_token => tokbox_token,
      :call_status => ''
    )
    session[:user_id] = user.id
  end


  def get_tokbox_info
    require "yaml"
    config = YAML.load_file(File.join(Rails.root, "config", "tokbox.yml"))
    @opentok=OpenTok::OpenTokSDK.new config['API_KEY'],config['SECRET']
    @location=config['LOCATION']
    begin
      session_id = @opentok.create_session(@location)
      token = @opentok.generate_token :session_id => session_id, :expire_time=>(Time.now+2.day).to_i
    rescue => e
      Rails.logger.error(e.message)
      Rails.logger.error(config)
      Rails.logger.error(e.backtrace[0..10])
      session_id = ""
      token = ""
    end
    return [session_id.to_s,token.to_s]
  end


  def current_user
    return nil if session[:user_id].blank?
    @current_user ||= User.find_by_id(session[:user_id])
  end

  def authenticate
    if logged_in?
      current_user.update_attribute(:last_online, Time.now)
    else
      access_denied
    end
    #logged_in? ? true : access_denied
  end

  def login_in_user user
    user.update_attributes(:is_online => true, :is_available_by_phone => true, :last_login => Time.now, :last_online => Time.now)
    session[:user_id] = user.id
  end

  def logout_user
    current_user.update_attributes(:is_online => false, :is_available_by_phone => false, :is_busy =>false, :peer_id =>'0', :last_online => Time.now)
    session[:user_id] = nil
  end

  def reset_user_session user
    user.update_attributes(:is_online => false, :is_available_by_phone => false, :is_busy =>false, :peer_id =>'0')
  end

  def authenticate_admin
    logged_in_admin? ? true : access_denied
  end

  def logged_in?
    current_user.is_a? User
  end

  def logged_in_admin?
    logged_in? and current_user.is_admin?
  end

  def access_denied
    session[:referred_url] = request.fullpath
    redirect_to login_path, :notice => 'You have not logged in' and return false
  end

  def send_pending_question(question_id, user)
    if question_id.present?
      question = Question.find(question_id)
      question.update_attribute(:user_id, user.id)

      UserMailer.new_question_email(question).deliver
      session[:question_id] = nil
      redirect_to lawyers_path, :notice => "Your question has been submitted, and an attorney will get back to you soon with some info."

    end
  end
  
  def render_404
    respond_to do |format|
      format.html { render template: 'errors/error_404', layout: 'layouts/application', status: 404 }
      format.all { render nothing: true, status: 404 }
    end
  end
end
