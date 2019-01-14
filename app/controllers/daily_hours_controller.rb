class DailyHoursController < ApplicationController

  before_filter(:set_lawyer)

  # GET /users/:id/daily_hours
  def index
    @daily_hours = @lawyer.daily_hours
  end

  # PUT /users/:id/daily_hours
  # update a user's daily hours
  def update
    # handle missing params just to be safe
    params[:daily_hours] ||= {}

    # default hours
    default_hours = {:start_time => -1, :end_time => -1}

    # set our daily hours, defaulting to closed
    @daily_hours = (0..6).to_a.collect do |i|
      dh = @lawyer.daily_hours_on_wday(i)
      # default to a new daily hour for this lawyer
      dh ||= DailyHour.new(:wday => i, :lawyer => @lawyer)
      # if we pass no params, make the day closed - this is the 
      # equivalent to deleting
      dh.attributes = params[:daily_hours][i.to_s] || default_hours
      dh  
    end

    # set the daily hours on the lawyer
    @lawyer.daily_hours = @daily_hours

    # save the  all of its hours of operation, 
    if @lawyer.save
      return redirect_to(:action => :index, :user_id => @lawyer.id)
    else
      return render(:action => :index)
    end
  end

  protected 

  # set the current lawyer
  def set_lawyer
    @lawyer = Lawyer.find(params[:user_id])
  end

end
