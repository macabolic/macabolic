# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  before_filter :login_required, :only => [ :edit, :update ]

  # render new.erb.html
  def new
  end

  def create
    if using_open_id?
      open_id_authentication(params[:openid_url])
    else
      password_authentication(params[:login], params[:password])
    end    
  end

  def destroy
    logout_killing_session!
    flash[:notice] = "You have been logged out."
    # redirect_back_or_default('/')
    render :action => 'new'
  end

protected

  def open_id_authentication(openid_url)
    logger.debug "---- openid_url: '#{openid_url} at #{Time.now.utc}"
    logger.debug "---- request.protocol: #{request.protocol}"
    logger.debug "---- request.host_with_port: #{request.host_with_port}"
    logger.debug "---- request.request_uri: #{request.request_uri}"
        
    authenticate_with_open_id(openid_url, :required => [:nickname, :email]) do |result, identity_url, registration|
      case result
      when :missing
        failed_login "Sorry, the OpenID server couldn't be found"
      when :canceled
        failed_login "OpenID verification was canceled"
      when :failed
        failed_login "Sorry, the OpenID verification failed"
      when :successful
        if result.successful?
          @user = User.find_or_initialize_by_identity_url(identity_url)
          if @user.new_record?
            @user.login = registration['nickname']
            @user.email = registration['email']
            @user.save(false)
          end
          logger.debug "[sessions_controller]: login = #{@user.login}"
          logger.debug "[sessions_controller]: email = #{@user.email}"
          self.current_user = @user
          successful_login
        else
          failed_login result.message
        end
      end
    end
  end
    
  def password_authentication(login, password)
    logout_keeping_session!    
    self.current_user = User.authenticate(login, password)
    if logged_in?
      successful_login
    else
      failed_login
    end    
  end

  def successful_login
    # Protects against session fixation attacks, causes request forgery
    # protection if user resubmits an earlier form using back
    # button. Uncomment if you understand the tradeoffs.
    # reset_session
    new_cookie_flag = (params[:remember_me] == "1")
    handle_remember_cookie! new_cookie_flag
    redirect_back_or_default('/')
    flash[:notice] = "Logged in successfully"    
  end
  
  def failed_login
    note_failed_signin
    @login       = params[:login]
    @remember_me = params[:remember_me]
    render :action => 'new'
  end
  
  # Track failed login attempts
  def note_failed_signin
    flash[:error] = "Couldn't log you in as '#{params[:login]}'"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
