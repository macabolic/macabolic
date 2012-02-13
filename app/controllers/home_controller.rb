class HomeController < ApplicationController
  before_filter :show_invitation_notice, :except => [ :about_us, :feature_tour, :faq, :home, :contact_us ]
  
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

  def contact_us
    
  end

  def feature_tour
    
  end
  
  def faq
    
  end

  def home
    
  end
  
end
