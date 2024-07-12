class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  def show
    attr_reader :@user
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t("welcome_msg")
      redirect_to @user
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.require(:user).permit(*User::VALID_ATTRIBUTES)
  end

  def set_user
    @user = User.find_by(id: params[:id])
    return if @user

    flash[:danger] = t("users.not_found")
  end
end
