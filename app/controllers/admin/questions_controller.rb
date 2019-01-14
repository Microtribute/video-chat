class Admin::QuestionsController < ApplicationController
  def index
    @questions = Question.where("user_id IS NOT NULL").order("created_at DESC")
  end

  def show
    @question = Question.find(params[:id])
  end

  def send_inquiry
    @is_free = params[:is_free] == "true" ? true : false
    @question = Question.find(params[:question_id])

    if @is_free
      @question.matched_lawyers.each do |lawyer|
        UserMailer.free_inquiry_email(@question, lawyer).deliver
      end

      render text: "sent", layout: false
    else
      @question.matched_lawyers.each do |lawyer|
        UserMailer.auction_inquiry_email(@question, lawyer).deliver
      end

      render text: "sent", layout: false
    end
  end

end
