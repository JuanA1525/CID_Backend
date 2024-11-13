class Api::V1::MessagesController < ApplicationController
  before_action :set_message, only: [:show, :update, :destroy]

  def index
    messages = MessageService.index
    render json: messages.as_json(include: { message_recipients: { only: :user_id } })
  end

  def show
    render json: @message.as_json(include: { message_recipients: { only: :user_id } })
  end

  def create
    recipient_ids = params[:message][:recipient_ids]
    result = MessageService.create(message_params, recipient_ids)
    if result[:message]
      render json: result[:message].as_json(include: { message_recipients: { only: :user_id } }), status: result[:status]
    else
      render json: result[:errors], status: result[:status]
    end
  end

  def update
    result = MessageService.update(@message.id, message_params)
    if result[:message]
      render json: result[:message].as_json(include: { message_recipients: { only: :user_id } }), status: result[:status]
    else
      render json: result[:errors], status: result[:status]
    end
  end

  def destroy
    result = MessageService.destroy(@message.id)
    render json: { message: result[:message] }, status: result[:status]
  end

  def get_messages_by_user
    user_id = params[:user_id]
    messages = MessageService.get_messages_by_user(user_id)
    render json: messages.as_json(include: { message_recipients: { only: :user_id } })
  end

  private

  def set_message
    @message = MessageService.show(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Message not found" }, status: :not_found
  end

  def message_params
    params.require(:message).permit(:user_id, :content, :message_type)
  end
end