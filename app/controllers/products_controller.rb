class ProductsController < ApplicationController
  helper_method :sort_column, :sort_direction

  # GET /products
  # GET /products.xml
  def index
    @products = Product.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 10, :page => params[:page])
  end
  
  private
  
  def sort_column
    params[:sort] || "name"
    Product.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
  end
  
end
