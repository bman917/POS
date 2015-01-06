class AttribsController < ApplicationController
  before_action :set_attrib, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def list
    @attribs = Attrib.all
    render layout: false
  end

  def index
    @attribs = Attrib.all
    respond_with(@attrib)
  end

  def show
    respond_with(@attrib)
  end

  def new
    @attrib = Attrib.new
    render layout: false
  end

  def edit
    render layout: false
  end

  def create
    @attrib = Attrib.new(attrib_params)
    if @attrib.save
      @attribs = Attrib.all
      render 'index'
    else
      respond_with(@attrib)
    end
  end

  def update
    @attrib.update(attrib_params)
    @attribs = Attrib.all
    render 'index'
  end

  def destroy
    @attrib.destroy
    respond_with(@attrib)
  end

  private
    def set_attrib
      @attrib = Attrib.find(params[:id])
    end

    def attrib_params
      params.require(:attrib).permit(:name, :display_number)
    end
end
