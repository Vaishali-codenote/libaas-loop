class Admin::RentalsController < Admin::BaseController
  before_action :set_rental, only: [:show, :update, :cancel, :force_complete, :issue_refund]

  def new
    redirect_to admin_rentals_path, alert: "Rental creation is available from listing page."
  end

  def create
    redirect_to admin_rentals_path, alert: "Rental creation is available from listing page."
  end

  def index
    @rentals = Rental.includes(:listing, :renter, :owner).order(created_at: :desc).page(params[:page])
    @total_revenue = Rental.where(status: %w[active completed]).includes(:listing).sum { |rental| rental.total_price.to_f }
  end

  def show; end

  def update
    if @rental.update(rental_params)
      redirect_to admin_rental_path(@rental), notice: "Rental updated successfully."
    else
      render :show, status: :unprocessable_entity
    end
  end

  def cancel
    @rental.update!(status: :cancelled)
    @rental.listing.update!(status: :available) if @rental.listing.rented?
    redirect_to admin_rental_path(@rental), notice: "Rental cancelled."
  end

  def force_complete
    @rental.update!(status: :completed)
    @rental.listing.update!(status: :available)
    redirect_to admin_rental_path(@rental), notice: "Rental force completed."
  end

  def issue_refund
    @rental.update!(refund_issued_at: Time.current)
    redirect_to admin_rental_path(@rental), notice: "Refund marked as issued."
  end

  private

  def set_rental
    @rental = Rental.find(params[:id])
  end

  def rental_params
    params.require(:rental).permit(:status)
  end
end
