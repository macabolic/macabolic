class MyCollectionItemsController < ApplicationController
  before_filter :store_location
  before_filter :authenticate_user!, :except => :show

  # GET /my_collection_items/1
  # GET /my_collection_items/1.xml
  def show    
    @my_collection_item = MyCollectionItem.find(params[:id]) if params[:id].present?
    
    #@my_collection_item = MyCollectionItem.find_by_product_id(params[:id]) #if params[:my_collection_item_id].present?
    @user = @my_collection_item.user if @my_collection_item
    @user = current_user if !@user.present?
    @product = Product.find(params[:product_id])
    #@reviews = Review.where(:product_id => @product.id).order("created_at DESC").paginate(:per_page => 10, :page => params[:review_page])
    @questions = Question.where(:product_id => @product.id).order("created_at DESC").page params[:page]

    search_more_like_this = Sunspot.more_like_this(@product) do
      fields :name, :category_name
    end
    @more_like_this = search_more_like_this.results

    friends = @user.friend_ids
    if !friends.nil? and friends.size > 0
      @search_friends_who_owned = Sunspot.search(MyCollectionItem) do
        with(:product_id, params[:product_id])
        with(:user_id, friends)
        with(:interest_indicator, 1)        
      end
      @search_friends_who_wished = Sunspot.search(MyCollectionItem) do
        with(:product_id, params[:product_id])
        with(:user_id, friends)
        with(:interest_indicator, 2)        
      end
    end
    
    @friends_who_owned = @search_friends_who_owned.results.map { |i| i.user } if !@search_friends_who_owned.nil? and @search_friends_who_owned.results.present?
    @friends_who_wished = @search_friends_who_wished.results.map { |i| i.user } if !@search_friends_who_wished.nil? and @search_friends_who_wished.results.present?
    
    @product_comments = @product.comments.order("created_at DESC")
    
    my_collection_item_search = Sunspot.search(MyCollectionItem) do
      with(:product_id, params[:product_id])
    end
    @found_collection_items = my_collection_item_search.results
    @found_collections = @found_collection_items.map { |i| i.my_collection }

    vendor_id = @product.vendor_id
    same_store_search = Sunspot.search(Product) do
      with(:vendor_id, vendor_id)
      without(:id, params[:product_id])
    end
    @same_store_items = same_store_search.results

    if user_signed_in?
      @product_link = ProductLink.new(:informer_id => current_user.id, :product_id => @product.id)
      @price_ranges = PriceRange.order("sort_order ASC")
    end
    
    @my_collections = @user.my_collections
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @product }
    end  
  end

  # GET /my_collection_items/1/edit
  def edit
    @my_collection_item = MyCollectionItem.find(params[:id])
    @product = Product.find(params[:product_id])
    @user = @my_collection_item.user
  end

  # POST /my_collection_items
  # POST /my_collection_items.xml
  def create
    logger.debug "MyCollectionItemsController => create"
    #@product = Product.find(params[:id])
    @product = Product.find(params[:product_id])
    @my_collection = MyCollection.find(params[:my_collection_id]) # This change is caused by the use of has_permalink plugin
    
    @my_collection_item = MyCollectionItem.new
    @my_collection_item.my_collection_id = params[:my_collection_id]
    @my_collection_item.product_id = params[:product_id]
    @my_collection_item.user_id = current_user.id
    @my_collection_item.interest_indicator = params[:interest_indicator]
    
    logger.debug "my_collection_id: #{@my_collection_item.my_collection_id}"
    logger.debug "product_id: #{@my_collection_item.product_id}"
    logger.debug "user_id: #{@my_collection_item.user_id}"
    logger.debug "interest_indicator: #{@my_collection_item.interest_indicator}"
    
    search_item = MyCollectionItem.where("user_id = ? and product_id = ?", current_user.id, params[:product_id])
    #respond_to do |format|
    if search_item.exists?
      logger.debug "Search item exists..."
      # do an update instead on my_collection_id and interest_indicator
      search_item.first.update_attributes(:my_collection_id => params[:my_collection_id], :interest_indicator => params[:interest_indicator])
      redirect_to(member_my_collection_path(current_user, @my_collection), :notice => 'My collection item was successfully saved.')
    else        
      logger.debug "Going to save now..."
      if @my_collection_item.save
        logger.debug "Done saving. Now redirecting to member_my_collection page."
        redirect_to(member_my_collection_path(current_user, @my_collection), :notice => 'My collection item was successfully saved.')
      #if MyCollection.add_product_to_collection(current_user, @product)
      #  format.html { redirect_to(member_my_collection_path(current_user, @my_collection), :notice => 'My collection item was successfully saved.') }
      #  format.html { redirect_to(:controller => 'members', :action => 'collections', :id => current_user.id, :notice => 'My collection was successfully created.') }
      #  format.xml  { render :xml => @my_collection, :status => :created, :location => @my_collection }
      else
        logger.debug "Something is wrong."
        redirect_to(member_my_collection_path(current_user, @my_collection), :notice => 'My collection item was successfully saved.')
      #  format.html { render :action => "new" }
      #  format.xml  { render :xml => @my_collection.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /my_collection_items/1
  # PUT /my_collection_items/1.xml
  def update
    @my_collection_item = MyCollectionItem.find(params[:id])
    @product = Product.find(params[:product_id])

    respond_to do |format|
      if @my_collection_item.update_attributes(params[:my_collection_item])
        format.html { redirect_to(product_my_collection_item_path(@product, @my_collection_item), :notice => 'My collection item was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @my_collection_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /my_collection_items/1
  # DELETE /my_collection_items/1.xml
  def destroy
    #logger.debug "DELETE /my_collection_items/:id"
    logger.debug "DELETE /products/:product_id/my_collection_items/:id"
    @my_collection_item = MyCollectionItem.find(params[:id])
    #@my_collection_item = MyCollectionItem.where("product_id = ? and user_id = ?", params[:product_id], current_user).first
    if !@my_collection_item.nil?
      @my_collection_item.destroy
    end
    #@my_collection = @my_collection_item.my_collection
    #@my_collection_item.destroy

    @product = Product.find(params[:product_id])
    
    respond_to do |format|
      #format.html { redirect_to(product_path(@product)) }
      format.html { redirect_to(member_my_collection_path(current_user, @my_collection_item.my_collection_id)) }
      format.xml  { head :ok }
    end
  end
end
