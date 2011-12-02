class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # You need to implement the method below in your model
    @user = User.find_for_facebook_oauth(env["omniauth.auth"], current_user)

    if @user.persisted? and @user.confirmed?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.facebook_data"] = env["omniauth.auth"]
      logger.info "facebook session data: #{session['devise.facebook_data']}"
      logger.info "User info: #{session['devise.facebook_data']['user_info']['name']}."
      logger.info "User from database: #{@user.first_name} | #{@user.last_name} | #{@user.email}"
      # facebook session data: [reference => https://github.com/intridea/omniauth/wiki/Auth-Hash-Schema]
      # user_info name: Billy Cheng
      # urls  Facebook: http://www.facebook.com/profile.php?id=100002983805074
      #       Website
      #       nickname
      #       last_name: Cheng
      #       image: http://graph.facebook.com/100002983805074/picture?type=square
      #       first_name: Billy
      #       email: billy.cheng@macabolic.com
      #       uid: 100002983805074credentialstokenAAADjFmJTOxABAFR4m2zeA980ZCkEm8z5TG6pZCb87BxKCwZAG6sS4XjORYyZCaoJIB92EaqA4PM4lpzgY5X3xsNBDjfdVE9bHvsBu3fVIAZDZD
      #       extrauser_hashnameBilly Chengtimezone8gendermaleid100002983805074last_nameChengupdated_time2011-09-20T16:53:17+0000verifiedtruelocaleen_USlinkhttp://www.facebook.com/profile.php?id=100002983805074emailbilly.cheng@macabolic.comfirst_nameBillyproviderfacebook

      redirect_to new_registration_path(@user)
    end
  end

  def twitter
    # You need to implement the method below in your model
    @user = User.find_for_twitter_oauth(env["omniauth.auth"], current_user)

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Twitter"
      sign_in_and_redirect @user, :event => :authentication
    else
#      session["devise.twitter_data"] = env["omniauth.auth"]
      redirect_to new_registration_path(User.new)
    end
  end

  def google
    # You need to implement the method below in your model
    @user = User.find_for_google_oauth(env["omniauth.auth"], current_user)

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.google_data"] = env["omniauth.auth"]
      redirect_to new_registration_path(User.new)
    end
  end

  def passthru
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end
  
end