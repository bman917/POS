class DeliveriesController < ApplicationController
  before_action :set_delivery, only: [:show, :edit, :update, :destroy]

  respond_to :html, :js

  def index
    delivery_list
    respond_with(@deliveries)
  end

  def show
    respond_with(@delivery)
  end

  def new
    @delivery = Delivery.new(
      date: Date.today,
      supplier_id: params[:supplier_id])
    @delivery.save
    
    respond_to do | format |
      format.html
      format.js
    end

  end

  def edit
  end

  def create
    @delivery = Delivery.new(delivery_params)
    @delivery.save
    respond_with(@delivery)
  end

  def update
    @delivery.update(delivery_params)
    respond_with(@delivery)
  end

  def destroy
    @delivery.destroy
    respond_with(@delivery)
  end

  private
    def set_delivery
      @delivery = Delivery.find(params[:id])
    end

    def delivery_params
      params.require(:delivery).permit(:date, :supplier_id, :supplier_dr_number, :notes)
    end
end
