class Order < ApplicationRecord
belongs_to :account
has_many :orders_products
has_many :products, through: :orders_products
has_many :processed_order
end
