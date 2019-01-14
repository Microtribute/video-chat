module AttorneysHelper
  def yelp_review_posted_by(review)
    user_id = review["user"]["id"]
    user_name = review["user"]["name"]

    link_to_user = link_to user_name, "http://www.yelp.com/user_details?userid=#{user_id}"
    link_to_yelp = link_to "Yelp.com", "http://www.yelp.com"

    "Posted by #{link_to_user} on #{link_to_yelp}".html_safe
  end

  def yelp_review_excerpt(review, attorney)
    "#{review["excerpt"]} #{link_to "read more", "http://www.yelp.com/biz/#{attorney.yelp_business_id}#hrid:#{review["id"]}"}".html_safe
  end
end
