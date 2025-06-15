class RepliesController < ApplicationController
  before_action :authenticate_user!

  def create
    @offer = Offer.find(params[:offer_id])
    @reply = @offer.replies.build(reply_params.merge(user: current_user))

    if @reply.save
      redirect_to item_path(@offer.item), notice: "返信しました"
    else
      redirect_to item_path(@offer.item), alert: "返信に失敗しました"
    end
  end

  private

  def reply_params
    params.require(:reply).permit(:body)
  end
end
