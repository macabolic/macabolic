class WishlistItemsController < ApplicationController

  # POST /wishlist_items
  # POST /wishlist_items.xml
  def create
      logger.info "WishlistItemsController => create"
      @product = Product.find(params[:product_id])
      @my_collection = MyCollection.find(params[:my_collection_id]) # This change is caused by the use of has_permalink plugin

      @my_collection_item = MyCollectionItem.new
      @my_collection_item.my_collection_id = params[:my_collection_id]
      @my_collection_item.product_id = params[:product_id]
      @my_collection_item.user = current_user
      @my_collection_item.interest_indicator = MyCollectionItem::WISH

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
    #end
    
    
    #@product = Product.find(params[:product])
    #if Wishlist.defined_default_wishlist?(current_user)
    #  @wishlist = Wishlist.default_wishlist(current_user)
    #else
    #  @wishlist = Wishlist.new(:name => "My Wishlist", :user_id => current_user.id, :default_list => true)
    #end
    
    #if WishlistItem.where("product_id = ?", @product.id).exists?
    #  @wishlist_item = WishlistItem.find_by_product_id(@product.id)
    #else
    #  @wishlist_item = WishlistItem.new
    #  @wishlist_item.product = @product
    #  @wishlist_item.wishlist = @wishlist
    #  @wishlist_item.user = current_user 
    #end

    # if no wishlist defined, use the default wishlist
    #if @wishlist_item.wishlist_id.nil?
      #@wishlist = current_user.create_default_wishlist_if_not_present
      #@wishlist = Wishlist.create_default_if_not_present(current_user)
      #@wishlist_item.wishlist_id = @wishlist.id
    #end
 
    #@wishlist_item.save
    #@action = "create"
#    render :nothing => true
#    respond_to do |format|
#      if @wishlist_item.save
#        format.html { redirect_to(@wishlist_item, :notice => 'Wishlist item was successfully created.') }
#        format.xml  { render :xml => @wishlist_item, :status => :created, :location => @wishlist_item }
#      else
#        format.html { render :action => "new" }
#        format.xml  { render :xml => @wishlist_item.errors, :status => :unprocessable_entity }
#      end
#    end
  end

  # PUT /wishlist_items/1
  # PUT /wishlist_items/1.xml
  def update
    @wishlist_item = WishlistItem.find(params[:id])

    respond_to do |format|
      if @wishlist_item.update_attributes(params[:wishlist_item])
        format.html { redirect_to(@wishlist_item, :notice => 'Wishlist item was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @wishlist_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /wishlist_items/1
  # DELETE /wishlist_items/1.xml
  def destroy
    #@wishlist_item = WishlistItem.find(params[:id])
    #@product = Product.find(params[:product])
    #@wishlist_item = WishlistItem.find_by_product_id(params[:product])    
    #@wishlist_item.destroy

    #respond_to do |format|
    #  format.html { redirect_to(wishlist_items_url) }
    #  format.xml  { head :ok }
    #end
    #@action = "destroy"

    logger.debug "DELETE /my_collection_items/:id"
    @my_collection_item = MyCollectionItem.find(params[:id])
    #@my_collection_item = MyCollectionItem.where("product_id = ? and user_id = ?", params[:product_id], current_user).first
    if !@my_collection_item.nil?
      @my_collection_item.destroy
    end

    @product = Product.find(params[:product_id])
    
    respond_to do |format|
      format.html { redirect_to(product_path(@product)) }
      format.xml  { head :ok }
    end
    
  end
end
