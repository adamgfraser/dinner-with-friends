class CreateAncestry < ActiveRecord::Migration
  def change
    create_table :ancestries do |t|
      t.string :child_id
      t.string :parent_id
    end
  end
end
