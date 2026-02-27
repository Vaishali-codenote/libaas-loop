class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :block, :unblock, :promote]

  def new
    redirect_to admin_users_path, alert: "User creation is handled via public signup."
  end

  def create
    redirect_to admin_users_path, alert: "User creation is handled via public signup."
  end

  def index
    @users = User.order(created_at: :desc).page(params[:page])
  end

  def show
    @listings = @user.listings.order(created_at: :desc)
    @rentals = Rental.includes(:listing, :renter, :owner)
      .where("owner_id = :id OR renter_id = :id", id: @user.id)
      .order(created_at: :desc)
      .limit(20)
    @total_earnings = @user.total_earnings
  end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: "User updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def block
    @user.update!(blocked: true)
    redirect_to admin_user_path(@user), notice: "User blocked successfully."
  end

  def unblock
    @user.update!(blocked: false)
    redirect_to admin_user_path(@user), notice: "User unblocked successfully."
  end

  def promote
    @user.update!(role: :admin)
    redirect_to admin_user_path(@user), notice: "User promoted to admin."
  end

  def destroy
    if @user == current_user
      redirect_to admin_user_path(@user), alert: "You cannot delete yourself."
      return
    end

    @user.destroy!
    redirect_to admin_users_path, notice: "User deleted successfully."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :role, :blocked)
  end
end
