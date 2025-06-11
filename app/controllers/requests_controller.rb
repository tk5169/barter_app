class RequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_request, only: [:destroy]
  
  
  def my
    @requests = current_user.requests.order(created_at: :desc)
  end

  # GET /requests
  def index
    @requests = Request.all.order(created_at: :desc)
  end

  # GET /requests/new
  def new
    @request = Request.new
  end

  # POST /requests
  def create
      params_req = request_params
      days = params_req.delete(:delete_after_days).to_i
      @request = current_user.requests.build(params_req)
      @request.expires_at = Time.current + days.days if days.positive?


    if @request.save
      redirect_to my_requests_path, notice: "募集を作成しました（#{days}日後に自動削除されます）"
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  
  def destroy
    # 自分のものだけ削除できるようにする場合
    if @request.user == current_user
      @request.destroy
      redirect_to my_requests_path, notice: "募集を削除しました。"
    else
      redirect_to my_requests_path, alert: "権限がありません。"
    end
  end

  private
  
  def set_request
    @request = Request.find(params[:id])
  end

  def request_params
    params.require(:request).permit(:title, :description, :image, :delete_after_days)
  end
end
