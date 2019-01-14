class Admin::ClientsController < ApplicationController

  before_filter :authenticate_admin

  def index
    @users  = User.get_clients
  end

  def new
    @user = Client.new(:user_type =>User::CLIENT_TYPE)
  end

  def create
    @user = Client.new(params[:client])
    if @user.save
      redirect_to admin_clients_path, :notice =>"Client Account Created!"
    else
      render :action =>:new
    end
  end

  def edit
    begin
      @user = Client.find params[:id]
    rescue
      redirect_to admin_clients_path, :notice =>"No Client Found!"
    end
  end

  def update
    @user = Client.find params[:id]
    params.delete(:password) if params[:password].blank?
    if @user.udpate_attributes(params[:client])
      redirect_to admin_clients_path, :notice =>"Client Account Updated!"
    else
      render :action =>:edit
    end
  end

  def destroy
    begin
      @user = Client.find params[:id]
    rescue
      redirect_to admin_clients_path, :notice =>"No Account Found!"
    end
    @user.destroy
    redirect_to admin_clients_path, :notice =>"Account Removed Successfully!"
  end

end
