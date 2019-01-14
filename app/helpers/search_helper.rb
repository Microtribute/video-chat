module SearchHelper

  def get_homepage_images_hash images
    list = []
    images.each do |image|
      lawyer = image.lawyer
      practice_area_text = "Advising on #{lawyer.practice_areas_listing} law. " unless lawyer.parent_practice_area_string.empty?
      images_hash = Hash.new
      images_hash["free"] = "/attorneys/#{lawyer.id}/#{CGI::escape(lawyer.full_name)}"
      images_hash["url"] = image.photo.url(:large)
      images_hash["title"] = "<a href='/attorneys/#{lawyer.id}/#{lawyer.slug}'>#{lawyer.full_name}</a>".html_safe
      images_hash["description"] = practice_area_text # + "#{lawyer.free_consultation_duration} minutes free consultation, then #{number_to_currency (lawyer.rate + AppParameter.service_charge_value)}/minute."
      images_hash["small"]="then #{number_to_currency (lawyer.rate + AppParameter.service_charge_value)}/minute"
      images_hash["rate"]="#{lawyer.free_consultation_duration} minutes free"
      star=[]  
      star[1]='off'
      star[2]='off'
      star[3]='off'
      star[4]='off'
      star[5]='off'
      a=lawyer.reviews.average(:rating).to_i
      a.times do |i|
        star[i+1]='on'
      end   
      if a != 0
        images_hash["rating"] = "<img src='/assets/raty/star-#{star[1]}.png' alt='1' title='not rated yet'>&nbsp;<img src='/assets/raty/star-#{star[2]}.png' alt='2' title='not rated yet'>&nbsp;<img src='/assets/raty/star-#{star[3]}.png' alt='3' title='not rated yet'>&nbsp;<img src='/assets/raty/star-#{star[4]}.png' alt='4' title='not rated yet'>&nbsp;<img src='/assets/raty/star-#{star[5]}.png' alt='5' title='not rated yet'>"
      else
        images_hash["rating"] = ""
      end
      if (lawyer.yelp_business_id.present? && !!lawyer.yelp[:reviews]) || lawyer.reviews.count.to_i > 0
        images_hash["test"] = true
        if lawyer.yelp_business_id.present? && !!lawyer.yelp[:reviews]
          images_hash["yelp_present"] = true
          images_hash["reviews"] = "#{lawyer.yelp[:review_count]} <a href='http://www.yelp.com'><img src='/assets/miniMapLogo.png' /></a> #{pluralize_without_count(lawyer.yelp[:review_count], "review")}".html_safe
          images_hash["link_reviews"] = "<a href='/attorneys/#{lawyer.id}/#{CGI::escape(lawyer.full_name)}#reviews' class = 'yelp_reviews'><span class = 'number_rev'></span></a>"
          images_hash["rating"] = "<img src='#{lawyer.yelp[:rating_img_url]}' />"
        else
          images_hash["reviews"] = pluralize(lawyer.reviews.count, "review", "reviews")
          images_hash["link_reviews"] = "<a href='/attorneys/#{lawyer.id}/#{CGI::escape(lawyer.full_name)}#reviews' class = 'reviews'><span class = 'number_rev'></span></a>"
        end
      end
      images_hash["href"] = attorney_path(lawyer, slug: lawyer.slug)
      images_hash["start_video_conversation"] = start_or_schedule_button(lawyer) if lawyer.is_online && !lawyer.is_busy
      images_hash["start_phone_conversation"] = start_phone_consultation(lawyer) if lawyer.is_available_by_phone?
      images_hash["start_or_video_button_p"] = start_or_video_button_p(lawyer) if lawyer.is_online
      images_hash["start_phone_consultation_p"] = start_phone_consultation_p(lawyer) if lawyer.is_available_by_phone?
      images_hash["send_text_question"]  = start_or_schedule_button_text(lawyer)
      images_hash["schedule_consultation"]  = "<a href='#' class='appt-select'></a>" if lawyer.daily_hours.present?
      images_hash["start_or_schedule_button_text_profile"] = start_or_schedule_button_text_profile(lawyer)
      images_hash["active_action"] = start_or_schedule_button(lawyer)   
      images_hash["appt"] = true if lawyer.daily_hours.present?
      list << images_hash
    end
    list
  end
end
