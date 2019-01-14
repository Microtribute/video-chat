class HomepageImage < ActiveRecord::Base
  belongs_to :lawyer

  has_attached_file :photo,
    :path => "homepage_images/:attachment/:id/:style_:basename.:extension",
    :styles => {:large  => "437x295"},
    :storage => :s3,
    :s3_protocol => "https",
    :s3_credentials => "#{Rails.root}/config/s3.yml"
end

