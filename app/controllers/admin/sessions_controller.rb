class Admin::SessionsController < ApplicationController
  layout "application"

  def new
    redirect_to admin_dashboard_path, notice: "Already signed in as admin." if user_signed_in? && current_user.admin?
  end

  def create
    user = User.find_for_authentication(email: params[:email])

    if user&.valid_password?(params[:password]) && user.admin? && !user.blocked?
      sign_in(:user, user)
      redirect_to admin_dashboard_path, notice: "Welcome to admin dashboard."
    else
      flash.now[:alert] = "Invalid admin credentials."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    sign_out(current_user) if user_signed_in?
    redirect_to root_path, notice: "Logged out successfully."
  end
end
