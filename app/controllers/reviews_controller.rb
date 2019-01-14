class ReviewsController < ApplicationController
  def new
    @review = Review.new
  end

  def create
    @review = Review.new(params[:review])
    @review.save

    respond_to :js
  end

end
