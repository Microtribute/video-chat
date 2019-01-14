class Admin::HomepageImagesController < ApplicationController
  before_filter :authenticate_admin

  def index
    @homepage_images = HomepageImage.all
  end

  def new
  end

  def create
    if HomepageImage.create(params[:homepage_image])
      redirect_to admin_homepage_images_path, :notice =>"Image Created!"
    else
      render :action => :new
    end

  end

  def destroy
    begin
      @homepage_image = HomepageImage.find(params[:id])
      @homepage_image.destroy
      redirect_to admin_homepage_images_path, :notice =>"Delete successfully"
    rescue
      redirect_to admin_homepage_images_path, :notice =>"No Image found"
    end
  end

end

