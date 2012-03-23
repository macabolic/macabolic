require 'net/https'
require 'open-uri'

class ProductsController < ApplicationController
  before_filter :show_invitation_notice
  before_filter :store_location
  before_filter :authenticate_user!, :except =>  [:index, :search, :show, :buy_now, :bookmarklet]
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
      
      vendor_id = @product.vendor_id
      same_store_search = Sunspot.search(Product) do
        with(:vendor_id, vendor_id)
        without(:id, params[:id])
        paginate :page => 1, :per_page => 3
      end
      @same_store_items = same_store_search.results

      if user_signed_in?
        @product_link = ProductLink.new(:informer_id => @user.id, :product_id => @product.id)
        @price_ranges = PriceRange.order("sort_order ASC")
        @product_issue = ProductIssue.new(:product_id => @product.id, :reporter_id => @user.id)
      end
      
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
    @product_link = @product.build_product_link(:informer_id => @user.id)

    @price_ranges = PriceRange.order("sort_order ASC")
    @product_target_audiences = ProductTargetAudience.order("sort_order ASC")
    
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
      my_collection_item = MyCollectionItem.new(:my_collection_id => params[:my_collection_id], :user_id => current_user.id, :interest_indicator => MyCollectionItem::WISH)
      logger.debug "building product now..."

      if params[:product_link].present?
        params[:product][:product_link_attributes] = { :informer_id => current_user.id, :link => params[:product_link] }
      end

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
    else # No collection selected
      
      if params[:create_new].present? && params[:create_new] == "yes"
        my_collection = MyCollection.new(:name => params[:my_collection_name], :user_id => current_user.id)
        
        # now build the [:my_collection_item]
        param_my_collection = Hash.new
        param_my_collection[:my_collection_item] = Hash.new
        param_my_collection[:my_collection_item][:user_id] = current_user.id
        param_my_collection[:my_collection_item][:interest_indicator] = MyCollectionItem::WISH
        params[:product][:product_link_attributes] = { :informer_id => current_user.id, :link => params[:product_link] }
        if params[:vendor_name].present?
          @vendor_search_results = Vendor.where("name = ?", params[:vendor_name])
          if @vendor_search_results.size > 0
            vendor = @vendor_search_results[0]
            params[:product][:vendor_id] = vendor.id
          else
            params[:product][:vendor_attributes] = { :name => params[:vendor_name] }
          end
        end 
        param_my_collection[:my_collection_item][:product_attributes] = params[:product]
        my_collection.my_collection_items.build(param_my_collection[:my_collection_item])
        
        logger.debug "#{param_my_collection[:my_collection_item]}"
        
        # .. then save
        if my_collection.save
          logger.debug "save my collection properly... and about to redirect."
          redirect_to(my_collection_path(my_collection)) 
        else
          logger.debug "found problem while saving my collection item, go back to fix the problem."
          respond_to do |format|
            format.html { render :action => "new" }
            format.xml  { render :xml => my_collection_item.errors, :status => :unprocessable_entity }
          end
        end
        
      else
      
        if params[:product_link].present?
          @product.build_product_link(:informer_id => current_user.id, :link => params[:product_link])
        end
      
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
            post_to_facebook(@product)
            
            format.html { redirect_to(product_path(@product), :notice => 'Product was successfully saved.') }
            format.xml  { render :xml => @product, :status => :created, :location => @product }          
          else
            format.html { render :action => "new" }
            format.xml  { render :xml => @product.errors, :status => :unprocessable_entity }      
          end
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
    logger.debug "ProductsController.like."
    if response.save
      logger.debug "#{response.user.full_name} likes #{response.product.name}."
    end
    
    @number_of_likes = @product.responses.size
  end
  
  def unlike
    @product = Product.find(params[:id])
    response = ProductResponse.where(:product_id => @product.id, :user_id => current_user.id)    
    logger.debug "ProductsController.unlike."
    if response.exists?
      response.first.destroy #destroy the first one and always expect only one for each user and collection.
      logger.debug "#{response.first.user.full_name} unlikes #{response.first.product.name}."
    end
    
    @number_of_likes = @product.responses.size
  end
  
  def buy_now
    product = Product.find(params[:id])
    link = product.product_link.link
    if link.present?
      redirect_to link
    else
      redirect_to product_path(product)
    end    
  end
  
  def suggest_where
    
  end
  
  def report_issue
    logger.debug "Product #{}"
    product_issue = ProductIssue.new(params[:product_issue])
    product_issue.save
  end
  
  private
  
  def sort_column
    params[:sort] || "name"
    Product.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
  end
  
  def post_to_facebook(product)
    if current_user.facebook_authenticated?
      facebook = current_user.facebook
      # Post the message to current_user's feed
      post_url = "https://graph.facebook.com/#{facebook.uid}/feed"
      
      message = "I have just discovered #{product.name}."
      link = product_url(product)
    	if product.thumbnail.present?
    		picture = "http://#{HOST}#{product.thumbnail.url(:medium)}"
    	else product.image_url.present?
    		picture = product.image_url
    	end
      name = product.name
      description = product.description if product.description.present?
      
      logger.debug "Post URL: #{post_url}."
      logger.debug "Message: #{message}."
      logger.debug "Link: #{link}."
      logger.debug "Name: #{name}."
      logger.debug "Description: #{description}"
      
      data = {  'message' => message,
                'link' => link,
                'picture' => picture,
                'name' => name,
                'description' => description
              }
      
      url = URI.parse(post_url)
      req = Net::HTTP::Post.new(url.path)
      req.form_data = data
      #req.basic_auth url.user, url.password if url.user
      con = Net::HTTP.new(url.host, url.port)
      con.use_ssl = true
      con.start {|http| http.request(req)}      
    end
  end
    
end
