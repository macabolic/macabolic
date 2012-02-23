class ProductLinksController < ApplicationController
  # POST /products
  # POST /products.xml
  def create
    @product_link = ProductLink.new(params[:product_link])      
    @product_link.save
    @product = Product.find(@product_link.product_id)
  end
end