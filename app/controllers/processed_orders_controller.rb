class ProcessedOrdersController < ApplicationController
  before_action :authenticate_account!
  before_action :check_admin, except: [:user_index, :destroy_for_users, :create]

def index
  @processed_orders = ProcessedOrder.all

  if params[:search_product_table].present?
    @processed_orders = @processed_orders.where("tracking_number LIKE :search OR name LIKE :search", search: "%#{params[:search_product_table]}%")
  end

  if params[:sort_by] == "newest"
    @processed_orders = @processed_orders.order(created_at: :desc)
  elsif params[:sort_by] == "oldest"
    @processed_orders = @processed_orders.order(created_at: :asc)
  end

  if params[:status].present? && ['processing', 'shipping', 'shipped', 'cancelled'].include?(params[:status])
    @processed_orders = @processed_orders.where(status: params[:status])
  end

  @processed_orders = @processed_orders.group_by(&:tracking_number)
end

def generate_csv

  csv_data = CSV.generate do |csv|
    # Write headers
    csv << [
      'Tracking Number',
      'Customer Name',
      'Customer Email',
      'Shipping Address',
      'Product ID',
      'Product Name',
      'Product Price',
      'Quantity',
      'Order Status',
      'Created At'
    ]

    # Fetch ProcessedOrder data
    ProcessedOrder.find_each do |order|
      csv << [
        order.tracking_number,
        order.name,
        order.account.email,
        order.address,
        order.product.id,
        order.product.name,
        order.product.price,
        order.quantity,
        order.status,
        order.created_at
      ]
    end
  end

  # Set response headers for CSV file download
  headers['Content-Disposition'] = 'attachment; filename="processed_orders.csv"'
  headers['Content-Type'] = 'text/csv'

  respond_to do |format|
    format.csv { send_data csv_data }
  end
end




  def user_index
  @processed_orders = ProcessedOrder.where(account_id: current_account.id).group_by(&:tracking_number)
  end

  require 'securerandom'

    def create
      @order = current_account.order
      return redirect_to orders_path, alert: "Cart is empty." if @order.products.empty?
      return redirect_to orders_path, alert: "Name can't be empty." if params[:first_name].blank? || params[:last_name].blank?
      return redirect_to orders_path, alert: "Address can't be empty." if params[:country].blank? || params[:county].blank? || params[:city].blank? || params[:address].blank?

      @processed_orders = []
      tracking_number = SecureRandom.random_number(10**10).to_s.rjust(10, '0')

      @order.products.each do |product|
        processed_order = ProcessedOrder.new(
          account_id: current_account.id,
          order_id: @order.id,
          product_id: product.id,
          quantity: @order.orders_products.find_by(product_id: product.id).quantity,
          status: "processing",
          tracking_number: tracking_number,
          name: "#{params[:first_name]} #{params[:last_name]}",
          address: "#{params[:country]}, #{params[:county]}, #{params[:city]}, #{params[:address]}"
        )
        if product.stock >= processed_order.quantity #check stock availability
          product.stock -= processed_order.quantity
          product.save
          if product.stock == 0
            OrderMailer.stock_empty_email(product).deliver_now  #if product ran out of stock send email
          end
        else
          flash[:notice] = "There isn't enough stock for product '#{product.name}'." #cancel order processing if not enough quantity
          redirect_to orders_path and return
        end

        @processed_orders << processed_order
      end

      if @processed_orders.all?(&:valid?)
        @processed_orders.each(&:save!)
        current_account.order.products.destroy_all
      
        #must pass by tracking_number
        OrderMailer.send_email(current_account, @processed_orders).deliver_now
        OrderMailer.send_to_admin_new_order(@processed_orders).deliver_now #for admin notif
        redirect_to processed_order_user_index_path(current_account.id), notice: "Order placed. Soon you will get an e-mail."

      else
        @processed_orders.each do |processed_order|
          processed_order.errors.full_messages.each do |message|
            flash[:alert] ||= ""
            flash[:alert] += "#{message}\n"
          end
        end
        redirect_to orders_path, alert: "Error processing orders."
      end
    end

    def update_status
      processed_orders = ProcessedOrder.where(tracking_number: params[:tracking_number])
      processed_orders.update_all(status: params[:status])

      if processed_orders.first.status == 'cancelled'
        processed_orders.each do |processed_order| #return the stock quantity if cancelled
            product = processed_order.product
            product.stock += processed_order.quantity
            product.save
        end
      end
      OrderMailer.send_update_mail(processed_orders).deliver_now
      redirect_to processed_orders_path
    end

    def delete_processed_orders
      tracking_number = params[:tracking_number]
      processed_orders = ProcessedOrder.where(tracking_number: tracking_number)

      processed_orders.each do |processed_order| #return the stock quantity if cancelled
        product = processed_order.product
        product.stock += processed_order.quantity
        product.save
      end

      processed_orders.destroy_all
      redirect_to processed_orders_path
    end

  def destroy_for_users
        tracking_number = params[:tracking_number]
        processed_orders = ProcessedOrder.where(tracking_number: tracking_number, account_id: current_account.id)
    if processed_orders.any? { |order| order.status == "processing" }
        processed_orders.each do |processed_order| #return the stock quantity if cancelled
            product = processed_order.product
            product.stock += processed_order.quantity
            product.save
        end
        processed_orders.destroy_all
        redirect_to processed_order_user_index_path(current_account.id), notice: "Order deleted."
    else
      redirect_to processed_order_user_index_path(current_account.id), alert: "Order cannot be deleted because it is not in processing status."
    end
  end

end