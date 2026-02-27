# Create a test listing with a local placeholder image
user = User.find_by(email: "user@libaasloop.com")

# Create a simple 1x1 pixel PNG image (smallest valid PNG)
png_data = Base64.decode64("iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==")

# Create a temp file
require 'tempfile'
temp_file = Tempfile.new(['test-image', '.png'])
temp_file.binmode
temp_file.write(png_data)
temp_file.rewind

listing = Listing.create!(
  title: "Test Lehenga with Image",
  description: "Beautiful test lehenga",
  category: "Lehenga",
  price_per_day: 800,
  user: user,
  status: "available"
)

listing.images.attach(
  io: temp_file,
  filename: "test-lehenga.png",
  content_type: "image/png"
)

temp_file.close
temp_file.unlink

puts "Listing created with image: #{listing.title}"
puts "Image attached: #{listing.images.attached?}"
