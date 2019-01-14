class Admin::PagesController < ApplicationController

  before_filter :authenticate_admin

  def index
    @pages = Page.all
  end

  def new
    @page = Page.new
  end

  def create
    @page = Page.new params[:page]
    if @page.save
      redirect_to admin_pages_path, :notice =>"New Page Added!"
    else
      render :action =>:new
    end
  end

  def edit
    begin
      @page = Page.find params[:id]
    rescue
      render :text =>'No page found!'
    end
  end

  def update
    @page = Page.find params[:id]
    if @page.update_attributes(params[:page])
      redirect_to admin_pages_path, :notice =>"Page Updated!"
    else
      render :action =>:edit
    end
  end

end
