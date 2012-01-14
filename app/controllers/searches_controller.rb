class SearchesController < ApplicationController

  # GET /wishlists/1
  # GET /wishlists/1.xml
  def find_product
    @search = Sunspot.search(Product) do
      fulltext params[:query]
      paginate(:per_page => 10, :page => params[:product_page])
    end
    
    @found_products = @search.results
    
  #  respond_to do |format|
  #    format.html # show.html.erb
  #    format.xml  { render :xml => @wishlist }
  #  end
  
  end

end
