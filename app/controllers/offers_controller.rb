# app/controllers/offers_controller.rb
class OffersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_offer, only: %i[ show edit update destroy accept create_reply ]
  before_action :authorize_offer!, only: %i[ show edit update destroy accept create_reply ]

  # GET /offers
  def index
    # まず「自分が出品者として所有しているアイテムID の配列」を取得
    item_ids = current_user.items.pluck(:id)

    # 「自分が提案者(offered_by)」または「自分が出品者(item_id: item_ids)」の両方を or で結合
    @offers = Offer.where(offered_by: current_user)
                   .or(Offer.where(item_id: item_ids))
  end

  # 以下、show, new, create, edit, update, destroy, accept, create_reply はそのまま
  def show
    @replies = @offer.replies.includes(:user)
    @reply   = Reply.new
  end

  def new
    @offer = Offer.new
  end

  def create
    @offer = Offer.new(offer_params)
    @offer.offered_by = current_user
    @offer.status     = "pending"

    if @offer.save
      redirect_to offer_path(@offer), notice: "提案を送信しました。"
    else
      redirect_to items_path, alert: "提案に失敗しました。"
    end
  end

  def edit
  end

  def update
    if @offer.update(offer_params)
      redirect_to @offer, notice: "提案が更新されました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @offer.destroy!
    redirect_to offers_path, notice: "提案を削除しました。"
  end

  def accept
    Offer.transaction do
      @offer.update!(status: "accepted")
      @offer.item.offers.where.not(id: @offer.id).update_all(status: "rejected")
    end
    redirect_to item_path(@offer.item), notice: "提案を受け入れました。"
  end

  def create_reply
    @reply = @offer.replies.build(reply_params.merge(user: current_user))

    if @reply.save
      redirect_to offer_path(@offer), notice: "返信を送信しました！"
    else
      flash.now[:alert] = "返信の投稿に失敗しました。"
      @replies = @offer.replies.includes(:user)
      render :show, status: :unprocessable_entity
    end
  end

  private

  def set_offer
    @offer = Offer.find(params[:id] || params[:offer_id])
  end

  def offer_params
    params.require(:offer).permit(:item_id, :offered_item_text)
  end

  def reply_params
    params.require(:reply).permit(:body)
  end

  def authorize_offer!
    unless @offer.offered_by == current_user || @offer.item.user == current_user
      redirect_to offers_path, alert: "権限がありません。"
    end
  end
end
