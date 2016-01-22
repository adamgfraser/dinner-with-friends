class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
      t.integer :yelp_id
      t.string :name
      t.string :image_url
      t.string :url
      t.string :mobile_url
      t.string :phone
      t.string :display_phone
      t.integer :review_count
      t.integer :distance
      t.integer :rating
      t.string :rating_img_url
      t.string :rating_img_url_small
      t.string :rating_img_url_large
      t.string :snippet_text
      t.string :snippet_image_url
      t.string :address
      t.string :display_address
      t.string :city
      t.string :state_code
      t.string :postal_code
      t.string :country_code
      t.string :cross_streets
      t.float :latitude
      t.float :longitude
      t.string :menu_provider
      t.integer :menu_date_updated
      t.string :reservation_url
      t.string :eat24_url
    end
  end
end
