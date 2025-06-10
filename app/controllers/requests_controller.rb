class RequestsController < ApplicationController
  before_action :authenticate_user!

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
    @request = current_user.requests.build(request_params)
    if @request.save
      redirect_to requests_path, notice: "募集を作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def request_params
    params.require(:request).permit(:title, :description)
  end
end
