class MyCollectionsController < ApplicationController

  # GET /my_collections/1
  # GET /my_collections/1.xml
  def show
    @my_collection = MyCollection.find(params[:id])
    @user = @my_collection.user

    ids = @user.friends.map { |i| i.id }
    ids.insert(0, @user.id)
    
    @search = MyCollectionItem.search do
      with(:user_id).any_of ids
      facet(:product_name)
#      with(:my_collection_id, params[:id])
    end
    @collection_items = @search.results
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @my_collection }
    end
  end
  
  # GET /my_collections/new
  # GET /my_collections/new.xml
  def new
    @search = Product.search do
      fulltext "apple"
    end
    @products = @search.results

    
    #@my_collection = MyCollection.new
    #@products.size.times do
      @my_collection = current_user.my_collections.build
      @my_collection_item = @my_collection.my_collection_items.build
    #end    

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @my_collection }
    end
  end  

  # GET /my_collections/1/edit
  def edit
    @my_collection = MyCollection.find(params[:id])
    @user = @my_collection.user
  end

  # POST /my_collections
  # POST /my_collections.xml
  def create
    @my_collection = MyCollection.new(params[:my_collection])

    respond_to do |format|
      if @my_collection.save
        format.html { redirect_to(member_my_collection_path(current_user, @my_collection), :notice => 'My collection was successfully created.') }
      #  format.xml  { render :xml => @my_collection, :status => :created, :location => @my_collection }
      else
      #  format.html { render :action => "new" }
      #  format.xml  { render :xml => @my_collection.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /my_collections/1
  # PUT /my_collections/1.xml
  def update
    @my_collection = MyCollection.find(params[:id])

    respond_to do |format|
      if @my_collection.update_attributes(params[:my_collection])
        format.html { redirect_to(member_my_collection_path(current_user, @my_collection), :notice => 'My collection was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @my_collection.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /my_collections/1
  # DELETE /my_collections/1.xml
  def destroy
    @my_collection = MyCollection.find(params[:id])
    @my_collection.destroy

    respond_to do |format|
      format.html { redirect_to(collections_member_path(current_user)) }
      format.xml  { head :ok }
    end
  end
  
  # Add product which accepts a product id
  # 
  def add_product
    # @my_collection = MyCollection.new(params[:my_collection])

    @product = Product.find(params[:id])

    respond_to do |format|
      #if @my_collection.save
      if MyCollection.add_product_to_collection(current_user, @product)
        format.html { redirect_to(:controller => 'members', :action => 'collections', :id => current_user.id, :notice => 'My collection was successfully created.') }
        format.xml  { render :xml => @my_collection, :status => :created, :location => @my_collection }
      #else
      #  format.html { render :action => "new" }
      #  format.xml  { render :xml => @my_collection.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def vote
    logger.info "vote for the my collection..."
    logger.info "vote value: #{params[:vote]}"
    # 1. Check if the current_user has an entry in the answer_response.
    @my_collection_response = MyCollectionResponse.where("user_id = ? and my_collection_id = ?", current_user.id, params[:id])
    if @my_collection_response.exists?
      logger.info "My Collection Response exists: #{@my_collection_response.first}." 
      if @my_collection_response.first.update_attributes(:response_for => params[:vote])     
        logger.info "My Collection response updated: #{params[:vote]}"
      else
        logger.info "Some problem updating the my collection response: #{@my_collection_response.first.errors}"
      end
    else
      @my_collection_response = MyCollectionResponse.new
      @my_collection_response.my_collection_id = params[:id]
      @my_collection_response.response_for = params[:vote]
      @my_collection_response.user = current_user
      
      if @my_collection_response.save
        logger.info "My Collection Response newly created: #{@my_collection_response}."
      else
        logger.info "Sorry, for some reason your vote is not valid!"
      end
    end
    
    @my_collection_id = params[:id]
    @vote = params[:vote]
    @vote_like_count = MyCollectionResponse.where("my_collection_id = ?", params[:id]).vote_like.size
  end  
  
  def mass_create
    @my_collection = MyCollection.new(params[:my_collection])
    logger.info "MyCollectionsController.mass_create - #{@my_collection}."
    logger.info "MyCollectionsController.mass_create - #{@my_collection.my_collection_items}."
    # 1. loop the my_collection_items
    # 2. for each my_collection_item
    # 3. create a my_collection
    # 4. my_collection.name = 'My #{my_collection_item.product.name} Collection'
    # 5. my_collection.my_collection_items.add my_collection_item
    # 6. my_collection.save
    @my_collection_items = @my_collection.my_collection_items
    @my_collection_items.each do |my_collection_item|
      @new_my_collection = MyCollection.new
      @new_my_collection.name = 'My ' + my_collection_item.product.name + ' Collection'
      @new_my_collection.user_id = current_user.id
      @new_my_collection.my_collection_items.build(:product_id => my_collection_item.product.id, :user_id => current_user.id)
      logger.info "#{@new_my_collection.to_yaml}"
      @new_my_collection.save
    end    

    respond_to do |format|
      format.html { redirect_to profile_member_path(current_user) }
      #format.xml  { render :xml => @invitation, :status => :created, :location => @invitation }
    end    
  end
  
  def skip
    respond_to do |format|
      format.html { redirect_to profile_member_path(current_user) }
      #format.xml  { render :xml => @invitation, :status => :created, :location => @invitation }
    end
  end

end
