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
          @my_collection = MyCollection.find(params[:my_collection])
        end
      end
    end
  end
    
  # GET /products/1
  # GET /products/1.xml
  def show
    @my_collection_item = MyCollectionItem.find(params[:my_collection_item_id]) if params[:my_collection_item_id].present?
    @user = @my_collection_item.user if @my_collection_item
    @user = current_user if !@user.present?
    @product = Product.find(params[:id])
    @reviews = Review.where(:product_id => @product.id).order("created_at DESC").paginate(:per_page => 2, :page => params[:review_page])
    @questions = Question.where(:product_id => @product.id).order("created_at DESC").paginate(:per_page => 2, :page => params[:question_page])    

    @search_people_who_owned = MyCollectionItem.search do
      with(:product_id, params[:id])
    end

    @search_people_who_wished = WishlistItem.search do
      with(:product_id, params[:id])
    end
    
    @people_who_owned = @search_people_who_owned.results.map { |i| i.user }
    @people_who_wished = @search_people_who_wished.results.map { |i| i.user }
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @product }
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
      @my_collection = MyCollection.find(params[:my_collection_id])
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
  
  
  private
  
  def sort_column
    params[:sort] || "name"
    Product.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
  end
    
end
