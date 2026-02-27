class SeedDefaultCategories < ActiveRecord::Migration[7.0]
  DEFAULT_CATEGORIES = %w[Lehenga Saree Anarkali Sherwani Kurta Gown].freeze

  def up
    DEFAULT_CATEGORIES.each do |name|
      slug = name.parameterize
      execute <<~SQL
        INSERT INTO categories (name, slug, active, created_at, updated_at)
        SELECT '#{name}', '#{slug}', 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
        WHERE NOT EXISTS (SELECT 1 FROM categories WHERE slug = '#{slug}')
      SQL
    end
  end

  def down
    execute "DELETE FROM categories WHERE slug IN ('lehenga', 'saree', 'anarkali', 'sherwani', 'kurta', 'gown')"
  end
end
