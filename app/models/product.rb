class Product < ApplicationRecord
belongs_to :category
has_one_attached :image
has_many :orders_products
has_many :orders, through: :orders_products
has_many :processed_orders
has_many :product_qrs

def resized_image
	image.variant(resize_to_fill: [200, 200])
end

end
