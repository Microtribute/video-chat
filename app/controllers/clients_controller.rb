class ClientsController < ApplicationController

  def new
    
    # this is how we redirect users on login
    if params[:return_path].present?
      session[:return_to] = params[:return_path]
    end

    # Empy return_to if user came from homepage
    if request.referer == root_url
      session[:return_to] = nil 
    end

    # set up our client
    @client = Client.new

  end

  def create
    @client = Client.new(params[:client])

    if @client.save
      UserMailer.notify_client_signup(@client).deliver
      log_in_user!(@client)
      return redirect_on_login
    else
      return render(:action => :new)
    end
  end

  # method to redirect a user after he logs in
  def redirect_on_login
    # always return to return_to if it's set
    if session[:return_to].present?
      return redirect_to(session.delete(:return_to))
    end
    # default to redirecting to lawyers path
    return redirect_to(lawyers_path)
  end

end