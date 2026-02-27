class ListingsController < ApplicationController
  require "fileutils"
  require "securerandom"

  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_listing, only: [:show, :edit, :update, :destroy]
  before_action :set_category_options, only: [:new, :edit, :create, :update]

  def index
    @listings = Listing.includes(:user).where(status: :available, approval_status: :approved).all
    @categories = Listing.select(:category).distinct.pluck(:category)
  end

  def show
    if @listing.pending? || @listing.rejected?
      unless user_signed_in? && (@listing.user == current_user || current_user.admin?)
        redirect_to listings_path, alert: "Listing is awaiting admin approval."
        return
      end
    end
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
    @listing.approval_status = :pending
    attach_uploaded_asset_image(@listing)

    if @listing.save
      redirect_to my_listings_path, notice: "Listing created successfully! Your listing is pending admin approval."
    else
      render :new, status: :unprocessable_entity, alert: @listing.errors.full_messages.join(", ")
    end
  end

  def update
    authorize_owner!
    attach_uploaded_asset_image(@listing)

    if @listing.update(listing_params)
      redirect_to my_listings_path, notice: "Listing updated successfully."
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

  def attach_uploaded_asset_image(listing)
    uploaded = params.dig(:listing, :image_upload)
    return if uploaded.blank?

    ext = File.extname(uploaded.original_filename.to_s).downcase
    allowed_exts = %w[.jpg .jpeg .png .webp .svg]
    return listing.errors.add(:image_name, "must be jpg, jpeg, png, webp, or svg") unless allowed_exts.include?(ext)

    category_folder = listing.category.to_s.parameterize
    allowed_folders = %w[lehenga saree anarkali sherwani kurta gown]
    category_folder = "gown" unless allowed_folders.include?(category_folder)

    base = File.basename(uploaded.original_filename.to_s, ".*").parameterize.presence || "image"
    filename = "#{base}-#{SecureRandom.hex(4)}#{ext}"
    destination = Rails.root.join("app/assets/images", category_folder, filename)
    FileUtils.mkdir_p(destination.dirname)
    File.binwrite(destination, uploaded.read)

    listing.image_name = filename
  end

  def set_category_options
    @category_options = Category.active.order(:name).pluck(:name)
    @category_options = ["Lehenga", "Saree", "Anarkali", "Sherwani", "Kurta", "Gown"] if @category_options.blank?
  end
end
