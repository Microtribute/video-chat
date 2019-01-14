module LawyersHelper
  # def selected_offerings_caption
  #   # Offerings
  #   if @offerings.present?
  #     offerings_count  = @offerings.count.to_s
  #     offerings_str = @offerings.count > 1 ? "services" : "service"
  #     offerings_verb = @offerings.count > 1 ? "are" : "is"
  #   else
  #     offerings_count = "no"
  #     offerings_str = "services"
  #     offerings_verb = "are"
  #   end

  #   # State
  #   # Depends on if the request came from the landing page or from
  #   # filter_result ajax function
  #   if params[:select_state].present?
  #     state_id = params[:select_state].to_i
  #   elsif params[:state].present?
  #     state_id = params[:state].to_i
  #   end

  #   if state_id.present? && state_id != 0
  #     state = State.find(state_id)
  #     state = " #{state.name}"
  #   elsif @autoselected_state.present?
  #     state = " #{@autoselected_state.name}"
  #   end

  #   # Check if the practice area is selected for
  #   # filtering offers
  #   if @offerings_practice_area.present?
  #     "There #{offerings_verb} #{offerings_count} <strong>#{@offerings_practice_area.name.downcase}</strong>-related #{state} #{offerings_str} that may be of interest to you.".html_safe
  #   else
  #     "There #{offerings_verb} #{offerings_count} #{state} #{offerings_str} that may be of interest to you."
  #   end
  # end

  # def selected_lawyers_caption
  #   state = ""
  #   area = ""
  #   speciality = ""

  #   # Lawyers count
  #   if @lawyers.present?
  #     lawyers_count = @lawyers.count.to_s
  #     lawyers_str = @lawyers.count > 1 ? "lawyers" : "lawyer"
  #     lawyers_verb = @lawyers.count > 1 ? "are" : "is"
  #   else
  #     lawyers_count = "no"
  #     lawyers_str = "lawyers"
  #     lawyers_verb = "are"
  #   end

  #   if state_id.present? && state_id != 0
  #     state = State.find(state_id)
  #     state = " #{state.name}"
  #   elsif @autoselected_state.present?
  #     state = " #{@autoselected_state.name}"
  #   end

  #   # Practice area
  #   if params[:select_pa].present?
  #     area_id = params[:select_pa].to_i
  #   elsif params[:pa].present?
  #     area_id = params[:pa].to_i
  #   end

  #   if area_id.present? && area_id != 0
  #     area = PracticeArea.find(area_id)
  #     area = " #{area.name.downcase}"
  #   end

  #   # Speciality
  #   if params[:select_sp].present?
  #     speciality_id = params[:select_sp].to_i
  #   elsif params[:sp].present?
  #     speciality_id = params[:sp].to_i
  #   end

  #   if speciality_id.present? && speciality_id != 0
  #     speciality = PracticeArea.find(speciality_id)
  #     speciality = " on #{speciality.name.downcase}"
  #   end

  #   if lawyers_count
  #     "There #{lawyers_verb} #{lawyers_count}#{state}#{area} #{lawyers_str} who can offer you legal advice#{speciality} right now."
  #   end
  # end

  def practice_areas_listing(lawyer)
    areas = lawyer.practice_areas.parent_practice_areas unless lawyer.practice_areas.blank?
    areas_names = areas.map do |area|
      area.name.downcase
    end

    last_area_name = areas_names.pop
    areas_names.empty? ? last_area_name : "#{areas_names.join(', ')} and #{last_area_name}"
  end

  def bar_memberships_listing lawyer
    output = ''
    bms = lawyer.bar_memberships
    if bms.present?
      bms_text = '<h2>Bar Memberships: </h3>'
      bms.each do |bm|
        bar = bm.bar_id? ? "(Bar ID: #{bm.bar_id})" : ""
        bms_text += "<li>#{bm.state.name} #{bar}</li>" if bm.state
      end
      output = "<div id='div_states_barids'><ul class='tick'>#{bms_text}</ul></div>"
      output += '<a href="#bar_membership" id="barids_editor" class="dialog-opener"> Edit</a>'
    end  
    output.html_safe
  end  

  def free_message lawyer
    # if !lawyer.is_online && lawyer.phone.present?
    #   msg = "two minutes free, then:"
    # else
    #   msg = "free consultation, then:"
    # end
    "#{lawyer.free_consultation_duration} minutes free"
  end

  def start_or_schedule_button(lawyer)
    if lawyer.is_online && !lawyer.is_busy
      if logged_in?
        link_to "Chat now by video conference", user_chat_session_path(lawyer), :class => ''
      else
        link_to "Chat now by video conference", new_client_path(notice: true, return_path: user_chat_session_path(lawyer)), :class => ''
      end
    else
      if lawyer.is_available_by_phone?
        if logged_in?
          if current_user.stripe_customer_token.present?
            link_to "Chat now by phone", phonecall_path(:id => lawyer.id), :id => "start_phone_session_button", :data => { :l_id => lawyer.id, :fullname => lawyer.first_name }, :class => ""
          else
            # link_to "start phone consultation", "#paid_schedule_session", :id => "start_phone_session_button", :data => { :attorneyid => lawyer.id, :fcd => lawyer.free_consultation_duration, :lrate => lawyer.rate, :fullname => lawyer.first_name },:class => "dialog-opener "
            link_to "Chat now by phone", call_payment_path(lawyer.id), :id => "start_phone_session_button", :class => ""
          end
        else
          link_to 'Start phone consultation', new_client_path(notice: true, return_path: phonecall_path(:id => lawyer.id), lawyer_path: lawyer.id), :class => ''
        end
      else
        if lawyer.daily_hours.present?
          link_to "Schedule an appointment", "#schedule_session", :id => "schedule_session_button", :data => { :l_id => lawyer.id, :fullname => lawyer.first_name }, :class => "dialog-opener "
        else
          if logged_in?
            link_to "Ask a question", "#schedule_session", :id => "schedule_session_button", :data => { :l_id => lawyer.id, :fullname => lawyer.first_name }, :class => "dialog-opener "
          else
            link_to "Ask a question", new_client_path(notice: true, return_path: attorney_path(lawyer, slug: lawyer.slug), lawyer_path: lawyer.id), :class => ''
          end
        end
      end
      
    end
  end

  def start_or_schedule_button_text(lawyer)
    if logged_in?
      link_to "Ask a question", "#schedule_session", :id => "schedule_session_button", :data => { :l_id => lawyer.id, :fullname => lawyer.first_name }, :class => "dialog-opener "
    else
      link_to "Ask a question", new_client_path(notice: true, return_path: attorney_path(lawyer, slug: lawyer.slug), lawyer_path: lawyer.id), :class => ''
    end
  end


  def start_or_schedule_button_text_profile(lawyer)
    if logged_in?
      link_to "", "#schedule_session", :id => "schedule_session_button", :data => { :l_id => lawyer.id, :fullname => lawyer.first_name }, :class => "dialog-opener "
    else
      link_to "", new_client_path(notice: true, return_path: attorney_path(lawyer, slug: lawyer.slug), lawyer_path: lawyer.id), :class => ''
    end
  end

  def start_or_schedule_button_text_profile_text(lawyer)
    if logged_in?
      link_to "Send a note or ask a question", "#schedule_session", :id => "schedule_session_button", :data => { :l_id => lawyer.id, :fullname => lawyer.first_name }, :class => "dialog-opener "
    else
      link_to "Send a note or ask a question", new_client_path(notice: true, return_path: attorney_path(lawyer, slug: lawyer.slug), lawyer_path: lawyer.id), :class => ''
    end
  end

  def start_video_button(lawyer)
    if lawyer.is_online && !lawyer.is_busy
      if logged_in?
        link_to "Chat now by video conference", user_chat_session_path(lawyer), :title => "Chat now by video conference", :class => ''
      else
        link_to "Chat now by video conference", new_client_path(notice: true, return_path: user_chat_session_path(lawyer)), :title => "Chat now by video conference", :class => ''
      end
   end
  end

  def start_or_video_button_p(lawyer)
    if lawyer.is_online && !lawyer.is_busy
      if logged_in?
        link_to "", user_chat_session_path(lawyer), :class => ''
      else
        link_to "", new_client_path(notice: true, return_path: user_chat_session_path(lawyer), lawyer_path: lawyer.id), :class => ''
      end
   end
  end

  def start_or_video_button_profile(lawyer)
    if lawyer.is_online && !lawyer.is_busy
      if logged_in?
        link_to "Start free video consultation", user_chat_session_path(lawyer), :class => ''
      else
        link_to "Start free video consultation", new_client_path(notice: true, return_path: user_chat_session_path(lawyer), lawyer_path: lawyer.id), :class => ''
      end
   end
  end


 def start_phone_consultation(lawyer)
   if logged_in?
      link_to "Start phone consultation", phonecall_path(:id => lawyer.id), :id => "start_phone_session_button", :data => { :l_id => lawyer.id, :fullname => lawyer.first_name }, :class => ""
  else
    link_to 'Start phone consultation', new_client_path(notice: true, return_path: phonecall_path(:id => lawyer.id), lawyer_path: lawyer.id), :class => ""
  end
 end

 def start_phone_consultation_p(lawyer)
    if logged_in?

       link_to "", phonecall_path(:id => lawyer.id), :id => "start_phone_session_button", :data => { :l_id => lawyer.id, :fullname => lawyer.first_name }, :class => ""
   else
     link_to "", new_client_path(notice: true, return_path: phonecall_path(:id => lawyer.id), lawyer_path: lawyer.id), :class => ""
   end
 end

 def start_phone_consultation_profile(lawyer)
    if logged_in?
      link_to "Start free phone consultation", phonecall_path(:id => lawyer.id), :id => "start_phone_session_button", :data => { :l_id => lawyer.id, :fullname => lawyer.first_name }, :class => ""
   else
     link_to "Start free phone consultation", new_client_path(notice: true, return_path: phonecall_path(:id => lawyer.id), lawyer_path: lawyer.id), :class => ""
   end
 end

 def start_phone_consultation_path(lawyer)
    if logged_in?
       phonecall_path(lawyer)
   else
     new_client_path(:notice => true, :return_path => phonecall_path(lawyer))
   end
 end

 def status_message(lawyer)
   if lawyer.is_online
     "online now"
 elsif lawyer.is_available_by_phone?
     "available by phone now"
   end
 end

 def years_practicing_law(lawyer)
   if lawyer.license_year.present? && lawyer.license_year != 0
     Time.now.year.to_i - lawyer.license_year.to_i + 1
   end
 end
  
  def selected_lawyers_caption
    is_are = @search.total == 1 ? "is " : "are "
    ct = @search.total == 0 ? "no " : "#{@search.total} "
    lawyers_string = @search.total == 1 ? "lawyer" : "lawyers"

    return "There #{is_are}#{ct}#{selected_state_string}" +
      "#{parent_practice_area_string}#{lawyers_string} " +
      "who can offer you legal advice #{child_practice_area_string}" +
      "right now."
  end

  def selected_offerings_caption
    is_are = @offerings.count == 1 ? "is" : "are"
    ct = @offerings.count == 0 ? "no" : @offerings.count.to_s
    service_string = @offerings.count == 1 ? "service" : "services"
    parent_practice_area_string = params[:practice_area] if !!params[:practice_area] && params[:practice_area]!='All'
    return "There #{is_are} #{ct}#{selected_state_string}" +
      " #{parent_practice_area_string} #{service_string} " +
      "that may be of interest to you."
  end

  def selected_state_string
    @selected_state.present? ? "#{@selected_state.name} " : ""
  end

  def parent_practice_area_string
    if params[:practice_area].present? && params[:practice_area] != "All"
      return "#{params[:practice_area]} ".downcase
    else
      return ""
    end
  end

  def child_practice_area_string
    return "" unless @selected_practice_area.present?
    return "" unless @selected_practice_area.parent_name.present?
    return "on #{@selected_practice_area.name.downcase} "
  end

  def tooltips lawyer
    output = ''
    if lawyer.is_online
      output << '<div class="video_chat online tooltip dominant"> Start video consultation</div>'
    else
      output << '<div class="video_chat offline tooltip"> Not available by video now</div>'
    end  
    if lawyer.is_available_by_phone?
      output << "<div class='voice_chat online tooltip#{lawyer.is_online ? '' : ' dominant'}'> Start phone consultation</div>"
    else
      output << '<div class="voice_chat offline tooltip"> Not available by phone now</div>'
    end  
    if lawyer.daily_hours.present?
      output << "<div class='text_chat online tooltip#{lawyer.is_online || lawyer.is_available_by_phone? ? '' : ' dominant'}'> Schedule consultation</div>"
    else
      output << '<div class="text_chat offline tooltip">No appointments available</div>'
    end  
    output << "<div class='note_chat tooltip#{lawyer.is_online || lawyer.is_available_by_phone? || lawyer.daily_hours.present? ? '' : ' dominant'}''> Ask a question</div>"
    output.html_safe
  end  

  def pluralize_without_count(count, noun, text = nil)
    if count != 0
      count == 1 ? "#{noun}#{text}" : "#{noun.pluralize}#{text}"
    end
  end
end

