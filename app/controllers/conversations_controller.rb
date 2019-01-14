class ConversationsController < ApplicationController
  before_filter :authenticate, :except => [:create]
  protect_from_forgery :except =>[:create]
#  skip_before_filter :protect_from_frogery, :only =>[:create]

  def index
    @conversations = current_user.conversations
  end

  def new
    conversation = Conversation.create_conversation(params[:conversation])
    redirect_to conversation_summary_path(conversation)
  end

  # flash application calls this action
  # after completion it returns 0(in case of failure)
  # or
  # the id of the newly created conversation
  # then the flash redirects to the review page for this conversation
  def create
    lawyer = User.find(params[:lawyer_id])
    lawyer.update_attribute(:is_busy, false)
#    if params.has_key?("state")
#      params.update({"consultation_type" => "video"})
#    else
#      params.update({"consultation_type" => ""})
#    end
    params.update({"consultation_type" => "video"})
    conversation = Conversation.create_conversation(params)
    if current_user && current_user.is_client?
      redirect_to conversation_summary_path(conversation)
    else
      redirect_to users_path(:t=>'l')
    end
#    render :text => conversation ? conversation.id.to_s : "0"
  end

  def review
    begin
      @conversation = Conversation.find params[:conversation_id]
    rescue
      @conversation = nil
    end
  end

  def summary
    @conversation = Conversation.find(params[:conversation_id])
    @lawyer = @conversation.lawyer
    @review = @conversation.reviews.new
  end

end

