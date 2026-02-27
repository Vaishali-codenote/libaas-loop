class Category < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :slug, presence: true, uniqueness: { case_sensitive: false }

  scope :active, -> { where(active: true) }

  before_validation :normalize_fields

  private

  def normalize_fields
    self.name = name.to_s.strip
    self.slug = name.to_s.parameterize if slug.blank?
  end
end
