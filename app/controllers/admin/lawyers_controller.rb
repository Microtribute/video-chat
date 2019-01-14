class Admin::LawyersController < ApplicationController

  before_filter :authenticate_admin

  def index
    @users = User.get_lawyers
  end

  def new
    @user = Lawyer.new(:user_type =>User::LAWYER_TYPE)
  end

  def create
    @user = Lawyer.new(params[:user])
    if @user.save
      redirect_to admin_lawyers_path, :notice =>"New Attorney Account Created!"
    else
      render :action =>:new
    end
  end

  def edit
    begin
      @user = Client.find params[:id]
    rescue
      redirect_to admin_lawyers_path, :notice =>"No Account Found!"
    end
  end

  def update
    @user = Lawyer.find params[:id]
    if @user.udpate_attributes(params[:user])
      redirect_to admin_lawyers_path, :notice =>"Attorney Account Updated!"
    else
      render :action =>:edit
    end
  end

  def destroy
    begin
      @user = Lawyer.find params[:id]
    rescue
      redirect_to admin_lawyers_path, :notice =>"No Account Found!"
    end
    @user.destroy
    redirect_to admin_lawyers_path, :notice =>"Account Removed Successfully!"
  end

  def hm_image
    @lawyer = Lawyer.find params[:lawyer_id]
    @homepage_image = HomepageImage.new
  end

  def account_approval
    begin
      account = Lawyer.find params[:lawyer_id]
    rescue
      account = nil
    end
    if account
      new_status = !account.is_approved
      account.update_attribute(:is_approved, new_status)
      Lawyer.reindex
      notice = 'Account Approval Changed!'
    else
      notice = 'No Account found!'
    end
    path  = request.env["HTTP_REFERER"] || admin_lawyers_path
    redirect_to path,  :notice => notice
  end

end

