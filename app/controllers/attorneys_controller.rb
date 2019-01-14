class AttorneysController < ApplicationController
  before_filter :check_approval, only: :show

  def show
    @attorney = Lawyer.find(params[:id])
    # set the time zone
    Time.zone = @attorney.time_zone
    
    @video = Framey::Video.find_by_creator_id(@attorney.id) if @attorney.has_video?

    pas = []
    pas = @attorney.practice_areas.parent_practice_areas unless @attorney.practice_areas.blank?
    pas_string = ""
    pas.each{|pa|
      pas_string += pa.name + ', '
    }
    pas_string.chomp!(', ')

    pas_names = pas.map { |area| area.name.downcase  }
    pas_names_last = pas_names.pop
    pas_names_list = pas_names.empty? ? pas_names_last : "#{pas_names.join(', ')} and #{pas_names_last}"

    @areas = pas_names_list
  end

  def call_payment
   @attorney = Lawyer.find(params[:id])

  end
  
  private

    def check_approval
      redirect_to lawyers_path, notice: "Sorry, this lawyer's bar membership hasn't been verified just yet." unless Lawyer.find(params[:id]).is_approved
    end
end

