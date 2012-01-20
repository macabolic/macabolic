class MyCollectionItemsController < ApplicationController

  # GET /my_collection_items/1
  # GET /my_collection_items/1.xml
  def show    
    @my_collection_item = MyCollectionItem.find(params[:id]) if params[:id].present?
    
    #@my_collection_item = MyCollectionItem.find_by_product_id(params[:id]) #if params[:my_collection_item_id].present?
    @user = @my_collection_item.user if @my_collection_item
    @user = current_user if !@user.present?
    @product = Product.find(params[:product_id])
    #@reviews = Review.where(:product_id => @product.id).order("created_at DESC").paginate(:per_page => 10, :page => params[:review_page])
    @questions = Question.where(:product_id => @product.id).order("created_at DESC").paginate(:per_page => 10, :page => params[:question_page])    

    friends = @user.friend_ids
    if !friends.nil? and friends.size > 0
      @search_friends_who_owned = MyCollectionItem.search do
        with(:product_id, params[:product_id])
        with(:user_id, friends)
      end
      @search_friends_who_wished = WishlistItem.search do
        with(:product_id, params[:product_id])
        with(:user_id, friends)
      end
    end
    
    @friends_who_owned = @search_friends_who_owned.results.map { |i| i.user } if !@search_friends_who_owned.nil? and @search_friends_who_owned.results.present?
    @friends_who_wished = @search_friends_who_wished.results.map { |i| i.user } if !@search_friends_who_wished.nil? and @search_friends_who_wished.results.present?
    
    @product_comments = @product.comments.order("created_at DESC")
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @product }
    end  
  end

  # POST /my_collection_items
  # POST /my_collection_items.xml
  def create
    logger.info "MyCollectionItemsController => create"
    #@product = Product.find(params[:id])
    @product = Product.find(params[:product_id])
    @my_collection = MyCollection.find_by_id(params[:my_collection_id]) # This change is caused by the use of has_permalink plugin
    
    @my_collection_item = MyCollectionItem.new
    @my_collection_item.my_collection_id = params[:my_collection_id]
    @my_collection_item.product_id = params[:product_id]
    @my_collection_item.user = current_user
        
    #respond_to do |format|
      if @my_collection_item.save
        redirect_to(member_my_collection_path(current_user, @my_collection), :notice => 'My collection item was successfully saved.')
      #if MyCollection.add_product_to_collection(current_user, @product)
      #  format.html { redirect_to(member_my_collection_path(current_user, @my_collection), :notice => 'My collection item was successfully saved.') }
      #  format.html { redirect_to(:controller => 'members', :action => 'collections', :id => current_user.id, :notice => 'My collection was successfully created.') }
      #  format.xml  { render :xml => @my_collection, :status => :created, :location => @my_collection }
      #else
      #  format.html { render :action => "new" }
      #  format.xml  { render :xml => @my_collection.errors, :status => :unprocessable_entity }
      end
    #end
  end

  # DELETE /my_collection_items/1
  # DELETE /my_collection_items/1.xml
  def destroy
    logger.debug "DELETE /my_collection_items/:id"
    #@my_collection_item = MyCollectionItem.find(params[:id])
    @my_collection_item = MyCollectionItem.where("product_id = ? and user_id = ?", params[:product_id], current_user).first
    if !@my_collection_item.nil?
      @my_collection_item.destroy
    end
    #@my_collection = @my_collection_item.my_collection
    #@my_collection_item.destroy

    @product = Product.find(params[:product_id])
    
    respond_to do |format|
      format.html { redirect_to(product_path(@product)) }
      format.xml  { head :ok }
    end
  end
end
