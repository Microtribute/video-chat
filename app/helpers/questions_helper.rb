module QuestionsHelper
  def auto_detected_state
    if request.location.present? && request.location.state_code.present?
      state = State.find_by_abbreviation(request.location.state_code)
      state ? state.name : "Not specified"
    end
  end
end
