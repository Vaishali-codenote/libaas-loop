class MyListingsController < ApplicationController
  before_action :authenticate_user!

  def index
    @listings = current_user.listings.order(created_at: :desc)
  end
end
