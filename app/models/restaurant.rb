class Restaurant < ActiveRecord::Base
validates :yelp_id, presence: true, uniqueness: true

  has_many :restaurant_categories
  has_many :categories, through: :restaurant_categories
  has_many :meals

  def self.create_from_yelp_search_result(result)
    restaurant = Restaurant.find_by(yelp_id: result.id)
    if !restaurant
      restaurant = Restaurant.new
    end
    restaurant.yelp_id = result.id
    restaurant.name = result.name
    restaurant.image_url = result.image_url
    restaurant.url = result.url
    restaurant.mobile_url = result.mobile_url
    restaurant.phone = result.phone
    restaurant.display_phone = result.display_phone
    restaurant.review_count = result.review_count
    restaurant.rating = result.rating
    restaurant.rating_img_url = result.rating_img_url
    restaurant.rating_img_url_small = result.rating_img_url_small
    restaurant.rating_img_url_large = result.rating_img_url_large
    restaurant.snippet_text = result.snippet_text
    restaurant.snippet_image_url = result.snippet_image_url
    restaurant.address = result.location.address
    restaurant.display_address = result.location.display_address
    restaurant.city = result.location.city
    restaurant.state_code = result.location.state_code
    restaurant.postal_code = result.location.postal_code
    restaurant.country_code = result.location.country_code
    restaurant.cross_streets = result.location.cross_streets
    restaurant.latitude = result.location.coordinate.latitude
    restaurant.longitude = result.location.coordinate.longitude
    restaurant.menu_provider = result.menu_provider
    restaurant.menu_date_updated = result.menu_date_updated
    restaurant.reservation_url = result.reservation_url
    restaurant.eat24_url = result.eat24_url
    restaurant.categories = []
    if !result.categories.empty?
      result.categories.each do |pair|
        category = Category.find_by(yelp_alias: pair.last)
        restaurant.categories << category unless category.nil?
      end
    end
    restaurant.save
    restaurant
  end

end