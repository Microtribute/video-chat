include ActionView::Helpers::NumberHelper # Number helpers available inside controller method

class SearchController < ApplicationController
  include LawyersHelper
  include SearchHelper
  include ActionView::Helpers::TextHelper
  
  def populate_specialities
    @practice_area = PracticeArea.find(params[:pid])
    specialities_ids_lawyers = PracticeArea.child_practice_areas_having_lawyers.map(&:id)
    practice_area_specialites_ids = @practice_area.specialities.map(&:id)
    practice_area_specialites_lawyers_ids = specialities_ids_lawyers & practice_area_specialites_ids
    @practice_area_specialities = PracticeArea.find(practice_area_specialites_lawyers_ids).sort_by(&:name) rescue[]
#    @practice_area_specialities = @practice_area.specialities.order(:name) rescue []
    render :action => 'populate_specialities', :layout => false
  end

  # Temporary method for the next home page
  def populate_specialities_next
    @practice_area = PracticeArea.find(params[:pid])
    @practice_area_specialities = @practice_area.specialities.order(:name) rescue []
    render :action => 'populate_specialities_next', :layout => false
  end

  def filter_results
    type = params[:type]
    state_id = params[:state].to_i
    pa_id = params[:pa].to_i
    sp_id = params[:sp].to_i
    
    @type = type.to_s

    @lawyers = []
    @state_lawyers = []

    if state_id == 0
      @state_lawyers = Lawyer.approved_lawyers
    else
      @state_lawyers = State.find(state_id).lawyers.approved_lawyers
    end

    if type == "lawyer"
      if pa_id == 0
        @lawyers = @state_lawyers
      else
        if sp_id == 0
          @selected_practice_area = "general #{PracticeArea.find(pa_id).name.downcase}"
          @pa_lawyers = PracticeArea.find(pa_id).lawyers.approved_lawyers
        else
          @selected_practice_area = PracticeArea.find(sp_id).name.downcase
          @pa_lawyers = PracticeArea.find(sp_id).lawyers.approved_lawyers
        end
        @lawyers = @state_lawyers & @pa_lawyers
      end
      render action: "filter_lawyer_results", layout: false
    elsif type == "offering"
      # If all types selected show all fixed-price offers
      @offerings = []
      @state_offerings = []
      @area_offerings = []

      @state_lawyers.each do |lawyer|
        if lawyer.offerings.any?
          lawyer.offerings.each do |offering|
            @state_offerings << offering
          end
        end
      end

      unless pa_id == 0
        @offerings_practice_area = PracticeArea.find(pa_id)

        if @offerings_practice_area.present?
          @offerings_practice_area.offerings.each do |offering|
            if offering.user.is_approved
              @area_offerings << offering
            end
          end
        end
      else
        @area_offerings = Offering.all
      end

      @offerings = @area_offerings & @state_offerings
        
      render action: "filter_offering_results", layout: false
    end
  end

  def get_homepage_lawyers
    @homepage_images = HomepageImage.all
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: get_homepage_images_hash(@homepage_images) }
    end
  end
  
  protected
  
  def link_to(*args)
    puts args.inspect
    self.class.helpers.link_to *args
  end
end

