class CreateAccountInformations < ActiveRecord::Migration[7.0]
  def change
    create_table :account_informations do |t|
    t.string :first_name, null:false
    t.string :last_name, null:false
    t.string :country, null:false
    t.string :county, null:false
    t.string :city, null:false
    t.string :address, null:false
    t.string :card_number_digest, null:false
    t.string :card_name, null:false
    t.string :card_date, null:false
    t.string :card_code_digest, null:false
    t.integer :account_id, null:false
    t.timestamps
    end
  end
end
