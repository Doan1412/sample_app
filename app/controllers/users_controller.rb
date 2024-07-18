class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(show new create)
  before_action :set_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @pagy, @users = pagy User.all, items: Settings.users_per_page
  end

  def show
    @page, @microposts = pagy @user.microposts, items: Settings.page_10
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "sign_up.check_mail"
      redirect_to root_url, status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "user.update.success"
      redirect_to @user
    else
      flash.now[:danger] = t "user.update.failed"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "users.destroy.success"
    else
      flash[:danger] = t "users.destroy.failed"
    end
    redirect_to users_path
  end

  def following
    @title = t "follow.followings"
    @pagy, @users = pagy @user.following, items: Settings.page_10
    render :show_follow
  end

  def followers
    @title = t "follow.followers"
    @pagy, @users = pagy @user.followers, items: Settings.page_10
    render :show_follow
  end

  private
  def user_params
    params.require(:user).permit(*User::VALID_ATTRIBUTES)
  end

  def set_user
    @user = User.find_by(id: params[:id])
    return if @user

    flash[:danger] = t("users.not_found")
    redirect_to root_path
  end

  def correct_user
    return if current_user? @user

    flash[:danger] = t "users.error.not_correct_user"
    redirect_to root_path, status: :see_other
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end
end
