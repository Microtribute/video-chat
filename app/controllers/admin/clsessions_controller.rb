class Admin::ClsessionsController < ApplicationController

  before_filter :authenticate_admin

  def index
    @conversations = Conversation.all
  end

end

