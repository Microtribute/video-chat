require 'spec_helper'

describe Question do
  DatabaseCleaner.clean

  it "creates an inquiry after saving new question" do
    @question = FactoryGirl.create(:question)
    @question.inquiry.should be_present
  end
end
