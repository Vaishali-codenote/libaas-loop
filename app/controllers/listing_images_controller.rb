class ListingImagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_listing
  before_action :set_image

  def destroy
    authorize_owner!
    @image.purge
    redirect_to edit_listing_path(@listing), notice: "Image removed successfully."
  end

  private

  def set_listing
    @listing = Listing.find(params[:listing_id])
  end

  def set_image
    @image = @listing.images.find(params[:id])
  end

  def authorize_owner!
    redirect_to root_path, alert: "Access denied." unless @listing.user == current_user
  end
end
