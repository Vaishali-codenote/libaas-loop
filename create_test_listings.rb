# Create stylized SVG artwork images for test listings
require 'tempfile'

user = User.find_by(email: "user@libaasloop.com")

# Delete old test listings - simpler approach
Listing.where(user: user).destroy_all

# Category-specific garment artwork
def garment_markup(category, palette)
  case category
  when "Lehenga"
    <<-SVG
    <g opacity="0.9" filter="url(#shadow)">
      <ellipse cx="200" cy="96" rx="20" ry="18" fill="#{palette[:embroidery]}"/>
      <path d="M165 115 C185 105, 215 105, 235 115 L222 138 C208 132, 192 132, 178 138 Z" fill="#{palette[:silhouette]}"/>
      <path d="M140 145 C153 126, 247 126, 260 145 L285 230 C254 246, 146 246, 115 230 Z" fill="#{palette[:silhouette]}"/>
      <path d="M138 188 C170 205, 230 205, 262 188" stroke="#{palette[:embroidery]}" stroke-width="3" fill="none"/>
      <path d="M146 210 C178 226, 222 226, 254 210" stroke="#{palette[:embroidery]}" stroke-width="3" fill="none" opacity="0.9"/>
    </g>
    SVG
  when "Saree"
    <<-SVG
    <g opacity="0.9" filter="url(#shadow)">
      <ellipse cx="200" cy="92" rx="19" ry="17" fill="#{palette[:embroidery]}"/>
      <path d="M180 112 C195 106, 205 106, 220 112 L220 170 C219 193, 222 214, 236 236 L173 236 C184 208, 186 190, 180 166 Z" fill="#{palette[:silhouette]}"/>
      <path d="M220 125 C246 138, 257 167, 250 198 C245 220, 228 236, 206 236" stroke="#{palette[:embroidery]}" stroke-width="4" fill="none"/>
      <path d="M190 140 C206 150, 214 170, 208 196" stroke="#{palette[:embroidery]}" stroke-width="3" fill="none" opacity="0.85"/>
    </g>
    SVG
  when "Anarkali"
    <<-SVG
    <g opacity="0.9" filter="url(#shadow)">
      <ellipse cx="200" cy="92" rx="19" ry="17" fill="#{palette[:embroidery]}"/>
      <path d="M176 115 C190 104, 210 104, 224 115 L224 150 C224 160, 176 160, 176 150 Z" fill="#{palette[:silhouette]}"/>
      <path d="M150 150 C170 130, 230 130, 250 150 L275 228 C246 246, 154 246, 125 228 Z" fill="#{palette[:silhouette]}"/>
      <path d="M170 172 C190 180, 210 180, 230 172" stroke="#{palette[:embroidery]}" stroke-width="3" fill="none"/>
      <path d="M160 194 C186 205, 214 205, 240 194" stroke="#{palette[:embroidery]}" stroke-width="3" fill="none"/>
    </g>
    SVG
  when "Sherwani"
    <<-SVG
    <g opacity="0.9" filter="url(#shadow)">
      <ellipse cx="200" cy="90" rx="18" ry="16" fill="#{palette[:embroidery]}"/>
      <path d="M170 112 C186 102, 214 102, 230 112 L240 236 L160 236 Z" fill="#{palette[:silhouette]}"/>
      <path d="M200 114 L200 236" stroke="#{palette[:embroidery]}" stroke-width="3"/>
      <circle cx="200" cy="136" r="3" fill="#{palette[:embroidery]}"/>
      <circle cx="200" cy="156" r="3" fill="#{palette[:embroidery]}"/>
      <circle cx="200" cy="176" r="3" fill="#{palette[:embroidery]}"/>
      <circle cx="200" cy="196" r="3" fill="#{palette[:embroidery]}"/>
    </g>
    SVG
  when "Kurta"
    <<-SVG
    <g opacity="0.9" filter="url(#shadow)">
      <ellipse cx="200" cy="90" rx="18" ry="16" fill="#{palette[:embroidery]}"/>
      <path d="M166 114 C182 102, 218 102, 234 114 L244 205 L156 205 Z" fill="#{palette[:silhouette]}"/>
      <path d="M170 205 L190 236 L210 236 L230 205" fill="#{palette[:silhouette]}"/>
      <path d="M200 116 L200 205" stroke="#{palette[:embroidery]}" stroke-width="3"/>
    </g>
    SVG
  else # Gown
    <<-SVG
    <g opacity="0.9" filter="url(#shadow)">
      <ellipse cx="200" cy="92" rx="19" ry="17" fill="#{palette[:embroidery]}"/>
      <path d="M178 114 C190 104, 210 104, 222 114 L228 140 C232 152, 168 152, 172 140 Z" fill="#{palette[:silhouette]}"/>
      <path d="M138 148 C158 129, 242 129, 262 148 L286 228 C251 247, 149 247, 114 228 Z" fill="#{palette[:silhouette]}"/>
      <path d="M155 187 C180 204, 220 204, 245 187" stroke="#{palette[:embroidery]}" stroke-width="3" fill="none"/>
    </g>
    SVG
  end
end

# SVG artwork with gradient, fabric pattern, garment, and title lockup
def create_svg_placeholder(title, category, palette)
  svg = <<-SVG
<svg xmlns="http://www.w3.org/2000/svg" width="400" height="300">
  <defs>
    <linearGradient id="bg" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#{palette[:start]}"/>
      <stop offset="100%" stop-color="#{palette[:end]}"/>
    </linearGradient>
    <radialGradient id="spot" cx="80%" cy="20%" r="60%">
      <stop offset="0%" stop-color="#FFFFFF" stop-opacity="0.35"/>
      <stop offset="100%" stop-color="#FFFFFF" stop-opacity="0"/>
    </radialGradient>
    <pattern id="fabric" width="22" height="22" patternUnits="userSpaceOnUse">
      <path d="M0 11h22M11 0v22" stroke="#{palette[:pattern]}" stroke-opacity="0.18" stroke-width="1"/>
      <circle cx="11" cy="11" r="2.2" fill="#{palette[:pattern]}" fill-opacity="0.12"/>
    </pattern>
    <filter id="shadow" x="-20%" y="-20%" width="140%" height="140%">
      <feDropShadow dx="0" dy="8" stdDeviation="8" flood-opacity="0.25"/>
    </filter>
  </defs>

  <rect width="400" height="300" fill="url(#bg)"/>
  <rect width="400" height="300" fill="url(#spot)"/>
  <rect width="400" height="300" fill="url(#fabric)"/>

  #{garment_markup(category, palette)}

  <rect x="0" y="224" width="400" height="76" fill="#111827" fill-opacity="0.30"/>
  <text x="50%" y="252" font-family="Georgia, serif" font-size="26" font-weight="700" fill="white" text-anchor="middle">#{title}</text>
  <text x="50%" y="274" font-family="Arial, sans-serif" font-size="14" fill="white" fill-opacity="0.88" text-anchor="middle">Premium Ethnic Wear</text>
</svg>
  SVG
  svg
end

listings_data = [
  {
    title: "Ruby Bridal Lehenga", category: "Lehenga", price: 1500, svg_title: "Bridal Lehenga",
    palette: { start: "#B91C1C", end: "#FB7185", pattern: "#FECACA", silhouette: "#7F1D1D", embroidery: "#FDE68A" }
  },
  {
    title: "Royal Silk Saree", category: "Saree", price: 800, svg_title: "Silk Saree",
    palette: { start: "#1D4ED8", end: "#60A5FA", pattern: "#BFDBFE", silhouette: "#1E3A8A", embroidery: "#DBEAFE" }
  },
  {
    title: "Emerald Anarkali", category: "Anarkali", price: 600, svg_title: "Anarkali Suit",
    palette: { start: "#047857", end: "#34D399", pattern: "#A7F3D0", silhouette: "#065F46", embroidery: "#D1FAE5" }
  },
  {
    title: "Golden Sherwani", category: "Sherwani", price: 1200, svg_title: "Sherwani",
    palette: { start: "#92400E", end: "#F59E0B", pattern: "#FDE68A", silhouette: "#78350F", embroidery: "#FEF3C7" }
  },
  {
    title: "Rose Kurta Set", category: "Kurta", price: 400, svg_title: "Kurta Set",
    palette: { start: "#BE185D", end: "#F472B6", pattern: "#FBCFE8", silhouette: "#9D174D", embroidery: "#FDF2F8" }
  },
  {
    title: "Midnight Designer Gown", category: "Gown", price: 900, svg_title: "Designer Gown",
    palette: { start: "#4C1D95", end: "#A78BFA", pattern: "#DDD6FE", silhouette: "#312E81", embroidery: "#EDE9FE" }
  }
]

listings_data.each do |data|
  svg_content = create_svg_placeholder(data[:svg_title], data[:category], data[:palette])
  
  temp_file = Tempfile.new(['test-image', '.svg'])
  temp_file.binmode
  temp_file.write(svg_content)
  temp_file.rewind

  listing = Listing.create!(
    title: data[:title],
    description: "Beautiful #{data[:category]} perfect for weddings and special occasions. High quality fabric with intricate work. Available for rent at affordable prices.",
    category: data[:category],
    price_per_day: data[:price],
    user: user,
    status: "available"
  )

  listing.images.attach(
    io: temp_file,
    filename: "#{data[:category].downcase}.svg",
    content_type: "image/svg+xml"
  )

  temp_file.close
  temp_file.unlink
  
  puts "✅ Created: #{listing.title}"
end

puts "\n🎉 Total listings: #{Listing.count}"
puts "\nNow visit: http://localhost:3000/listings"
