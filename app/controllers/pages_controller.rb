class PagesController < ApplicationController

  def show
    #begin
     # @page = Page.find_by_name params[:name]
    #rescue
     # @page = nil
    #end
    @title = "About Lawdingo"
    render "about"
    #unless @page
     # render :template =>"/shared/no_page" and return
    #end

  end

  def about_client
    @title = "About Lawdingo"
    render "about_attorneys"
  end
  
  def pricing_process
  end
  
  def process_signup
    if params[:return_path]
      session[:return_to] = params[:return_path]
    end

    # Keep question notice after clicking the login link
    session[:keep_question_notice] = true if params[:question_notice].present?

    # Empy return_to if user came from homepage
    session[:return_to] = nil if request.referer == root_url

    redirect_to root_path and return if current_user
    user_type  = params[:ut] || '1'
    if user_type == '0'
      @user       = User.new(:user_type => User::CLIENT_TYPE  )
    else
      @user       = Lawyer.new(:user_type => User::LAWYER_TYPE )
      @states = State.all
      @states.count.times {@user.bar_memberships.build}
    end
  end
  
  def pricing_process_activation
  end

  def terms_of_use
  end
  
  def markup
    render "markup", :layout => 'new_markup'
  end

  def lawyers
    render "lawyers", :layout => 'new_markup'
  end

  def profile
    render "profile", :layout => 'new_markup'
  end

end

