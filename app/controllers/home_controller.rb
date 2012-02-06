class HomeController < ApplicationController
  def index
    if user_signed_in?
      logger.info "HomeController.index - user_signed_in? True"
      if current_user.invitation_id.nil?
        @user = User.new
        @notice = "We are on invitation right now. We will let you know when your invitation is sent out."
        render :action => "index"
      else
        redirect_to member_path(current_user)
      end
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
