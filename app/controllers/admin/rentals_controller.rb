class Admin::RentalsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!
  before_action :set_rental, only: [:show, :update]

  def index
    @rentals = Rental.includes(:listing, :renter, :owner).order(created_at: :desc).page(params[:page])
  end

  def show
  end

  def update
    if @rental.update(rental_params)
      redirect_to admin_rental_path(@rental), notice: "Rental updated successfully."
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def set_rental
    @rental = Rental.find(params[:id])
  end

  def rental_params
    params.require(:rental).permit(:status)
  end
end
