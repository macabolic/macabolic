class InvitationsController < ApplicationController

  # GET /invitations/1
  # GET /invitations/1.xml
  # http://localhost:3001/invitations/5/accept/4108220502d75c27fab59fc422c754c277e789aa
  def show    
    # Using the id and token as the keys here.
    @invitation_list = Invitation.where("id = ? and token = ?", params[:id], params[:invitation_token])
    # 1. Check if the invitation is valid
    # 2. Check if the invitation is already accepted
    # 3. If not valid -> error message
    # 4. If already accepted -> route to Login page with message "You have already accepted the invitation. Welcome back!"

    respond_to do |format|
      if @invitation_list.exists?
        @invitation = @invitation_list.first
        if @invitation.is_accepted?
          # Invitation is valid and is accepted -> Login page.
          format.html { redirect_to(new_user_session_path) }
        else
          # Invitation is valid and not yet accepted.          
          if params[:confirm] == 'true' && params[:source] == 'email'
            # This is for the early adopters during the early phase for the sign up.
            @user = User.find_by_email(@invitation.recipient_email)
            @user.update_attributes(:invitation_id => @invitation.id)
            sign_in(:user, @user)
            format.html { redirect_to(:controller => 'my_collections', :action => 'new', :invitation_token => params[:invitation_token]) }# show.html.erb
          else
            format.html { redirect_to(:controller => 'registrations', :action => 'new', :invitation_token => params[:invitation_token]) }# show.html.erb
          end
        end
      else
        format.html { redirect_to(new_user_registration_path) }# show.html.erb
      end
      #format.xml  { render :xml => @invitation }
    end
  end

  # GET /invitations/new
  # GET /invitations/new.xml
  def new
    @invitation = Invitation.new
    
    # Nov 20, 2011 - Billy
    # I have no choice but to do another sign_in here.
    # The sign_in should be done in RegistrationsController.new 
    # But at some point, it doesn't work there. To fix that, I do another sign_in here.
    logger.info "InvitationsController.new before - #{user_signed_in?}"
    if !user_signed_in?
      @user = User.find_by_email(params[:email])
      if !@user.nil?
        sign_in(:user, @user)
        logger.info "InvitationsController.new after - #{user_signed_in?}"
      end
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @invitation }
    end
  end

  # POST /invitations
  # POST /invitations.xml
  def create    
    @invitation = Invitation.new(params[:invitation])
    @invitation.sender = current_user
    logger.info "Invitation..."
    logger.info "Recipient mail: #{@invitation.recipient_email}"
    
    # Should check if there is an existing invitation from the same sender.
    # If there is one, use the existing.
    @existing_invitation = Invitation.where("sender_id = ? and recipient_email = ?", current_user.id, @invitation.recipient_email).first
    if @existing_invitation
      logger.info "It is a reminder invitation."
      UserMailer.invite(@existing_invitation, true).deliver
      @existing_invitation.update_attribute("sent_at", Time.now)
      @success = true
    else
      @existing_user = User.where("email = ? and invitation_id is not null", @invitation.recipient_email)
      if @existing_user.exists?
        @success = false
      else        
        if @invitation.save
          # Send a email to recipient_email
          UserMailer.invite(@invitation).deliver
          @invitation.update_attribute("sent_at", Time.now)
          @success = true
        else
          @success = false
        end
      end
    end    
    #respond_to do |format|
    #  if @invitation.save
        #format.html { redirect_to(:controller => 'members', :action => 'profile', :notice => 'Invitation was successfully created.') }
        #format.xml  { render :xml => @invitation, :status => :created, :location => @invitation }
    #  else
        #format.html { render :action => "new" }
        #format.xml  { render :xml => @invitation.errors, :status => :unprocessable_entity }
    #  end
    #end
    @recipient_email = @invitation.recipient_email
  end

  # PUT /invitations/1
  # PUT /invitations/1.xml
  def update
    @invitation = Invitation.find(params[:id])

    respond_to do |format|
      if @invitation.update_attributes(params[:invitation])
        format.html { redirect_to(@invitation, :notice => 'Invitation was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @invitation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /invitations/1
  # DELETE /invitations/1.xml
  def destroy
    @invitation = Invitation.find(params[:id])
    @invitation.destroy

    respond_to do |format|
      format.html { redirect_to(invitations_url) }
      format.xml  { head :ok }
    end
  end
  
  def skip
    respond_to do |format|
      format.html { redirect_to(:controller => 'my_collections', :action => 'new') }
      #format.xml  { render :xml => @invitation, :status => :created, :location => @invitation }
    end
  end
  
  def add_as_friend
    inviting_user = User.find(params[:member_id])
    logger.debug "#{current_user.full_name} is adding user #{inviting_user.full_name} (#{inviting_user.email}) as friend."
    logger.debug "Now send my friend a request."
    UserMailer.friend_request(current_user, inviting_user).deliver
  end
      
  def accept_request
    inviting_user = User.find(params[:id])
    accepting_user = User.find(params[:member_id])
    
    @friendship = accepting_user.friendships.build(:friend_id => inviting_user.id)
    @friendship.save

    @inverse_friendship = inviting_user.friendships.build(:friend_id => accepting_user.id)
    @inverse_friendship.save
    
    redirect_to friends_member_path(accepting_user) 
  end
end

