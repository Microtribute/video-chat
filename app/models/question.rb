class Question < ActiveRecord::Base
  attr_accessible :type, :user_id, :body, :state_name, :practice_area
  belongs_to :user
  has_one :inquiry

  after_create :create_inquiry

  set_inheritance_column :ruby_type

  def matched_lawyers
    state = State.where(name: self.state_name).first
    practice_area = PracticeArea.where(name: self.practice_area, parent_id: nil).first

    if state or practice_area
     search = Lawyer.search do
       with(:state_ids, state.id) if state.present?
       with(:practice_area_ids, practice_area.id) if practice_area.present?
     end

     search.results
    else
      # Return empty array when state and practice area aren't specified
      # so the question.matched_lawyers.count will return 0 in
      # matched_lawyer_count helper
      []
    end
  end

  private

  def create_inquiry
    Inquiry.create(question_id: self.id)
  end
end
