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
    auth = request.env["omniauth.auth"]
    current_user.authentications.find_or_create_by_provider_and_uid(auth['provider'], auth['uid'])
    flash[:notice] = "Authentication successful from #{auth['provider']}"
    #redirect_to authentications_url
    @member = Member.where(:email_address => current_user.email)
    redirect_to member_path(@member.id)
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
