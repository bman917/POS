class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to users_path, notice: 'User was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user }
        format.js
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
        format.js { render 'error'}
      end
    end
  end

  def edit
  end



  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_path, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def activate
    status_change { |user| user.status = 'Active' }
  end

  def disable
    status_change { |user| user.status = 'Disabled' }
  end

  def destroy
    status_change { |user| user.status = 'Deleted' }
  end

  private
    def status_change
      unless (@user.username == "Admin" || @user.id == current_user.id)
        yield @user
        @user.save
      end
      respond_to do |format|
        format.html { redirect_to users_url }
        format.json { head :no_content }
        format.js
      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:role, :username, :email, :password, :status)
    end
end
