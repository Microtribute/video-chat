module Admin::QuestionsHelper
  def matched_lawyers_count(question)
    if question.matched_lawyers.count > 0
      question.matched_lawyers.count
    else
      Lawyer.approved_lawyers.count
    end
  end

end
