class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  respond_to :html, :js

  def index
    @categories = Category.all
  end

  def show
    respond_with(@category)
  end

  def new
    @category = Category.new
    render layout: false
  end

  def edit
    render layout: false
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      @categories = Category.all
      render 'index'
    else
      respond_with(@category)
    end
  end

  def update
    @category.update(category_params)
    @categories = Category.all
    render 'index'
  end

  def destroy
    @category.destroy
    respond_with(@category)
  end

  private
    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name)
    end
end
