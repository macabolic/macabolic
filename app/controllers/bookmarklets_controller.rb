class BookmarkletsController < ApplicationController
  before_filter :show_invitation_notice
  before_filter :store_location
  before_filter :authenticate_user!, :except =>  [:index, :search, :show]

  def new
    @product = Product.new(:image_url => params[:image_url])
    @user = current_user
    #@product_url = params[:product_url]
    @product_link = @product.build_product_link(:link => params[:product_url], :informer_id => @user.id)

    @price_ranges = PriceRange.order("sort_order ASC")
    @product_target_audiences = ProductTargetAudience.order("sort_order ASC")
    
    @my_collection = MyCollection.new
  	@my_collection.name = ''
  	@my_collection.user = @user
    
    render "products/bookmarklet", :layout => nil
    #redirect_to bookmarklet_products_path(:image_url => params[:image_url])
  end
end