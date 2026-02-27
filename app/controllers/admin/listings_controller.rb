class Admin::ListingsController < Admin::BaseController
  before_action :set_listing, only: [:show, :edit, :update, :destroy, :approve, :reject]

  def new
    redirect_to admin_listings_path, alert: "Create listing from user panel."
  end

  def create
    redirect_to admin_listings_path, alert: "Create listing from user panel."
  end

  def index
    @listings = Listing.includes(:user).order(created_at: :desc).page(params[:page])
  end

  def show
    @rental_history = @listing.rentals.includes(:renter, :owner).order(created_at: :desc)
  end

  def edit; end

  def update
    if @listing.update(listing_params)
      redirect_to admin_listing_path(@listing), notice: "Listing updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def approve
    @listing.update!(approval_status: :approved)
    redirect_to admin_listing_path(@listing), notice: "Listing approved."
  end

  def reject
    @listing.update!(approval_status: :rejected, status: :unavailable)
    redirect_to admin_listing_path(@listing), notice: "Listing rejected."
  end

  def destroy
    @listing.destroy!
    redirect_to admin_listings_path, notice: "Listing deleted successfully."
  end

  private

  def set_listing
    @listing = Listing.find(params[:id])
  end

  def listing_params
    params.require(:listing).permit(:title, :description, :category, :price_per_day, :status, :approval_status, :image_name)
  end
end
