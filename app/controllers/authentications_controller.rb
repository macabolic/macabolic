class AuthenticationsController < ApplicationController
  # GET /authentications
  # GET /authentications.xml
  def index
    @authentications = current_user.authentications if current_user

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @authentications }
    end
  end

  # POST /authentications
  # POST /authentications.xml
  def create
    omniauth = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if authentication
      flash[:notice] = "Signed in successfully."
      sign_in_and_redirect(:user, authentication.user)
    elsif current_user  
      current_user.authentications.create!(omniauth['provider'], omniauth['uid'])
      flash[:notice] = "Authentication successful from #{auth['provider']}"
      #redirect_to authentications_url
      redirect_to member_path(current_user.id)
    else
      user = User.new
      #user.authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
      user.apply_omniauth(omniauth)
      if user.save
        flash[:notice] = "Signed in successfully from #{auth['provider']}"
        sign_in_and_redirect(:user, user)
      else
        session[:omniauth] = omniauth.except('extra')
        redirect_to new_user_registration_url
      end
    end
  end

  # DELETE /authentications/1
  # DELETE /authentications/1.xml
  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy

    respond_to do |format|
      #format.html { redirect_to(authentications_url) }
      format.html { redirect_to(new_user_session_path)}
      format.xml  { head :ok }
    end
  end
end
