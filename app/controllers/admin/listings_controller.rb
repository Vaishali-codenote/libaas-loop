class Admin::ListingsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!
  before_action :set_listing, only: [:show, :destroy]

  def index
    @listings = Listing.includes(:user).order(created_at: :desc).page(params[:page])
  end

  def show
  end

  def destroy
    @listing.destroy!
    redirect_to admin_listings_path, notice: "Listing deleted successfully."
  end

  private

  def set_listing
    @listing = Listing.find(params[:id])
  end
end
