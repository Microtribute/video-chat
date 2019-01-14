class User < ActiveRecord::Base
  ADMIN_TYPE  = 'Admin'
  CLIENT_TYPE = 'Client'
  LAWYER_TYPE = 'Lawyer'
  ACCOUNT_TAB = 'f'
  PAYMENT_TAB = 'm'
  SESSION_TAB = 'l'
  PFOFILE_TAB = 'profile'

  self.inheritance_column = "user_type"

  # Validate free consultation duration only if it's lawyer signing up
  validates_presence_of :free_consultation_duration, :if => :is_lawyer?

  validates :first_name, :last_name, :user_type, :rate, :email, :presence => true
  validates_uniqueness_of :email
  validates :email, :email_format => true
  validates :password, :presence => { :on => :create }
  validates_format_of :phone, :with => /^[+0-9\(\)\-,\s]+$/, :allow_blank => true

  attr_accessor :password, :password_confirmation
  #attr_accessible :email, :password, :password_confirmation

  has_many :offerings
  has_many :questions
  has_many :searches
  
  belongs_to :school,
    :touch => true

  has_attached_file :photo,
    :styles => { :medium => "253x253>", :thumb => "102x127>" },
    :storage => :s3,
    :s3_credentials => "#{Rails.root}/config/s3.yml",
    :s3_protocol => "https",
    :path => "system/:attachment/:id/:style/:basename.:extension"

  before_save :normalize_name
  after_update :reindex_lawyer!, :if => :is_lawyer?

  def normalize_name
    self.first_name = self.first_name.squish.downcase.titleize if self.first_name
    self.last_name = self.last_name.squish.downcase.titleize if self.last_name
  end

  def reindex_lawyer!
    self.reindex!
  end  

  def self.authenticate email, password
    user = User.find_by_email(email)
    if user
      user = user.hashed_password == Digest::SHA1.hexdigest(password) ? user : nil
    end
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  def is_admin?
    self[:user_type] == self.class::ADMIN_TYPE
  end

  def is_client?
    self[:user_type] == self.class::CLIENT_TYPE
  end

  def save_stripe_customer_id token_id
    status = false
    if self.update_attribute(:stripe_customer_token, token_id)
      status = true
    end
    status
  end

  def get_stripe_customer_id
    self.stripe_customer_token
  end

  def slug
    lawyer = Lawyer.find(self.id)
    "#{lawyer.full_name.parameterize}"
  end

  def is_lawyer?
    self[:user_type] == self.class::LAWYER_TYPE
  end

  def detail
    {
      "First Name" => self.first_name,
      "Last Name" => self.last_name,
      "Email" => self.email
    }
  end

  def password=(value)
    unless value.blank?
      self.hashed_password = Digest::SHA1.hexdigest(value)
    end
  end

  def password
    self.hashed_password
  end

  def self.get_lawyers
    Lawyer.order('id desc')
  end

  def self.get_clients
    Client.order('id desc')
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def has_video?
    video = Framey::Video.find_by_creator_id(self.id)
    video.present?
  end

  def yelp
    yelp_connection = Yelp::Connection.new
    yelp_connection.find_by_id(self.yelp_business_id)
  end

  def timezone_utc_offset
    ActiveSupport::TimeZone::new(self.time_zone).utc_offset / 3600 rescue 0
  end   

  def timezone_abbreviation
    ActiveSupport::TimeZone.find_tzinfo(self.time_zone).current_period.abbreviation.to_s  rescue ''
  end  
end
