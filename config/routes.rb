Rails.application.routes.draw do
  devise_for :confirmables
  resources :orders, except: [:edit] do  
  post 'add_to_order', on: :collection
  post 'shop_now', on: :collection
  delete 'destroy_product', on: :collection
  put 'update_quantity', on: :collection
  get 'choose_shipping', on: :collection
  get :process_order, on: :collection
end
  resources :account_informations
  resources :categories
  resources :processed_orders do
  put 'update_status'
  delete 'delete_processed_orders'
  get 'user_index'
  delete 'destroy_for_users'
  get 'generate_csv', on: :collection
  end
  resources :products
    
  devise_for :accounts
 
   devise_scope :account do
        root to: 'devise/sessions#new'
    end

  get 'products/home_products', to: 'products#home_products'
  get 'user_view_index', to: 'products#user_view_index'
  get 'order_view', to: 'orders#order_view'
  get '/main', to: 'home#main'
  post 'add_review', to: 'product_qrs#add_review'
  delete 'delete_review', to: 'product_qrs#delete_review'
  post 'add_comment', to: 'product_qrs#add_comment'
  delete 'delete_comment', to: 'product_qrs#delete_comment'

end
