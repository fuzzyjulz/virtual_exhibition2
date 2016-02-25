class ChatsController < ApplicationController
  respond_to :html, :json, :js
  responders :flash

  # GET /chats
  def index
    @chats = Chat.all
  end

  # GET /chats/1
  def show
  end

  # GET /chats/new
  def new
    @chat = Chat.new
  end

  # GET /chats/1/edit
  def edit
  end

  # POST /chats
  def create
    @chat = Chat.new(chat_params)
    if @chat.chattable_type == "Booth"
      booth = Booth.find(@chat.chattable_id)
      record_event(GaEvent.new(category: :booth, 
        action: ( booth.user == current_user ? :booth_owner_chat_message : :booth_chat_message)).booth(booth))
    end
    saved = @chat.save
    if saved
      @chat.new = true;
      sync_new @chat, scope: "#{request.host}|#{@chat.chattable_type}:#{@chat.chattable_id}"
    end
    respond_with @chat
  end

  # PATCH/PUT /chats/1
  def update
    saved = @chat.update(chat_params)
    sync_update @chat if saved
    respond_with @chat
  end

  # DELETE /chats/1
  def destroy
    @chat.destroy
    sync_destroy @chat
    respond_with(@chat)
  end

  def read_all_booth_user_chats
    Chat.read_all_booth_user_chats current_user.booths.first.id
  end

  private
    # Only allow a trusted parameter "white list" through.
    def chat_params
      params.require(:chat).permit(:from_user_id, :to_user_id, :message, :chattable_type, :chattable_id, :qna, :approved)
    end
end
