class HomeController < ApplicationController
  #before_filter :show_invitation_notice, :except => [ :about_us, :faq, :home, :contact_us, :extra ]
  
  def index
    if user_signed_in?
      logger.debug "HomeController.index - user_signed_in? True"
      redirect_to member_path(current_user)
    else
      logger.debug "HomeController.index - user_signed_in? False"
      @user = User.new
    end
  end

  def about_us
    
  end

  def contact_us
    
  end

  #def feature_tour
    
  #end
  
  def faq
    
  end
  
  def home
    #if user_signed_in?
      @user = current_user
    #end
    
    #list_of_product_line_ids = [6, 13, 15, 20]
    list_of_product_line_ids = ProductLine.all.map(&:id)
    #me_and_my_friends = @friends.map(&:id)
    @heat_map_search = Sunspot.search(Product) do      
      with(:product_line_id, list_of_product_line_ids)
      facet :product_line_id
    end
    
    @user_heat_map_search = Sunspot.search(MyCollectionItem) do
      facet :user_id
    end
    
    @featured_products = Product.limit(36).order("updated_at DESC")
    
    #@feature_collection_items = Array.new
    #recently_active_users = User.active_users.limit(3)
    #most_active_users = User.where("sign_in_count > ?", 10).order("sign_in_count DESC").limit(3)
    #recently_active_users.each do |user|
    #  user_id = user.id
    #  featured_collection_items_search = Sunspot.search(MyCollectionItem) do
    #    with(:user_id, user_id)
    #    order_by(:updated_at, :desc)
    #    paginate  :page => 1, :per_page => 6
    #  end
    #  @feature_collection_items << featured_collection_items_search.results
    #end
    
    #@featured_collections_items = featured_collections_items_search.results
    @most_recent_collections = MyCollection.where("my_collection_items_count > 0").order("updated_at DESC").limit(9)
  end

  def extra
    
  end
    
  def discover
    #@products = Product.order("updated_at DESC").page(params[:page]).per(9)
		
		# Everything - "all" => All
		# For Mac - "mac" => Laptop, Desktop, Bags & Notebook cases, Storage, Display & Graphics, Networks, Mouse and Keyboard
		# For iPad - "ipad" => iPad, iOS, Audio & Speakers, Headphones, iOS App-Enabled, iPad Cases & Stands, iPad Accessories
		# For iPhone - "iphone" => iOS, Audio & Speakers, Headphones, iOS App-Enabled, iPhone Cases, iPhone / iPod Docks & Stands, iPhone / iPod Chargers, iPhone Accessories
		# For iPod - "ipod" => iPod, iOS, Audio & Speakers, Headphones, iOS App-Enabled, iPod Cases, iPhone / iPod Docks & Stands, iPhone / iPod Chargers
		# For audiophile - "audiophile" => Audio & Speakers, Headphones
		# Others - "others" => Something Extra
		# Popular ones - "popular" => most updated MyCollectionItems
		
		# For Everyone - everyone
		# For Him - him
		# For Her - her
		# For Little One - little
		if params[:category] == "popular"
		  search_my_collection_items = Sunspot.search(MyCollectionItem) do
		    order_by(:updated_at, :desc)
		    paginate :page => params[:page], :per_page => 9
      end
      @listed_items = search_my_collection_items.results
      @products = @listed_items.map(&:product)      
    else 
      product_line_ids = browse(params[:category])
      logger.debug "Proudct line ids: #{product_line_ids}."
      search_products = Sunspot.search(Product) do
        with(:product_line_id, product_line_ids)
        order_by(:updated_at, :desc)
        paginate :page => params[:page], :per_page => 9
      end
      @listed_items = search_products.results
      @products = search_products.results
    end
    
    @category = category_name(params[:category])
    
    @stores = Vendor.order("products_count DESC").limit(10)
  end
  
  private
  
  def category_name(category)
    if category == "all"
      "Everything"
    elsif category == "mac"
      "For Mac"
    elsif category == "ipad"
      "For iPad"
    elsif category == "iphone"
      "For iPhone"
    elsif category == "ipod"
      "For iPod"
    elsif category == "audiophile"
      "For audiophile"
    elsif category == "others"
      "Others"
    elsif category == "popular"
      "Popular Ones"
    else
      
    end    
  end
  
  def browse(category)
    if category == "all"
      [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
    elsif category == "mac"
      [1, 3, 7, 9, 10, 2, 8]      
    elsif category == "ipad"
      [4, 15, 20, 6, 12]
    elsif category == "iphone"
      [4, 13, 14, 17, 18, 19, 6, 12]
    elsif category == "ipod"
      [5, 4, 6, 12, 13, 16, 17, 18]
    elsif category == "audiophile"
      [6, 12]
    elsif category == "others"
      [11]
    else
      [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
    end
  end  
  
end
