class InvitationsController < ApplicationController
  # GET /invitations
  # GET /invitations.xml
  def index
    @invitations = Invitation.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @invitations }
    end
  end

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
          format.html { redirect_to(:controller => 'registrations', :action => 'new', :invitation_token => params[:invitation_token]) }# show.html.erb
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

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @invitation }
    end
  end

  # GET /invitations/1/edit
  def edit
    @invitation = Invitation.find(params[:id])
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
    else
      @invitation.save
      # Send a email to recipient_email
      UserMailer.invite(@invitation).deliver
      @invitation.update_attribute("sent_at", Time.now)
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
end
