class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]
  before_action :authenticate_account!, only: [:edit,:destroy,:new,:create,:update,:show]
  before_action :check_admin, except: [:user_view_index, :show]
  
  include Pagy::Backend

  # GET /products or /products.json
  def index
      
    @products = Product.includes(:category).with_attached_image.all 

    if params[:category_name].present?
    @products = Product.includes(:category).where(categories: { name: params[:category_name] })
    end
    
    if params[:sort_by] == "price_asc"
        @products = @products.order(price: :asc)
    elsif params[:sort_by] == "price_desc"
        @products = @products.order(price: :desc)
    elsif params[:sort_by] == "stock_asc"
        @products = @products.order(stock: :asc)
    elsif params[:sort_by] == "stock_desc"
        @products = @products.order(stock: :desc)
    end

    @pagy, @products = pagy(@products, items:10)
  end

  def home_products
  @products = Product.includes(:category).with_attached_image.where("stock >= ?", 1)
  @product_reviews = ProductQr.where(is_review: true).includes(:account)
  end

def user_view_index
  @products = Product.includes(:category).with_attached_image.where("stock >= ?", 1)
  @product_reviews = ProductQr.where(is_review: true).includes(:account)
  if params[:search].present?
    @products = @products.where("products.name LIKE ?", "%#{params[:search]}%")
  end

  if params[:category_name].present?
    @products = @products.joins(:category).where("categories.name = ?", params[:category_name])
  end

  if params[:sort_by] == "price_asc"
    @products = @products.order(price: :asc)
  elsif params[:sort_by] == "price_desc"
    @products = @products.order(price: :desc)
  end

  @pagy, @products = pagy(@products, items: 8)
end




  # GET /products/1 or /products/1.json
  def show
  @product_reviews = ProductQr.where(is_review: true).includes(:account)
  @product_questions = ProductQr.where(is_review: false).includes(:account)
  end


  # GET /products/new
  def new
    @product = Product.new
    @product.name = Faker::Device.model_name
    @product.description = Faker::Lorem.sentence
    @product.price = Faker::Commerce.price(range: 10..1000.0)
    @product.stock = Faker::Number.between(from: 0, to: 100)
    @product.code = Faker::Barcode.ean(13)
    @product.category = Category.all.sample
    @product.url = Faker::Internet.url
    
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products or /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to product_url(@product), notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to product_url(@product), notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.fetch(:product, {}).permit(:id,:name,:description,:price,:code,:stock,:category_id,:url,:image)
    end
end
