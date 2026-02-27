# This file should contain all the record creation needed to seed the database with its default values.

puts "Creating admin user..."
admin = User.find_or_create_by!(email: "admin@libaasloop.com") do |user|
  user.name = "Admin User"
  user.password = "password123"
  user.password_confirmation = "password123"
  user.role = "admin"
end
puts "Admin created: #{admin.email}"

puts "Creating regular user..."
user = User.find_or_create_by!(email: "user@libaasloop.com") do |user|
  user.name = "Test User"
  user.password = "password123"
  user.password_confirmation = "password123"
  user.role = "user"
end
puts "User created: #{user.email}"

puts "Creating sample listings..."
categories = ["Lehenga", "Saree", "Anarkali", "Sherwani", "Kurta", "Gown"]

5.times do |i|
  listing = Listing.find_or_create_by!(title: "Beautiful #{categories[i % categories.length]} #{i + 1}") do |l|
    l.description = "This is a stunning #{categories[i % categories.length]} perfect for weddings and special occasions. Made with high-quality fabric and intricate embroidery."
    l.category = categories[i % categories.length]
    l.price_per_day = (500 + i * 100).to_d
    l.user = user
    l.status = "available"
  end
  puts "Listing created: #{listing.title}"
end

puts "Sample data created successfully!"
puts ""
puts "Login credentials:"
puts "  Admin: admin@libaasloop.com / password123"
puts "  User:  user@libaasloop.com / password123"
