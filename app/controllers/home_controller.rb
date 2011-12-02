class HomeController < ApplicationController

  def index
    if user_signed_in?
      logger.info "HomeController.index - user_signed_in? True"
      redirect_to member_path(current_user)
    else
      logger.info "HomeController.index - user_signed_in? False"
      @user = User.new
    end
  end

  def about_us
    
  end

  def feature_tour
    
  end
  
  def faq
    
  end

end
