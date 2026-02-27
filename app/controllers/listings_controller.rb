class ListingsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_listing, only: [:show, :edit, :update, :destroy]

  def index
    @listings = Listing.includes(:user).where(status: :available).all
    @categories = Listing.select(:category).distinct.pluck(:category)
  end

  def show
    @rental = Rental.new
  end

  def new
    @listing = Listing.new
  end

  def edit
    authorize_owner!
  end

  def create
    @listing = Listing.new(listing_params)
    @listing.user = current_user

    if @listing.save
      redirect_to @listing, notice: "Listing created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize_owner!

    if @listing.update(listing_params)
      redirect_to @listing, notice: "Listing updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize_owner!
    @listing.destroy!
    redirect_to listings_path, notice: "Listing deleted successfully."
  end

  private

  def set_listing
    @listing = Listing.find(params[:id])
  end

  def listing_params
    params.require(:listing).permit(:title, :description, :category, :price_per_day, :status, images: [])
  end

  def authorize_owner!
    redirect_to root_path, alert: "Access denied." unless @listing.user == current_user
  end
end
