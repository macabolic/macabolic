class RegistrationsController < Devise::RegistrationsController

  def new
    logger.info "Entering the RegistrationsController#new..."

    # check if there is a token.
    # if token, -> invited by someone
    if !params[:invitation_token].nil? && !params[:invitation_token].empty?
      @invitation = Invitation.where("token = ?", params[:invitation_token]).first
      logger.info "the invitation is for #{@invitation.recipient_email}."
      @sender = @invitation.sender
      logger.info "and the sender is #{@sender.full_name}."
    end      
    # else -> regular registration
        
    super
  end
  
  def create
    super
    session[:omniauth] = nil unless @user.new_record?
    
    if !params[:invitation_token].nil? && !params[:invitation_token].empty?
      # 1. Update invitation on the accepted date
      @invitation = Invitation.where("token = ?", params[:invitation_token]).first
      @invitation.accepted_at = Time.now
      @invitation.update_attribute("accepted_at", Time.now)
      
      # 2. Add as a friend to the sender      
      @friendship = @user.friendships.build(:friend_id => @invitation.sender.id)
      @friendship.save

      @inverse_friendship = @invitation.sender.friendships.build(:friend_id => @user.id)
      @inverse_friendship.save
    end
  end
  
  private
  
  def build_resource(*args)
    super
    if session[:omniauth]
      @user.apply_omniauth(session[:omniauth])
      @user.valid?
    end
  end
end
