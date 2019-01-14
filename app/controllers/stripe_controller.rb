class StripeController < ApplicationController

	before_filter :authenticate
    force_ssl

	def subscribe_lawyer
		redirect_to root_path, :status => :unauthorized unless current_user.is_lawyer?
		@lawyer = current_user
		if request.put? && params[:lawyer][:stripe_card_token].present?
			if @lawyer.save_with_payment params[:lawyer][:stripe_card_token]
			    redirect_to user_offerings_path(@lawyer, :ft => true), :notice => "Thank you for subscribing!"
			else
				flash[:notice] = "Error. Something wrong."
			end
		end
	end
end
