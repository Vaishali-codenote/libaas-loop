module ApplicationHelper
  ALLOWED_CATEGORY_FOLDERS = %w[lehenga saree anarkali sherwani kurta gown].freeze

  def listing_image_source(listing)
    category_folder = listing.category.to_s.parameterize
    category_folder = "gown" unless ALLOWED_CATEGORY_FOLDERS.include?(category_folder)

    relative = "#{category_folder}/#{listing.image_name.to_s.downcase.presence || "sample1.jpg"}"
    return relative if Rails.root.join("app/assets/images", relative).exist?

    jpg_fallback = "#{category_folder}/sample1.jpg"
    return jpg_fallback if Rails.root.join("app/assets/images", jpg_fallback).exist?

    "#{category_folder}/sample1.svg"
  end

  def status_class(status)
    case status
    when 'pending' then 'bg-yellow-100 text-yellow-800'
    when 'approved', 'active' then 'bg-green-100 text-green-800'
    when 'rejected', 'cancelled' then 'bg-red-100 text-red-800'
    when 'completed' then 'bg-blue-100 text-blue-800'
    when 'available' then 'bg-green-100 text-green-800'
    when 'rented', 'unavailable' then 'bg-red-100 text-red-800'
    else 'bg-gray-100 text-gray-800'
    end
  end
end
