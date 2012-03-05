class RegistrationsController < Devise::RegistrationsController

  def new
    logger.info "Entering the RegistrationsController#new..."

    # check if there is a token.
    # if token, -> invited by someone
    if !params[:invitation_token].nil? && !params[:invitation_token].empty?
      @invitation = Invitation.where("token = ?", params[:invitation_token]).first
      logger.debug "the invitation is for #{@invitation.recipient_email}."
      @sender = @invitation.sender
      #logger.debug "and the sender is #{@sender.full_name}."
    end      
    # else -> regular registration
    
    #if session['devise.facebook_data'].present?
    #  logger.info "Session name: #{session['devise.facebook_data']}"
    #  @user = User.find_by_email(session['devise.facebook_data']['user_info']['email'])
    #  logger.info "User #{@user}"
    #end

    super            
  end
  
  def edit
    
  end
  
  def create
    super
    session[:omniauth] = nil unless @user.new_record?

    @user.update_attributes(params[:user])
    if !params[:invitation_token].nil? && !params[:invitation_token].empty?
      # 1. Update invitation on the accepted date
      @invitation = Invitation.where("token = ?", params[:invitation_token]).first
      @invitation.accepted_at = Time.now
      @invitation.update_attribute("accepted_at", Time.now)
      
      # 2. Add as a friend to the sender
      if @invitation.sender
        @friendship = @user.friendships.build(:friend_id => @invitation.sender.id)
        @friendship.save

        @inverse_friendship = @invitation.sender.friendships.build(:friend_id => @user.id)
        @inverse_friendship.save      
      end
    end
    
    # TODO: comment out because of the routing error - 17 Nov 2011.
    #redirect_to new_invitation_path(@user)
  end
  
  #user.authentications.create!(data['provider'], data['id'])
  protected
  
  def after_sign_up_path_for(resource)
    new_invitation_path :email => resource.email, :origin => params[:origin]
  end
  
  def after_inactive_sign_up_path_for(resource)
    logger.info "Customized after_inactive_sign_up_path_for()."
    super
  end
  
  private
  
  def build_resource(*args)
    super
    if session['devise.facebook_data'].present?
      logger.info "###****** build resource ********"
      @user.apply_omniauth(session['devise.facebook_data'])
    else
      @user.profile_images.build(:provider => ProfileImage::MACABOLIC, :uid => @user.email);
      @user.profile_images.build(:provider => ProfileImage::GRAVATAR, :uid => @user.email);      
    end
  end
end
