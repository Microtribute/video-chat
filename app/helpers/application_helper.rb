module ApplicationHelper
  def notice(*args)
    options = args.extract_options!

    unless options[:avatar].present?
      render partial: "notice", locals: { text: options[:text], avatar: false }
    else
      dimensions = Paperclip::Geometry.from_file(options[:avatar].to_file(:thumb)) rescue nil
      render partial: "notice", locals: {
        text: options[:text],
        avatar: options[:avatar].url(:thumb),
        width: 40,
        height: (dimensions.height * (40 / dimensions.width)).round
      } if dimensions
    end
  end

  # is there a current_user
  # this is here to help with stubbing on tests as well
  def logged_in?
    controller.logged_in?
  end
  # here for stubbing purposes
  def current_user
    controller.current_user
  end
  # classes on the bodyb element
  def body_classes
    parts = params.values_at(:controller, :action)
    parts << "logged-in" if self.logged_in?
    parts.compact
  end

  def is_self_login? user_id
    current_user.id == user_id
  end

  def is_admin_login?
    current_user.is_admin?
  end

  def access_to_everything? user_id
    is_self?(user_id) or is_admin_login?
  end

  def seconds_in_string num_of_seconds
    n_sec = num_of_seconds.to_i
    t_str = ""
    if n_sec < 60
      t_str = ["00", "00" , n_sec.to_s.rjust(2, "0")].join(":")
    elsif
      hours = n_sec / 3600
      rem   = n_sec % 3600
      min   = rem / 60
      rem   = rem % 60
      t_str = [ hours.to_s.rjust(2,"0"), min.to_s.rjust(2,"0"), rem.to_s.rjust(2,"0") ].join(":")
    end
    t_str
  end

  def title(page_title)
    content_for :title do
      page_title
    end
  end

  def logo_url
    if current_user
      if current_user.is_lawyer?
        link_to image_tag("logo.png", :alt => 'Lawdingo'), user_path(current_user, :t=>'l'), :title=>'Home', :class => 'home-link'
      else
        link_to image_tag("logo.png", :alt => 'Lawdingo'), lawyers_path, :title=>'Home', :class => 'home-link'
      end
    else
      link_to image_tag("logo.png", :alt => 'Lawdingo'), root_path, :title=>'Home', :class => 'home-link'
    end
  end

end

