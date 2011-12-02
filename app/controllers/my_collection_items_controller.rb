class MyCollectionItemsController < ApplicationController

  # GET /my_collection_items/1
  # GET /my_collection_items/1.xml
  def show
    logger.debug "GET /my_collection_items/:id"
    @my_collection_item = MyCollectionItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @my_collection_item }
    end
  end

  # POST /my_collection_items
  # POST /my_collection_items.xml
  def create
    logger.info "MyCollectionItemsController => create"
    #@product = Product.find(params[:id])
    @product = Product.find(params[:product])
    @my_collection = MyCollection.find(params[:my_collection_id])
    
    @my_collection_item = MyCollectionItem.new
    @my_collection_item.my_collection_id = params[:my_collection_id]
    @my_collection_item.product_id = params[:product]
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
    @my_collection_item = MyCollectionItem.find(params[:id])
    @my_collection = @my_collection_item.my_collection
    @my_collection_item.destroy

    respond_to do |format|
      format.html { redirect_to(edit_member_my_collection_url(current_user, @my_collection)) }
      format.xml  { head :ok }
    end
  end
end
