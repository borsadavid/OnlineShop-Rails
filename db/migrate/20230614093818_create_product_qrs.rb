class CreateProductQrs < ActiveRecord::Migration[7.0]
  def change
    create_table :product_qrs do |t|
      t.integer :product_id 
      t.integer :account_id
      t.integer :stars
      t.boolean :is_review, default: true
      t.string :text
      t.string :comment, default: nil
      t.timestamps
    end
  end
end
