class MyCollectionsController < ApplicationController
  #before_filter :show_invitation_notice
  before_filter :require_invitation, :only => [ :new ]
  before_filter :store_location
  before_filter :authenticate_user!, :except => [:show]

  # GET /my_collections/1
  # GET /my_collections/1.xml
  def show
    @my_collection = MyCollection.find(params[:id])
    #@my_collection = MyCollection.find_by_permalink(params[:id])
    @user = @my_collection.user #if user_signed_in?
    @my_collection_comments = @my_collection.comments.order("created_at DESC")
    @followers = @my_collection.followers
    @followers = @followers.map(&:follower)
    
    @responses = @my_collection.responses

		#@my_collection_items = @my_collection.my_collection_items.page params[:collection_items_page]
    @owned_collection_items = @my_collection.owned_collection_items.page params[:owned_collection_items_page]
    @wished_collection_items = @my_collection.wished_collection_items.page params[:wished_collection_items_page]
    
    @user_other_collection_items = @user.my_collection_items.order("updated_at ASC").limit(3)
    
#    ids = @user.friends.map { |i| i.id }
#    ids.insert(0, @user.id)
    
#    @search = MyCollectionItem.search do
#      with(:user_id).any_of ids
#      facet(:product_name)
#      with(:my_collection_id, params[:id])
#    end
#    @collection_items = @search.results

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @my_collection }
    end
  end
  
  # GET /my_collections/new
  # GET /my_collections/new.xml
  def new
    # Step 3 on the registration.
    # Show only the production from Apple
    
    r = [ ]
    while r.length < 31 
      v = rand(Product.all.size)
      r << v unless r.include? v
    end
    
    @search = Sunspot.search(Product) do
      #fulltext "Apple Inc.", :fields => [:vendor_name]
      #with(:product_line_id, [1, 3, 4, 5])
      with(:id, r)
      #paginate :page => 1, :per_page => 100
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
    #@my_collection = MyCollection.find_by_permalink(params[:id])
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
        @user = User.find(@my_collection.user_id)
        @my_collections = @user.my_collections
        @my_collection_items = @user.my_collection_items        
        format.html { render "members/collections" }
      #  format.xml  { render :xml => @my_collection.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /my_collections/1
  # PUT /my_collections/1.xml
  def update
    @my_collection = MyCollection.find(params[:id])
    #@my_collection = MyCollection.find_by_permalink(params[:id])

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
    #@my_collection = MyCollection.find_by_permalink(params[:id])
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
    
  def mass_create
    @my_collection = MyCollection.new(params[:my_collection])
    logger.debug "MyCollectionsController.mass_create - #{@my_collection}."
    logger.debug "MyCollectionsController.mass_create - #{@my_collection.my_collection_items}."
    # 1. loop the my_collection_items
    # 2. for each my_collection_item
    # 3. create a my_collection
    # 4. my_collection.name = 'My #{my_collection_item.product.name} Collection'
    # 5. my_collection.my_collection_items.add my_collection_item
    # 6. my_collection.save
    @my_collection.name = 'My Untitled Collection'
    @my_collection.user_id = current_user.id
    @my_collection_items = @my_collection.my_collection_items
    #@my_collection_items.each do |my_collection_item|
      #@new_my_collection = MyCollection.new
      #@new_my_collection.name = 'My ' + my_collection_item.product.name + ' Collection'
      #@new_my_collection.user_id = current_user.id
      #@new_my_collection.my_collection_items.build(:product_id => my_collection_item.product.id, :user_id => current_user.id, :interest_indicator => 1)
      #logger.debug "#{@new_my_collection.to_yaml}"
      #@new_my_collection.save
    #end    
    logger.debug "#{@my_collection.to_yaml}"
    @my_collection.save
    UserMailer.welcome(current_user).deliver
    
    respond_to do |format|
      format.html { redirect_to profile_member_path(current_user) }
      #format.xml  { render :xml => @invitation, :status => :created, :location => @invitation }
    end    
  end
  
  def skip
    UserMailer.welcome(current_user).deliver

    respond_to do |format|
      format.html { redirect_to profile_member_path(current_user) }
      #format.xml  { render :xml => @invitation, :status => :created, :location => @invitation }
    end
  end

  def follow
    @my_collection = MyCollection.find(params[:id])
    #@my_collection = MyCollection.find_by_permalink(params[:id])
    follower = MyCollectionFollower.new(:my_collection => @my_collection, :follower => current_user)    
    logger.debug "MyCollectionsController.follow."
    if follower.save
      logger.debug "#{follower.follower.full_name} is following #{follower.my_collection.name}."
    end
    
    @number_of_followers = @my_collection.followers.size
  end

  def unfollow
    @my_collection = MyCollection.find(params[:id])
    #@my_collection = MyCollection.find_by_permalink(params[:id])
    follower = MyCollectionFollower.where(:my_collection_id => @my_collection.id, :follower_id => current_user.id)    
    logger.debug "MyCollectionsController.unfollow."
    if follower.exists?
      follower.first.destroy #destroy the first one and always expect only one for each user and collection.
      logger.debug "#{follower.first.follower.full_name} is unfollowing #{follower.first.my_collection.name}."
    end
    
    @number_of_followers = @my_collection.followers.size    
  end
  
  def like
    @my_collection = MyCollection.find(params[:id])
    #@my_collection = MyCollection.find_by_permalink(params[:id])
    response = MyCollectionResponse.new(:my_collection => @my_collection, :user => current_user)    
    logger.debug "MyCollectionsController.like."
    if response.save
      logger.debug "#{response.user.full_name} likes #{response.my_collection.name}."
    end
    
    @number_of_likes = @my_collection.responses.size
  end
  
  def unlike
    @my_collection = MyCollection.find(params[:id])
    #@my_collection = MyCollection.find_by_permalink(params[:id])
    response = MyCollectionResponse.where(:my_collection_id => @my_collection.id, :user_id => current_user.id)    
    logger.debug "MyCollectionsController.unlike."
    if response.exists?
      response.first.destroy #destroy the first one and always expect only one for each user and collection.
      logger.debug "#{response.first.user.full_name} unlikes #{response.first.my_collection.name}."
    end
    
    @number_of_likes = @my_collection.responses.size
  end
  
  def thumbnail_view
    @user = current_user
    @my_collections = current_user.my_collections
    @my_collection = MyCollection.new
  	@my_collection.name = ''
  	@my_collection.user = @user    
  end
  
  private 
  def require_invitation
    if current_user.invitation_id.nil?
      redirect_to home_index_path # halts request cycle
    end
  end
end
