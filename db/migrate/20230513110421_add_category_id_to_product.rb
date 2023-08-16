class AddCategoryIdToProduct < ActiveRecord::Migration[7.0]
  def change
   add_column :products, :category_id, :bigint
   add_index :products, :category_id
  end
end
