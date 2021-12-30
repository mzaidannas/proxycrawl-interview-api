class ProductsController < ActionController::API
  def show
    render json: Product.find(params[:id])
  end

  def create
    product = Product.new(product_params)

    if product.save
      render json: product
    else
      render json: product.errors, status: 422
    end
  end

  def update
    product = Product.find(params[:id])

    if product.update(product_params)
      render json: product
    else
      render json: product.errors, status: 422
    end
  end

  def destroy
    product = Product.find(params[:id])
    product.destroy
  end

  private

  def product_params
    params.require(:product).permit(:title, :url, :price, :rating, :reviews)
  end
end
