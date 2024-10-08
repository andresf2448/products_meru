class ProductsController < ApplicationController
  #we generate basic authentication
  skip_before_action :authenticate, only: :index
  before_action :set_product, only: [:show, :update, :destroy]

  # GET /products
  def index
    products = Product.all.order(:id)
    total_pages = (products.count / params[:limit].to_f).ceil

    if params[:search].present?
      products = products.where("name ILIKE ?", "%#{params[:search]}%")
      total_pages = (products.count / params[:limit].to_i).ceil
    end

    products = products.offset((params[:page].to_i - 1) * params[:limit].to_i).limit(params[:limit].to_i)

    render json: {products: products, total_pages: total_pages}, status: :ok
  end

  #GET /products/:id
  def show
    render json: @product
  end

  #POST /products
  def create
    product = Product.new(product_params)

    if product.save
      render json: product, status: :created
    else
      render json: product.errors, status: :unprocessable_entity
    end
  end

  #PUT /products/:id
  def update
    if @product.update(product_params)
      render json: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  #DELETE /products/:id
  def destroy
    @product.destroy

    render json: {message: "Product deleted successfully"}, status: :ok
  end

  private
  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :price)
  end
end
