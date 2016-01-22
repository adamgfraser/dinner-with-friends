class CreateRestaurantCategories < ActiveRecord::Migration
  def change
    create_table :restaurant_categories do |t|
      t.string :restaurant_id
      t.string :category_id
    end
  end
end
