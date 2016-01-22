class Vote < ActiveRecord::Base
  validates :user_id, presence: true
  validates :meal_id, presence: true
  validates :category_id, presence: true

  belongs_to :user
  belongs_to :meal
  belongs_to :category
end