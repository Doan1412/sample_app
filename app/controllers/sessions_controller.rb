class SessionsController < ApplicationController
  def new; end

  def create
    user = find_user_by_email
    if user&.authenticate params.dig(:session, :password)
      handle_authenticated_user(user)
    else
      handle_invalid_login
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end

  private

  def find_user_by_email
    User.find_by(email: params.dig(:session, :email)&.downcase)
  end

  def handle_authenticated_user user
    if user.activated?
      log_in_user(user)
    else
      handle_unactivated_user
    end
  end

  def log_in_user user
    reset_session
    log_in user
    remember_or_forget user
    redirect_back_or user
  end

  def remember_or_forget user
    if params.dig(:session, :remember_me) == "1"
      remember(user)
    else
      forget(user)
    end
  end

  def handle_unactivated_user
    flash[:warning] = t "login.unactivated"
    redirect_to root_url, status: :see_other
  end

  def handle_invalid_login
    flash.now[:danger] = t "login.invalid"
    render :new, status: :unprocessable_entity
  end
end
