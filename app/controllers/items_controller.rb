class ItemsController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  def index
    if params[:user_id]
      user = find_by_user_id
      items = user.items
    else
      items = Item.all
    end
    render json: items, include: :user
  end

  def show
    item = Item.find(params[:id])
    render json: item, include: :user
  end

  def create # creating for a specific user
    user = find_by_user_id
    item = user.items.create!(item_params)
    render json: item, status: :created
  end

  private
  # refactoring
  def find_by_user_id
    User.find(params[:user_id])
  end

  def item_params
    params.permit(:name, :description, :price)
  end

  def render_not_found_response
    render json: { error: "Items Not Found" }, status: :not_found
  end

end
