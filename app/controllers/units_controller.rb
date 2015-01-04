class UnitsController < ApplicationController
  before_action :set_unit, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @units = Unit.all
    respond_with(@units)
  end

  def show
    respond_with(@unit)
  end

  def new
    @unit = Unit.new
    render layout: false
  end

  def edit
    render layout: false
  end

  def create
    @unit = Unit.new(unit_params)
    if @unit.save
      @units = Unit.all
      render 'index'
    else
      respond_with(@unit)
    end
  end

  def update
    @unit.update(unit_params)
    @units = Unit.all
    render 'index'
  end

  def destroy
    @unit.destroy
    respond_with(@unit)
  end

  private
    def set_unit
      @unit = Unit.find(params[:id])
    end

    def unit_params
      params.require(:unit).permit(:name, :abbrev)
    end
end
