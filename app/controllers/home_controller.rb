class HomeController < ActionController::Base
 
def login
render layout: 'application1'
end

def main
@products = Product.includes(:category).with_attached_image.all
@product_reviews = ProductQr.where(is_review: true).includes(:account)
render template: 'products/home_products', layout: 'application'
end




end
