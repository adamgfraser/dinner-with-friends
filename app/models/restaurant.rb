class Restaurant < ActiveRecord::Base
  validates :yelp_id, presence: true, uniqueness: true

  has_many :restaurant_categories
  has_many :categories, through: :restaurant_categories
  has_many :meals
end