class Inquiry < ActiveRecord::Base
  belongs_to :question
  has_many :bids

  scope :opened, where(is_closed: false)

  def expiration(date_part)
    case date_part.to_sym
    when :year
      expired_at.year
    when :month
      expired_at.month.to_i - 1
    when :day
      expired_at.day
    when :hours
      expired_at.strftime("%k")
    when :minutes
      expired_at.strftime("%M").to_i
    when :seconds
      expired_at.strftime("%S").to_i
    else
      expired_at
    end
  end

  def expired_at
    self.created_at + 12.hours
  end

  def expired?
    Time.now > self.expired_at
  end

  def minimum_bid
    if bids.any? && bids.count > 2
      bids[-3].amount + 1
    else
      1
    end
  end

  def winners
    winners = []
    bids.reverse_order.limit(3).each do |bid|
      winners << bid.lawyer
    end

    winners
  end

  def charge_winners
    bids.reverse_order.limit(3).each do |bid|
      bid.charge
    end
  end

  def notify_admin
    if self.bids.any?
      UserMailer.closed_inquiry_notification(self).deliver
    end
  end

  def close
    update_attributes({ is_closed: true })
  end

  class << self
    def close_expired
      Inquiry.opened.each do |inquiry|
        if inquiry.expired?
          inquiry.charge_winners
          inquiry.notify_admin
          inquiry.close
        end
      end
    end
  end
end
