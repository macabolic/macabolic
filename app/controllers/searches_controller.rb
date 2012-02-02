class SearchesController < ApplicationController

  # GET /wishlists/1
  # GET /wishlists/1.xml
  def find_product
    @search = Sunspot.search(Product) do
      fulltext params[:query]
      paginate(:per_page => 25, :page => params[:product_page])
    end
    
    @found_products = @search.results
    
  #  respond_to do |format|
  #    format.html # show.html.erb
  #    format.xml  { render :xml => @wishlist }
  #  end  
  end

  def find_vendor
    @search = Sunspot.search(Vendor) do
      fulltext params[:query], :fields => [:vendor_name]    
    end
    
    @vendors = @search.results
    
    respond_to do |format|
      format.html
      format.xml  { render :xml => @vendors }
      format.json { render :json => @vendors }
    end
  end

end
