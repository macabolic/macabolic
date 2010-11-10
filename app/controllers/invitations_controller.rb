class InvitationsController < ApplicationController
  before_filter :login_required, :only => [ :edit, :update ]
  
  # GET /invitations/new
  # GET /invitations/new.xml
  def new
    @invitation = Invitation.new

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
    
    if @invitation.save
      if logged_in?
        # TODO: Send it out asynchronously??
        UserMailer.deliver_invitation(current_user, @invitation, signup_url(@invitation.token))
        flash[:notice] = "Invitation was successfully sent."
        redirect_back_or_default('/')
      else
        flash[:notice] = "Thank you, we will notify you when we open to public."
        redirect_back_or_default('/')
      end
    else
      redirect_back_or_default('/')
    end
    
#    respond_to do |format|
#      if @invitation.save
#        format.html { redirect_to(@invitation, :notice => 'Invitation was successfully created.') }
#        format.xml  { render :xml => @invitation, :status => :created, :location => @invitation }
#      else
#        format.html { render :action => "new" }
#        format.xml  { render :xml => @invitation.errors, :status => :unprocessable_entity }
#      end
#    end

  end

end
