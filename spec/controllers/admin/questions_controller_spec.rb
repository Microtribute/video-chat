require 'spec_helper'

describe Admin::QuestionsController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "returns http success" do
      pending "routing error?"
      get 'show'
      response.should be_success
    end
  end

  describe "GET 'send'" do
    it "returns http success" do
      pending "routing error?"
      get 'send'
      response.should be_success
    end
  end

end
