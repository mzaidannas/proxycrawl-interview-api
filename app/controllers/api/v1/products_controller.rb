module Api
  module V1
    class ProductsController < ApplicationController
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
        if product.destroy
          render json: product
        else
          render json: product.errors, status: 422
        end
      end

      private

      def product_params
        params[:product]&.slice(:title, :url, :price, :rating, :reviews)
      end
    end
  end
end
