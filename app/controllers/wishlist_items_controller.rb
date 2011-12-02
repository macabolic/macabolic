class WishlistItemsController < ApplicationController
  # GET /wishlist_items
  # GET /wishlist_items.xml
  def index
    @wishlist_items = WishlistItem.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @wishlist_items }
    end
  end

  # GET /wishlist_items/1
  # GET /wishlist_items/1.xml
  def show
    @wishlist_item = WishlistItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @wishlist_item }
    end
  end

  # POST /wishlist_items
  # POST /wishlist_items.xml
  def create
    @product = Product.find(params[:product])
    if Wishlist.defined_default_wishlist?(current_user)
      @wishlist = Wishlist.default_wishlist(current_user)
    else
      @wishlist = Wishlist.new(:name => "My Wishlist", :user_id => current_user.id, :default_list => true)
    end
    
    if WishlistItem.where("product_id = ?", @product.id).exists?
      @wishlist_item = WishlistItem.find_by_product_id(@product.id)
    else
      @wishlist_item = WishlistItem.new
      @wishlist_item.product = @product
      @wishlist_item.wishlist = @wishlist
      @wishlist_item.user = current_user 
    end

    # if no wishlist defined, use the default wishlist
    #if @wishlist_item.wishlist_id.nil?
      #@wishlist = current_user.create_default_wishlist_if_not_present
      #@wishlist = Wishlist.create_default_if_not_present(current_user)
      #@wishlist_item.wishlist_id = @wishlist.id
    #end
 
    @wishlist_item.save
    @action = "create"
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
    @product = Product.find(params[:product])
    @wishlist_item = WishlistItem.find_by_product_id(params[:product])    
    @wishlist_item.destroy

    #respond_to do |format|
    #  format.html { redirect_to(wishlist_items_url) }
    #  format.xml  { head :ok }
    #end
    @action = "destroy"
    
  end
end
