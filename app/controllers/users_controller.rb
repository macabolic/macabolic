class UsersController < ApplicationController
  skip_before_filter :login_required, :only => [:new, :create, :activate]
  
  # GET /users
  # GET /users.xml
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end
  
  # render new.rhtml
  def new
    @user = User.new(:invitation_token => params[:invitation_token])
    @user.email = @user.invitation.recipient_email if @user.invitation
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    
    # TODO: also create the profile here to avoid unnecessary error.
    # TODO: the screen flow will need to be adjusted to include the 'My Profile' attributes in the registration page.
    
    if success && @user.errors.empty?
      if @user.invitation
        @my_friend = MyFriend.new
        @my_friend.user = @user
        @my_friend.friend = @user.invitation.sender
        @my_friend.save
        
        # On the other hand, need to add me to the one invites me.
        @your_friend = MyFriend.new
        @your_friend.user = @user.invitation.sender
        @your_friend.friend = @user
        @your_friend.save
      end
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end

  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = "Signup complete! Please sign in to continue."
      redirect_to '/login'
    when params[:activation_code].blank?
      flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      redirect_back_or_default('/')
    else 
      flash[:error]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_back_or_default('/')
    end
  end
end
