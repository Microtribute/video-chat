class BidsController < ApplicationController
  def create
    @bid = Bid.new(params[:bid])

    if @bid.save_with_payment
      UserMailer.new_bid_notification(@bid).deliver
      redirect_to @bid.inquiry, notice: "Your bid has been placed. We'll email you to let you know if you've been outbid or if you've won the right to contact this client."
    else
      redirect_to @bid.inquiry
    end
  end
end
