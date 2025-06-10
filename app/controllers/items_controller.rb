class ItemsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_item, only: %i[ show edit update destroy ]
  before_action :authorize_item!, only: %i[ edit update destroy ]
  
  
  def my
    @items = current_user.items.order(created_at: :desc)
    render :index  # index と同じビューを再利用してもOK
  end

  def index
    @items = Item.all
  end

def show
  @item = Item.find(params[:id])
  @offers = @item.offers.includes(:offered_by, replies: :user)
end


  def new
    @item = Item.new
  end

  def edit
  end

  def create
    @item = current_user.items.build(item_params)

    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: "Item was successfully created." }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to @item, notice: "Item was successfully updated." }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def confirm_destroy
      end

  def destroy
    @item.destroy!

    respond_to do |format|
      format.html { redirect_to items_path, status: :see_other, notice: "アイテムの削除が完了しました." }
      format.json { head :no_content }
    end
  end

  private

    def set_item
      @item = Item.find(params[:id])
    end

    def item_params
        params.require(:item).permit(:title, :description, :status, :image)
           end

           def authorize_item!
             redirect_to items_path, alert: "権限がありません。" unless @item.user == current_user
    end
end
