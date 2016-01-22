class Ancestry < ActiveRecord::Base
  belongs_to :child, class_name: "Category", foreign_key: "child_id"
  belongs_to :parent, class_name: "Category", foreign_key: "parent_id"
end