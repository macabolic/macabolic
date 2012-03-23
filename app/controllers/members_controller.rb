class MembersController < ApplicationController
  before_filter :show_invitation_notice
  before_filter :store_location
  before_filter :authenticate_user!, :except => [ :index ]

  # GET /members
  # GET /members.xml
  def index
    @members = User.scoped
  end

  # GET /members/1
  # GET /members/1.xml
  def show
    @user = User.find(params[:id])
    @activities = @user.all_activities
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @member }
    end
  end

  # GET /members/1/edit
  def edit
    #@member = Member.find(params[:id])
    @user = User.find(params[:id])
    @invitation = Invitation.new
  end

  # POST /members
  # POST /members.xml
  #def create
  #  @member = Member.new(params[:member])

  #  respond_to do |format|
  #    if @member.save
  #      format.html { redirect_to(@member, :notice => 'Member was successfully created.') }
  #      format.xml  { render :xml => @member, :status => :created, :location => @member }
  #    else
  #      format.html { render :action => "new" }
  #      format.xml  { render :xml => @member.errors, :status => :unprocessable_entity }
  #    end
  #  end
  #end

  # PUT /members/1
  # PUT /members/1.xml
  def update
    #@member = Member.find(params[:id])
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        logger.debug "User information is updated."
#        format.html { redirect_to(@user, :notice => 'Member was successfully updated.') }
        format.html { redirect_to(edit_member_path(@user), :notice => "Your info was successfully updated.") }
        format.xml  { head :ok }
      else        
        logger.error "User information cannot be updated."
        logger.error "Number of errors: #{@user.errors.size}."
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /members/1
  # DELETE /members/1.xml
  def destroy
    @member = User.find(params[:id])
    @member.destroy

    respond_to do |format|
      format.html { redirect_to(members_url) }
      format.xml  { head :ok }
    end
  end
  
  def profile
    @user = User.find(params[:id])
    @activities = @user.activities
    #@activities = @user.all_activities
    @discovered_products = @user.discovered_products

    @friends = @user.friends

    me_and_my_friends = @friends.map(&:id)
    me_and_my_friends << current_user.id

    @suggested_from_macabolic_search = Sunspot.search(User) do
      without(:id, me_and_my_friends)
    end
    
    @suggested_from_macabolic = @suggested_from_macabolic_search.results
    logger.debug "Number of suggestions: #{@suggested_from_macabolic.size}."
        
    ## Future TODO: restructure the following code and put it in a model to perform the logic.
    # ---------- Get the friends from Facebook
    # A dirty way of doing it.
    # 1. Get a list of friends
    # 2. Put a link for the profile page
    # 3. Add an invite button
    if @user == current_user
      @facebook_authentication = @user.authentications.find_by_provider('facebook')
      limit = '50'
      if @facebook_authentication.present?
        url = 'https://graph.facebook.com/' + @facebook_authentication.uid + '/friends?access_token=' + @facebook_authentication.token
        url = url + '&limit=' + limit
        logger.debug "Generated facebook url is #{url}."
        # https://graph.facebook.com/me/friends?access_token=AAADjFmJTOxABAHOZB5Ypy9YOkXT2RpZCSTcmMsnOthxlViqs9NpKPH2U2R9Ylt60PFpR3ZAEIHIrsF9mA1iZCSCAAkCvLhbqDQ3ZB28WZCmwZDZD
        response = HTTParty.get(url)

        ## The response['data'] is in the format of JSON
        @facebook_friends = response['data']
        @facebook_paging = response['paging']
        logger.debug response['data']
        
        url = 'https://graph.facebook.com/' + @facebook_authentication.uid + '/'
        response = HTTParty.get(url)
        @facebook_name = response['name']
      end
    end
    
    respond_to do |format|
      format.html # profile.html.erb
      format.xml  { render :xml => @member }
    end
  end

  def collections
    @user = User.find(params[:id])
    @my_collections = @user.my_collections
    #.paginate	:page => params[:page], 
    #                                                        :per_page => 10,
    #                                                        :order => 'created_at DESC'
    #@my_collection_items = @user.my_collection_items
    
    @owned_collection_items = @user.owned_collection_items
    @wished_collection_items = @user.wished_collection_items
    
    #.paginate	:page => params[:page], 
    #                                                          :per_page => 10,
    #                                                          :order => 'created_at DESC'
    @my_collection = MyCollection.new
  	@my_collection.name = ''
  	@my_collection.user = @user    
    
    @activities = @user.following_activities
    
    respond_to do |format|
      format.html # collections.html.erb
      format.xml  { render :xml => @member }
    end
  end

#  def profile_picture
#    @user = User.new
#    @user.email = current_user.email
#    respond_to do |format|
#      format.html # profile_picture.html.erb
#      format.xml  { render :xml => @member }
#    end
#  end
    
end
