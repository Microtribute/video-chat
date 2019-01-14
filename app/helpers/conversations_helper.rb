module ConversationsHelper
  def conversation_summary_form
    if params[:form].present?
      form = params[:form].to_s
    else
      form = "review"
    end

    if form == "review"
      "reviews/form"
    elsif form == "report"
      "no_answer"
    end
  end
end
