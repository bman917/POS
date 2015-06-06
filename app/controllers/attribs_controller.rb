class AttribsController < ApplicationController
  before_action :set_attrib, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def list
    @attribs = Attrib.active
    render layout: false
  end

  def index
    @attribs = Attrib.active
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
      render_index
    else
      respond_with(@attrib)
    end
  end

  def update
    @attrib.update(attrib_params)
    @attribs = Attrib.active
    render 'index'
  end

  def destroy
    unless @attrib.destroy
      flash[:error] = "Unable to delete #{@attrib.name} attribute. #{@attrib.errors.full_messages.join(',')}"
    end
    render_index
  end

  private
    def render_index
      @attribs = Attrib.active
      render 'index'
    end

    def set_attrib
      @attrib = Attrib.find(params[:id])
    end

    def attrib_params
      params.require(:attrib).permit(:name, :display_number)
    end
end
