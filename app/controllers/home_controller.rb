class HomeController < ApplicationController  
  def index
    if !logged_in?
      @user = User.new
    else 
      redirect_to :action => "show", :id => current_user.id
    end
  end

#  def profile
#    @my_collection = MyCollection.find(:first, :conditions => ["user_id = ?", current_user.id])    
#    @my_collection_details = MyCollectionDetail.find(:all, :conditions => ["my_collection_id = ?", @my_collection.id])
#    logger.info "There are a total of #{@my_collection_details.size} my_collection_detail(s) to list out."      
#  end
  
  def show
    @my_collection = MyCollection.find(:first, :conditions => ["user_id = ?", params[:id]])    
    @my_collection_details = MyCollectionDetail.find(:all, :conditions => ["my_collection_id = ?", @my_collection.id]) if !@my_collection.nil?
    #logger.info "There are a total of #{@my_collection_details.size} my_collection_detail(s) to list out."          
    @post = Post.new
    
    @my_posts = Post.related_to_me(current_user)
    # Sort in descending order.
    
  end
      
end
