class InquiriesController < ApplicationController
  before_filter :authenticate

  def show
    @inquiry = Inquiry.find(params[:id])

    # Create a new bid only if logged in user is a lawyer
    if logged_in? && current_user.is_lawyer?
      @bid = current_user.becomes(Lawyer).bids.build
    end
  end

  private

  def authenticate
    unless logged_in?
      session[:return_to] = inquiry_path(params[:id])
      redirect_to login_url
    end
  end

end
