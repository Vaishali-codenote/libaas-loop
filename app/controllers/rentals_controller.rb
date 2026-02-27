class RentalsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_rental, only: [:show, :approve, :reject, :mark_returned, :update]

  def index
    @rentals_as_renter = current_user.rentals_as_renter.includes(:listing, :owner).order(created_at: :desc)
    @rentals_as_owner = current_user.rentals_as_owner.includes(:listing, :renter).order(created_at: :desc)
  end

  def show
  end

  def create
    @listing = Listing.find(params[:listing_id])

    if @listing.user == current_user
      redirect_to @listing, alert: "You cannot rent your own listing."
      return
    end

    unless @listing.available?
      redirect_to @listing, alert: "This listing is currently unavailable."
      return
    end

    if rental_params[:start_date].blank? || rental_params[:end_date].blank?
      redirect_to @listing, alert: "Please select both start and end dates."
      return
    end

    begin
      start_date = Date.parse(rental_params[:start_date].to_s)
      end_date = Date.parse(rental_params[:end_date].to_s)
    rescue ArgumentError
      redirect_to @listing, alert: "Please provide valid rental dates."
      return
    end
    
    if start_date < Date.today
      redirect_to @listing, alert: "Start date cannot be in the past."
      return
    end
    
    if end_date < start_date
      redirect_to @listing, alert: "End date must be on or after start date."
      return
    end
    
    # Check if listing is already rented for these dates
    existing_rental = @listing.rentals.where(
      status: [:pending, :approved, :active],
      start_date: ..end_date,
      end_date: start_date..
    ).first
    
    if existing_rental
      redirect_to @listing, alert: "This listing is not available for the selected dates."
      return
    end
    
    @rental = Rental.new(rental_params)
    @rental.listing = @listing
    @rental.renter = current_user
    @rental.owner = @listing.user
    @rental.status = :pending

    if @rental.save
      redirect_to my_rentals_path, notice: "Rental request sent successfully!"
    else
      redirect_to @listing, alert: "Failed to create rental request. #{@rental.errors.full_messages.join(', ')}"
    end
  end

  def approve
    authorize_owner!
    overlaps_scope = @rental.listing.rentals
      .where.not(id: @rental.id)
      .where("start_date <= ? AND end_date >= ?", @rental.end_date, @rental.start_date)

    if overlaps_scope.where(status: %w[approved active]).exists?
      redirect_to my_rentals_path, alert: "Another active rental already exists for these dates."
      return
    end

    Rental.transaction do
      overlaps_scope.where(status: :pending).update_all(status: "rejected", updated_at: Time.current)
      @rental.update!(status: :active)
      @rental.listing.update!(status: :rented)
    end

    redirect_to my_rentals_path, notice: "Rental approved successfully!"
  rescue ActiveRecord::RecordInvalid => e
    redirect_to my_rentals_path, alert: "Failed to approve rental: #{e.record.errors.full_messages.to_sentence}"
  end

  def reject
    authorize_owner!
    if @rental.update(status: :rejected)
      redirect_to my_rentals_path, notice: "Rental rejected."
    else
      redirect_to my_rentals_path, alert: "Failed to reject rental."
    end
  end

  def mark_returned
    authorize_owner!
    if @rental.update(status: :completed)
      @rental.listing.update(status: :available)
      redirect_to my_rentals_path, notice: "Item marked as returned. Rental completed!"
    else
      redirect_to my_rentals_path, alert: "Failed to complete rental."
    end
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
