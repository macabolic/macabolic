class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def set_locale
    I18n.locale = params[:locale]
  end

  def self.default_url_options(options={})
    options.merge({ :locale => I18n.locale })
  end

  def store_location
    logger.debug "Store location: url=#{request.url}"
    session["user_return_to"] = request.url if request.get? && !request.xhr?
  end

  def show_invitation_notice
    if user_signed_in? && current_user.invitation_id.nil?
      @user = User.new
      @notice = "We are on invitation right now. We will let you know when your invitation is sent out."
      render "home/home"
    end    
  end
  
end
