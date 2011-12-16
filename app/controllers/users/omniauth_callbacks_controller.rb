class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # You need to implement the method below in your model
    #@user = User.find_for_facebook_oauth(env["omniauth.auth"], current_user)
    # Change on Dec 5, 2011 as below
    logger.info "Omniauth.auth: #{request.env["omniauth.auth"]}"
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted? and @user.confirmed?
      logger.info "User is both persisted and confirmed."
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      sign_in_and_redirect @user, :event => :authentication
    elsif @user.persisted? and !@user.confirmed?
      # Getting the authentication response and store in session.
      session["devise.facebook_data"] = request.env["omniauth.auth"]

      logger.info "User from database: #{@user.first_name} | #{@user.last_name} | #{@user.email}"
      redirect_to new_invitation_path :email => @user.email, :origin => "facebook"
    else
      # Getting the authentication response and store in session.
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      
      # ==> A sample response from omniauth.auth
      #Omniauth.auth: 
      #<OmniAuth::AuthHash 
      #	credentials=#<Hashie::Mash 
      #		expires=true 
      #		expires_at=1323140400 
      #		token="AAADjFmJTOxABAL53CSoAnWZA9IsUezEuzFqe2LMIgw0ooAOyQ7QGJO9odfHKFTmNfIZCxvukpD0faXPZA2rwM6abTI1mTCgP0rJRMZCRZCAZDZD"> 
      #	extra=#<Hashie::Mash 
      #		raw_info=#<Hashie::Mash 
      #			birthday="09/22/1977" 
      #			email="billy.sf.cheng@gmail.com" 
      #			favorite_teams=[#<Hashie::Mash id="7724542745" name="Manchester United">] 
      #			first_name="Billy" 
      #			gender="male" 
      #			id="610814778" 
      #			last_name="Cheng" 
      #			link="http://www.facebook.com/profile.php?id=610814778" 
      #			locale="en_US" 
      #			name="Billy Cheng" 
      #			sports=[#<Hashie::Mash id="105942022769573" name="Golf">, #<Hashie::Mash id="105650876136555" name="Tennis">] 
      #			timezone=8 updated_time="2011-06-18T17:36:23+0000" 
      #			verified=true>> 
      #	info=#<OmniAuth::AuthHash::InfoHash 
      #		email="billy.sf.cheng@gmail.com" 
      #		first_name="Billy" 
      #		image="http://graph.facebook.com/610814778/picture?type=square" 
      #		last_name="Cheng" 
      #		name="Billy Cheng" 
      #		urls=#<Hashie::Mash Facebook="http://www.facebook.com/profile.php?id=610814778">> 
      #	provider="facebook" 
      #	uid="610814778"
      #>
            
      logger.info "facebook session data: #{session['devise.facebook_data']}"
      logger.info "User info: #{session['devise.facebook_data'].info.name}."      

      redirect_to new_registration_path(@user, :origin => "facebook")
    end
  end

#  def twitter
#    logger.info "==> OmniauthCallBacksController.twitter..."
    # You need to implement the method below in your model
#    @user = User.find_for_twitter_oauth(request.env["omniauth.auth"], current_user)

#    if @user.persisted?
#      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Twitter"
#      sign_in_and_redirect @user, :event => :authentication
#    else
#      session["devise.twitter_data"] = env["omniauth.auth"]
#      redirect_to new_registration_path(User.new)
#    end
#  end

#  def google
    # You need to implement the method below in your model
#    @user = User.find_for_google_oauth(env["omniauth.auth"], current_user)

#    if @user.persisted?
#      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
#      sign_in_and_redirect @user, :event => :authentication
#    else
#      session["devise.google_data"] = env["omniauth.auth"]
#      redirect_to new_registration_path(User.new)
#    end
#  end

  def passthru
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end
  
end