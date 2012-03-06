class HomeController < ApplicationController
  before_filter :show_invitation_notice, :except => [ :about_us, :feature_tour, :faq, :home, :contact_us, :extra ]
  
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

  def feature_tour
    
  end
  
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
  end

  def extra
    
  end
    
end
