class PasswordResetsController < ApplicationController
  def new
  end

  def create
    begin
      user = User.find_by_email(params[:email])
    rescue
      user = nil
    end
    if user
      user.send_password_reset
      redirect_to root_url(reset_email_notice: true)
    else
      redirect_to new_password_reset_path(reset_email_notice: true)
    end
  end

  def edit
    @user = User.find_by_password_reset_token!(params[:id])
  end

  def update
  @user = User.find_by_password_reset_token!(params[:id])
  if @user.password_reset_sent_at < 30.minutes.ago
    redirect_to new_password_reset_path, :alert => "Password reset has expired."
  elsif @user.update_attributes(params[:user])
    redirect_to root_url, :notice => "Password has been reset."
  else
    render :edit
  end
end


end

