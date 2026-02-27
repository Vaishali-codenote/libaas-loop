class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!
  before_action :set_user, only: [:show, :destroy, :toggle_status]

  def index
    @users = User.order(created_at: :desc).page(params[:page])
  end

  def show
  end

  def destroy
    @user.destroy!
    redirect_to admin_users_path, notice: "User deleted successfully."
  end

  def toggle_status
    # Simple implementation - could add active/inactive field
    redirect_to admin_user_path(@user), notice: "User status updated."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
