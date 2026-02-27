class RentalsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_rental, only: [:show, :approve, :reject, :mark_returned, :update]

  def index
    @rentals_as_renter = current_user.rentals_as_renter.includes(:listing, :owner)
    @rentals_as_owner = current_user.rentals_as_owner.includes(:listing, :renter)
  end

  def show
  end

  def create
    @listing = Listing.find(params[:listing_id])
    @rental = Rental.new(rental_params)
    @rental.listing = @listing
    @rental.renter = current_user
    @rental.owner = @listing.user
    @rental.status = :pending

    if @rental.save
      redirect_to my_rentals_path, notice: "Rental request sent successfully."
    else
      redirect_to @listing, alert: "Failed to create rental request."
    end
  end

  def approve
    authorize_owner!
    @rental.update(status: :approved)
    @rental.listing.update(status: :rented)
    redirect_to my_rentals_path, notice: "Rental approved."
  end

  def reject
    authorize_owner!
    @rental.update(status: :rejected)
    redirect_to my_rentals_path, notice: "Rental rejected."
  end

  def mark_returned
    authorize_owner!
    @rental.update(status: :completed)
    @rental.listing.update(status: :available)
    redirect_to my_rentals_path, notice: "Item marked as returned. Rental completed."
  end

  private

  def set_rental
    @rental = Rental.find(params[:id])
  end

  def rental_params
    params.require(:rental).permit(:start_date, :end_date)
  end

  def authorize_owner!
    redirect_to root_path, alert: "Access denied." unless @rental.owner == current_user
  end
end
