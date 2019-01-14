class QuestionsController < ApplicationController
  def create
    @question = Question.new(params[:question])
    @question.state_name = params[:question][:state_name] if params[:question][:state_name].present?
    @question.practice_area = params[:question][:practice_area] if params[:question][:practice_area].present?
    @question.save

    UserMailer.new_question_email(@question).deliver

    if logged_in?
      respond_to :js
    else
      session[:question_id] = @question.to_param
      redirect_to new_client_path(question_notice: true)
    end
  end

  def update
    @question = Question.find(params[:id])
    @question.update_attributes(params[:question])

    respond_to :js
  end

end
