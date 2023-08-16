class AddRoleToAccount < ActiveRecord::Migration[7.0]
  def change
     add_column :accounts, :role, :string, default: "client"
  end
end
