class OrdersController < ApplicationController
  before_action :set_order, only: %i[ show edit update destroy ]
  before_action :set_current_account_order

  def add_to_order
    product = Product.find(params[:product_id])
    orders_product = @order.orders_products.find_by(product_id: product.id)

    if orders_product
       orders_product.increment!(:quantity, 1)
    else
    @order.products << product
    end
    
    redirect_to orders_path, notice: "Product added to order."
  end

   def process_order
    @order = current_account.order
  end

  def shop_now
    @order.products.destroy_all
    product = Product.find(params[:product_id])
    orders_product = @order.orders_products.find_by(product_id: product.id)
    @order.products << product
    redirect_to choose_shipping_orders_path
  end


  # GET /orders or /orders.json
  def index
    @order = current_account.order
    @products = @order.products
  end

  def destroy_product
    @product = current_account.order.products.find(params[:id])

    if @product
      current_account.order.products.delete(@product)
      redirect_to orders_path, notice: "Product removed from order."
    else
      redirect_to orders_path, alert: "Product not found in order."
    end
  end

  def update_quantity
  orders_product = current_account.order.orders_products.find_by(product_id: params[:product_id])
  if orders_product
    orders_product.update(quantity: params[:quantity])
    redirect_to orders_path, notice: "Quantity updated successfully."
  else
    redirect_to orders_path, alert: "Product not found."
  end
end

  def choose_shipping
    @account_information = current_account.account_information
    return redirect_to orders_path, alert: "Cart is empty." if @order.products.empty?
  end
    
  # GET /orders/1 or /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    redirect_to main_path
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders or /orders.json
  def create
    @order = Order.new(order_params)

    respond_to do |format|
      if @order.save
        format.html { redirect_to orders_path, notice: "Order was successfully created." }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :index, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1 or /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to orders_path, notice: "Order was successfully updated." }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :index, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1 or /orders/1.json
  def destroy
    @order.destroy

    respond_to do |format|
      format.html { redirect_to orders_url, notice: "Order was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    def set_current_account_order
        @order = current_account.order || current_account.create_order
    end
    
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = current_account.order
    end

    # Only allow a list of trusted parameters through.
    def order_params
      params.fetch(:order, {})
    end
end
