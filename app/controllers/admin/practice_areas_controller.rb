class Admin::PracticeAreasController < ApplicationController
  before_filter :authenticate_admin

  def index
    @practice_areas = PracticeArea.order('parent_id asc')
  end

  def new
    @practice_area = PracticeArea.new
    @parent_practice_areas = PracticeArea.parent_practice_areas
  end

  def create
    @practice_area = PracticeArea.new(params[:practice_area])
    if @practice_area.save
      redirect_to admin_practice_areas_path, :notice =>"New PracticeArea added!"
    else
      render :action =>:new
    end
  end

  def edit
    begin
      @practice_area = PracticeArea.find params[:id]
      @parent_practice_areas = PracticeArea.parent_practice_areas
    rescue
      redirect_to admin_practice_areas_path, :notice =>"No PracticeArea Found!"
    end
  end

  def update
    @practice_area = PracticeArea.find params[:id]
    if @practice_area.update_attributes(params[:practice_area])
      redirect_to admin_practice_areas_path, :notice =>"PracticeArea Updated!"
    else
      render :action =>:edit
    end
  end

  def destroy
    begin
      @practice_area = PracticeArea.find params[:id]
    rescue
      redirect_to admin_practice_areas_path, :notice =>"No Account Found!"
    end
    @practice_area.destroy
    redirect_to admin_practice_areas_path, :notice =>"Account Removed Successfully!"
  end
end

