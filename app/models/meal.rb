class Meal < ActiveRecord::Base
  belongs_to :restaurant
  has_many :categories, through: :restaurants
  has_many :invitations
  has_many :users, through: :invitations
end