# app/controllers/replies_controller.rb
class RepliesController < ApplicationController
  before_action :authenticate_user!
  
  
  def index
     @requests = Request.all.order(created_at: :desc)
   end

   def new
     @request = Request.new
   end
   

def create
    @request = current_user.requests.build(request_params)
        if @request.save
          redirect_to requests_path, notice: "募集を作成しました"
        else
          render :new
        end
    
    
  @offer = Offer.find(params[:offer_id])
  @reply = @offer.replies.build(reply_params.merge(user: current_user))

  Rails.logger.info "=== Saving Reply to Offer ##{@offer.id} ==="
  Rails.logger.info "=== reply_params: #{reply_params.inspect} ==="
  Rails.logger.info "=== current_user: #{current_user.inspect} ==="

  if @reply.save
    Rails.logger.info "=== Reply Saved Successfully ==="
    redirect_to item_path(@offer.item), notice: "返信しました"
  else
    Rails.logger.error "=== Reply Save Failed ==="
    Rails.logger.error @reply.errors.full_messages
    redirect_to item_path(@offer.item), alert: "返信に失敗しました"
  end
end


  private

  def reply_params
    params.require(:reply).permit(:title, :description)
  end
end
