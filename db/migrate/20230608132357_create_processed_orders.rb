class CreateProcessedOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :processed_orders do |t|
      t.integer :account_id
      t.integer :order_id
      t.integer :product_id 
      t.integer :quantity
      t.string :status, default: "processing"
      t.string :address
      t.string :name
      t.string :tracking_number
      t.timestamps
    end
  end
end
