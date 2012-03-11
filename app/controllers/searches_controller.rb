class SearchesController < ApplicationController

  # GET /wishlists/1
  # GET /wishlists/1.xml
  def find_product
    @show_collection = true
    if params[:scope].present? 
      if params[:scope] == 'product_line'
        @search = Sunspot.search(Product) do
          with(:product_line_id, params[:product_line_id])
          fulltext params[:query]
          paginate(:per_page => 25, :page => params[:product_page])
        end
      elsif params[:scope] == 'store'
        @search = Sunspot.search(Product) do
          with(:vendor_id, params[:vendor_id])
          fulltext params[:query]
          paginate(:per_page => 25, :page => params[:product_page])
        end
      end 
      # Problem with showing MyCollection when multiple MyCollectionItem exists in one MyCollection
      # This can be solved by upgrading to Solr 3.3 which supports group by function.
      # Now, I simple drop this.
      #
      #my_collection_item_search = Sunspot.search(MyCollectionItem) do
      #  with(:product_line_id, params[:query])
      #  paginate(:per_page => 2, :page => params[:collection_page])        
      #end
      @show_collection = false
    else 
      @search = Sunspot.search(Product) do
        fulltext params[:query]
        paginate(:per_page => 25, :page => params[:product_page])
      end
      my_collection_item_search = Sunspot.search(MyCollectionItem) do
        fulltext params[:query]
        paginate(:per_page => 2, :page => params[:collection_page])
      end
    end
        
    @found_products = @search.results
    if @found_products.size > 0
      list_of_product_ids = @found_products.map(&:id)
      @vendor_search = Sunspot.search(Product) do      
        with(:id, list_of_product_ids)
        facet :vendor_id
      end    
      
      @product_line_search = Sunspot.search(Product) do
        with(:id, list_of_product_ids)
        facet :product_line_id
      end
    end
  
    if @show_collection
      @found_collection_items = my_collection_item_search.results
      @found_collections = @found_collection_items.map { |i| i.my_collection }
    end
    
    @my_collections = current_user.my_collections if user_signed_in?
    if params[:scope].present?
      if params[:query].present? && !params[:query].nil?
        @query = params[:query]
      else
        if params[:scope] == 'product_line'
          @query = ProductLine.find(params[:product_line_id]).name
        else
          @query = Vendor.find(params[:vendor_id]).name
        end
      end
    else
      @query = params[:query]
    end
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
