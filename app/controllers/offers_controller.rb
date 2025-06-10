class OffersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_offer, only: %i[show edit update destroy accept create_reply]

  # Only the user who made the offer can view/edit/update/destroy it
  before_action :authorize_offer_user!, only: %i[show edit update destroy]
  # Only the item owner can accept an offer
  before_action :authorize_item_owner!,  only: %i[accept]
  # Both the offerer and the item owner can reply
  before_action :authorize_offer_user_or_item_owner!, only: %i[create_reply]

  # GET /offers
  def index
    # IDs of items that the current user owns
    owned_item_ids = current_user.items.pluck(:id)
    # Offers the user made OR offers on the user's items
    @offers = Offer.where(offered_by: current_user)
                   .or(Offer.where(item_id: owned_item_ids))
  end

  # GET /offers/:id
  def show
    @replies = @offer.replies.includes(:user)
    @reply   = Reply.new
  end

  # GET /offers/new
  def new
    @offer = Offer.new
  end

  # POST /offers
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

  # GET /offers/:id/edit
  def edit
  end

  # PATCH/PUT /offers/:id
  def update
    if @offer.update(offer_params)
      redirect_to @offer, notice: "提案が更新されました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /offers/:id
  def destroy
    @offer.destroy!
    redirect_to offers_path, notice: "提案を削除しました。"
  end

  # POST /offers/:id/accept
  def accept
    Offer.transaction do
      @offer.update!(status: "accepted")
      @offer.item.offers.where.not(id: @offer.id).update_all(status: "rejected")
    end
    redirect_to item_path(@offer.item), notice: "提案を受け入れました。"
  end

  # POST /offers/:id/replies
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

  def authorize_offer_user!
    return if @offer.offered_by == current_user

    redirect_to offers_path, alert: "権限がありません。"
  end

  def authorize_item_owner!
    return if @offer.item.user == current_user

    redirect_to offers_path, alert: "権限がありません。"
  end

  def authorize_offer_user_or_item_owner!
    return if @offer.offered_by == current_user || @offer.item.user == current_user

    redirect_to offers_path, alert: "権限がありません。"
  end
end
