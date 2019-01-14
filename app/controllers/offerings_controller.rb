class OfferingsController < ApplicationController
  before_filter :ensure_self_account, only: :index

  def index
    @lawyer = User.find(params[:user_id])
    @offering = @lawyer.offerings.new
    @offering.fee = ""
  end

  def show
    @offering = Offering.find(params[:id])
  end

  def create
    @lawyer = User.find(params[:user_id])
    @offering = @lawyer.offerings.new(params[:offering])

    if @offering.save
      redirect_to user_offerings_path(@lawyer)
    else
      redirect_to user_offerings_path, notice: "Error saving an offering."
    end
  end

  def edit
    @offering = Offering.find(params[:id])
    
    render layout: false
  end

  def update
    @offering = Offering.find(params[:id])
    
    if @offering.update_attributes(params[:offering])
      redirect_to user_offerings_path(@offering.user)
    else
      redirect_to user_offerings_path(@offering.user), notice: "Error in updating an offering"
    end
  end

  def destroy
    @offering = Offering.find(params[:id])
    @offering.destroy

    redirect_to user_offerings_path(@offering.user)
  end

  private

    def ensure_self_account
      @user = User.find params[:user_id]

      unless (logged_in?) and (@user.id == current_user.id) or logged_in_admin?
        redirect_to root_path
      end
    end
end
