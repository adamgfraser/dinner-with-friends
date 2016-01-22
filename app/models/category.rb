class Category < ActiveRecord::Base
  has_many :child_ancestry, class_name: "Ancestry", foreign_key: :parent_id
  has_many :children, through: :child_ancestry, source: :child
  has_many :parent_ancestry, class_name: "Ancestry", foreign_key: :child_id
  has_many :parents, through: :parent_ancestry, source: :parent
  has_many :restaurant_categories
  has_many :restaurants, through: :restaurant_categories
  has_many :votes
end