class SessionsController < ApplicationController

  def new
    # Empy return_to if user came from homepage
    session[:return_to] = nil if request.referer == root_url

    if session[:keep_question_notice]
      @question_notice = true
      session[:keep_question_notice] = nil
    end

    if logged_in?
    	redirect_to root_path and return
    end
	end

  def create
    if user = User.authenticate(params[:email], params[:password])
      reset_user_session(user)
      login_in_user(user)
      return_path = ""
      if session[:question_id].present?
        send_pending_question(session[:question_id], user)
      else
        if user.is_client?
          return_path = lawyers_path
          # If there is a pending question
          if session[:return_to]
            return_path = session[:return_to]
            session[:return_to] = nil
          end
        elsif user.is_lawyer?
          update_tokbox_session(user)
          if session[:return_to]
            return_path = session[:return_to]
            session[:return_to] = nil
          else
            return_path = user_daily_hours_path(user.id)
          end
        elsif user.is_admin?
          return_path = user_path(user.id)
        end
        if session[:referred_url]
          return_path = session[:referred_url]
          session[:referred_url] = nil
        end
        redirect_to return_path
      end
    else
      @msg = "You have entered incorrect login credintial."
      render :action => 'new'
    end
  end

  def login_by_app
    response.headers["Access-Control-Allow-Origin"]="*"
    response.headers["Access-Control-Allow-Headers"]="X-Requested-With"
    if user = User.authenticate(params[:email], params[:password])
      render :json=>{:result=>user, :key=>user.hashed_password} and return
    else
      render :json=>{:result=>null, :key=>user.hashed_password} and return
    end
  end

  def set_status_by_app
    response.headers["Access-Control-Allow-Origin"]="*"
    response.headers["Access-Control-Allow-Headers"]="X-Requested-With"
    if user = User.authenticate(params[:email], params[:password])
      if(params[:is_online]=='true')
        user.update_attribute(:is_online,true);
      end

      if(params[:is_online]=='false')
        user.update_attribute(:is_online,false);
      end

      if(params[:call_status]=='decline')
        user.update_attribute(:call_status,'decline');
      end

      render :json=>{:result=>true} and return
    else
      render :json=>{:result=>null} and return
    end
  end


  def destroy
    begin
      logout_user
      redirect_to root_path, :notice => "You successfully logged out"
    rescue
      redirect_to root_path
    end
  end

  private

end

