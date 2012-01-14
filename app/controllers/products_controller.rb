class ProductsController < ApplicationController
  helper_method :sort_column, :sort_direction

  # GET /products
  # GET /products.xml
  def index
    if params[:search].nil? or params[:search].length == 0
      
    else
      if params[:search].length > 2
        @search = Product.search do
          fulltext params[:search]
        end
        @products = @search.results
        #@products = Product.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 10, :page => params[:page])
        if !params[:my_collection].nil?
          @my_collection = MyCollection.find_by_id(params[:my_collection])
        end
      end
    end
  end
    
  # GET /products/1
  # GET /products/1.xml
  def show        
    @product = Product.find(params[:id])
    @user = current_user
    
    if @user.own_this_product?(@product)
      @my_collection_item = MyCollectionItem.where("user_id = ? and product_id = ?", @user.id, @product.id).first
      redirect_to product_my_collection_item_path(@product, @my_collection_item), :status => 301
    else 
      @questions = Question.where(:product_id => @product.id).order("created_at DESC").paginate(:per_page => 10, :page => params[:question_page])    
    
      friends = @user.friend_ids
      @search_friends_who_owned = MyCollectionItem.search do
        with(:product_id, params[:id])
        with(:user_id, friends)
      end

      @search_friends_who_wished = WishlistItem.search do
        with(:product_id, params[:id])
        with(:user_id, friends)
      end
    
      @friends_who_owned = @search_friends_who_owned.results.map { |i| i.user }
      @friends_who_wished = @search_friends_who_wished.results.map { |i| i.user }
    
      @product_comments = @product.comments.order("created_at DESC")
    
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
  
  # POST /products
  # POST /products.xml
  def create
    @product = Product.new(params[:product])

    if params[:my_collection_id].present?
      my_collection_item = MyCollectionItem.new(:my_collection_id => params[:my_collection_id], :user_id => current_user.id)
      my_collection_item.product = @product
      my_collection_item.save!
      @my_collection = MyCollection.find_by_id(params[:my_collection_id]) # This change is caused by the use of has_permalink plugin
      redirect_to(my_collection_path(@my_collection)) 
    else
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
  
  def product_search
    respond_to do |format|
      format.html 
      format.xml  { render :xml => @product }
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
