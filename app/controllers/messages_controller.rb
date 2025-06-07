# app/controllers/messages_controller.rb
class MessagesController < ApplicationController
  before_action :set_message, only: %i[ show ]

  # GET /messages
  # ルートメッセージ（parent_id: nil）のみを一覧表示
  def index
    @root_messages = Message.where(parent_id: nil).order(created_at: :desc)
    @new_message   = Message.new
  end

  # POST /messages
  # 新規メッセージ or リプライを保存
  def create
    @message = Message.new(message_params)
    if @message.save
      redirect_to messages_path, notice: "メッセージを投稿しました。"
    else
      # 失敗時は index に戻す。バリデーションエラーを出す想定
      @root_messages = Message.where(parent_id: nil).order(created_at: :desc)
      @new_message   = @message
      render :index, status: :unprocessable_entity
    end
  end

  private

  def set_message
    @message = Message.find(params[:id])
  end

  def message_params
    # parent_id が空文字列の場合は nil になるよう to_i を活用
    params.require(:message).permit(:content, :parent_id)
  end
end
