class CreateMeals < ActiveRecord::Migration
  def change
    create_table :meals do |t|
      t.string :name
      t.date :date
      t.time :time
      t.string :location
      t.integer :restaurant_id
      t.integer :host_id
    end
  end
end
