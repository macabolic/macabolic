class ProductsController < ApplicationController
  before_filter :show_invitation_notice
  before_filter :store_location
  before_filter :authenticate_user!, :except =>  [:index, :search, :show]
  helper_method :sort_column, :sort_direction

  # GET /products
  # GET /products.xml
  def index
    if params[:search].nil? or params[:search].length == 0
      
    else
      if params[:search].length > 2
        search = Sunspot.search(Product) do
          fulltext params[:search]
        end

        @products = search.results        
        if !params[:my_collection].nil?
          @my_collection = MyCollection.find_by_id(params[:my_collection])
        end
        
        respond_to do |format|
          format.html # show.html.erb
          format.xml { render :xml => @products.to_xml(:include => @my_collection) }
          format.js
          format.json { render :json => @products }
        end  
        
      end
    end
  end
    
  # GET /products/1
  # GET /products/1.xml
  def show        
    @product = Product.find(params[:id])
    @user = current_user
    
    if @user.present? && @user.own_this_product?(@product)
      @my_collection_item = MyCollectionItem.where("user_id = ? and product_id = ?", @user.id, @product.id).first
      redirect_to product_my_collection_item_path(@product.id, @my_collection_item.id), :status => 301
    else 
      # Allow public access.
      @questions = Question.where(:product_id => @product.id).order("created_at DESC").page params[:question_page]

      search_more_like_this = Sunspot.more_like_this(@product) do
        fields :name, :category_name
      end
      @more_like_this = search_more_like_this.results
      
      #friends = @user.friend_ids
      friends = MyCollectionItem.all.map(&:user_id)
      if friends.size > 0
        @search_friends_who_owned = Sunspot.search(MyCollectionItem) do
          with(:product_id, params[:id])
          with(:user_id, friends)
          with(:interest_indicator, 1)          
        end
      
        @search_friends_who_wished = Sunspot.search(MyCollectionItem) do
          with(:product_id, params[:id])
          with(:user_id, friends)
          with(:interest_indicator, 2)          
        end
      
        @friends_who_owned = @search_friends_who_owned.results.map { |i| i.user }
        @friends_who_wished = @search_friends_who_wished.results.map { |i| i.user }
      end
    
      @product_comments = @product.comments.order("created_at DESC")
      
      my_collection_item_search = Sunspot.search(MyCollectionItem) do
        with(:product_id, params[:id])
      end
      @found_collection_items = my_collection_item_search.results
      @found_collections = @found_collection_items.map { |i| i.my_collection }
      
      # Put a comment here when found out the purpose of it.
      #@my_collections = current_user.my_collections
    
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @product }
      end  
    end
    
  end
  
  # GET /products/new
  # GET /productss/new.xml
  def new
    @product = Product.new
    @user = current_user
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @product }
    end
  end
  
  def bookmarklet
    @product = Product.new(:image_url => params[:image_url])
    @user = current_user
  end
  
  # POST /products
  # POST /products.xml
  def create
    @product = Product.new(params[:product])
    @user = current_user

    logger.debug "============================="
    logger.debug "Product Creation: "
    logger.debug "name = #{@product.name}"
    logger.debug "product_line = #{@product.product_line_id}"
    logger.debug "vendor = #{params[:vendor_name]}"
    logger.debug "my_collection_id = #{params[:my_collection_id]}"
    logger.debug "============================="
    
    if params[:my_collection_id].present?
      my_collection_item = MyCollectionItem.new(:my_collection_id => params[:my_collection_id], :user_id => current_user.id)
      logger.debug "building product now..."

      if params[:vendor_name].present?
        @vendor_search_results = Vendor.where("name = ?", params[:vendor_name])
        if @vendor_search_results.size > 0
          vendor = @vendor_search_results[0]
          params[:product][:vendor_id] = vendor.id
          logger.debug "Value is the hash of params[:product]: #{params[:product]}"
          my_collection_item.build_product( params[:product] )
          logger.debug "Found the vendor in the database."
        else
          logger.debug "Couldn't find the vendor in the database, now building one."
          params[:product][:vendor_attributes] = { :name => params[:vendor_name] }
          logger.debug "Value is the hash of params[:product]: #{params[:product]}"
          my_collection_item.build_product( params[:product] )
        end
      end

      if my_collection_item.save
        logger.debug "save my collection item properly... and about to redirect."
        @my_collection = MyCollection.find_by_id(params[:my_collection_id]) # This change is caused by the use of has_permalink plugin
        redirect_to(my_collection_path(@my_collection)) 
      else
        logger.debug "found problem while saving my collection item, go back to fix the problem."
        respond_to do |format|
          format.html { render :action => "new" }
          format.xml  { render :xml => my_collection_item.errors, :status => :unprocessable_entity }
        end
      end
    else
      
      if params[:vendor_name].present?
        @vendor_search_results = Vendor.where("name = ?", params[:vendor_name])
        if @vendor_search_results.size > 0
          @product.vendor = @vendor_search_results[0]
          logger.debug "Found the vendor in the database."
        else
          logger.debug "Couldn't find the vendor in the database, now building one."
          @product.build_vendor(:name => params[:vendor_name])
        end
      end
      
      respond_to do |format|
        if @product.save
          format.html { redirect_to(product_path(@product), :notice => 'Product was successfully saved.') }
          format.xml  { render :xml => @product, :status => :created, :location => @product }          
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @product.errors, :status => :unprocessable_entity }      
        end
      end
    end
  end
  
  def search
    #respond_to do |format|
    #  format.html 
    #  format.xml  { render :xml => @product }
    #  format.json { render :json => @product }
    #end    
    if params[:search].nil? or params[:search].length == 0
      
    else
      if params[:search].length > 2
        search = Sunspot.search(Product) do
          fulltext params[:search]
        end

        @products = search.results        
        if !params[:my_collection].nil?
          @my_collection = MyCollection.find_by_id(params[:my_collection])
        end
        
        respond_to do |format|
          format.html # show.html.erb
          format.xml { render :xml => @products.to_xml(:include => @my_collection) }
          format.js
          format.json { render :json => @products }
        end  
        
      end
    end    
  end

  def like
    @product = Product.find(params[:id])
    response = ProductResponse.new(:product => @product, :user => current_user)    
    logger.info "ProductsController.like."
    if response.save
      logger.info "#{response.user.full_name} likes #{response.product.name}."
    end
    
    @number_of_likes = @product.responses.size
  end
  
  def unlike
    @product = Product.find(params[:id])
    response = ProductResponse.where(:product_id => @product.id, :user_id => current_user.id)    
    logger.info "ProductsController.unlike."
    if response.exists?
      response.first.destroy #destroy the first one and always expect only one for each user and collection.
      logger.info "#{response.first.user.full_name} unlikes #{response.first.product.name}."
    end
    
    @number_of_likes = @product.responses.size
  end
  
  
  private
  
  def sort_column
    params[:sort] || "name"
    Product.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
  end
    
end
