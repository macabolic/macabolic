require 'httparty'
class FriendshipsController < ApplicationController
  before_filter :show_invitation_notice

  # GET /products
  # GET /products.xml
  def index
    if !params[:user_id].nil?
      if params[:search].length > 2
        @search = Sunspot.search(Friendship) do
          #any_of do
          with :user_id, params[:user_id]
          keywords params[:search]
        end
        @friends = @search.results
        logger.info "Friends search result: #{@friends.size}."
      end
    end
    
    @product_id = params[:product_id]
  end

  # Macabolic ---------
  #@friends = @user.friends.select { |f| f.full_name.downcase.include? search_name.downcase }
  # End Macabolic ---------


  # GET /friendships/1
  # GET /friendships/1.xml
  def show
    #@friendship = Friendship.find(params[:id])
    @user = User.find(params[:id])
    @friends = @user.friends

    ## Future TODO: restructure the following code and put it in a model to perform the logic.
    # ---------- Get the friends from Facebook
    # A dirty way of doing it.
    # 1. Get a list of friends
    # 2. Put a link for the profile page
    # 3. Add an invite button
    facebook_authentication = @user.authentications.where(:provider => 'facebook')
    limit = '50'
    if facebook_authentication.exists?
      url = 'https://graph.facebook.com/' + facebook_authentication[0].uid + '/friends?access_token=' + facebook_authentication[0].token
      url = url + '&limit=' + limit
      logger.info "Generated facebook url is #{url}."
      # https://graph.facebook.com/me/friends?access_token=AAAAAAITEghMBAHAek9yKuw1WyEGUmB15ovKZBeTA2fVm395hTlYxxWWuIA8rTKEBvm5HYh9m59yDC3ZBARqTQFVJ7Y94NPoqf31Ar9FAZDZD
      response = HTTParty.get(url)

      ## The response['data'] is in the format of JSON
      @facebook_friends = response['data']
      @facebook_paging = response['paging']
      logger.info response['data']
    end
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @friendship }
    end
  end

  def show_more
      @provider = params[:provider]
      url = params[:url]

      logger.info "showing more friends from #{@provider}."
      
      if @provider == Authentication::FACEBOOK
          logger.info "Generated facebook url is #{url}."
          response = HTTParty.get(url)

          ## The response['data'] is in the format of JSON
          @facebook_friends = response['data']
          @facebook_paging = response['paging']
          logger.info response['data']
      end
  end
  
  # POST /friendships
  # POST /friendships.xml
  def create
    @friendship = Friendship.new(params[:friendship])

    respond_to do |format|
      if @friendship.save
        format.html { redirect_to(@friendship, :notice => 'Friendship was successfully created.') }
        format.xml  { render :xml => @friendship, :status => :created, :location => @friendship }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @friendship.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /friendships/1
  # DELETE /friendships/1.xml
  def destroy
    @friendship = current_user.friendships.find(params[:id])
    @friendship.destroy

    respond_to do |format|
      format.html { redirect_to(friendships_url) }
      format.xml  { head :ok }
    end
  end
  
  def search_in_network
    search_name = params[:name]      
    #@user = User.find(params[:user_id])

    if params[:name].length > 2
      # Macabolic ---------
      @search = Sunspot.search(Friendship) do
        #any_of do
        with(:user_id, params[:user_id])
        fulltext params[:name], :fields => [:friend_name]            
      end
      @friends = @search.results      
      logger.info "Friends search result: #{@friends.size}."
      @friends = @friends.select { |f| f.friend.full_name.downcase.include? search_name.downcase } if @friends.size > 0
      logger.info "Friends: #{@friends.size}."
      
      # End Macabolic ---------
      @product_id = params[:product_id]      
    end    
  end
  
  def search
    search_name = params[:name]      
    @user = User.find(params[:user_id])

    if params[:name].nil? or params[:name].length <= 2
      if params[:name].length == 0
        # Macabolic ---------
        @friends = @user.friends
        # End Macabolic ---------
        
        # Facebook ---------
        facebook_authentication = @user.authentications.where(:provider => 'facebook')
        if facebook_authentication.exists?          
          limit = '50'
          url = 'https://graph.facebook.com/' + facebook_authentication[0].uid + '/friends?access_token=' + facebook_authentication[0].token
          url = url + '&limit=' + limit
          logger.info "Generated facebook url (with limit) is #{url}."
          response = HTTParty.get(url)

          ## The response['data'] is in the format of JSON
          #@facebook_friends = response['data']
          @facebook_friends = response['data'].select { |f| f['name'].downcase.include? search_name.downcase }
          @facebook_paging = response['paging']
          logger.info response['data']      
        end
        # End Facebook ---------        
      end
    else
      if params[:name].length > 2
        # Macabolic ---------
        @friends = @user.friends.select { |f| f.full_name.downcase.include? search_name.downcase }
        # End Macabolic ---------
        
        # Facebook ---------
        facebook_authentication = @user.authentications.where(:provider => 'facebook')
        if facebook_authentication.exists?          

          url = 'https://graph.facebook.com/' + facebook_authentication[0].uid + '/friends?access_token=' + facebook_authentication[0].token
          logger.info "Generated facebook url is #{url}."
          response = HTTParty.get(url)

          ## The response['data'] is in the format of JSON
          #@facebook_friends = response['data']
          @facebook_friends = response['data'].select { |f| f['name'].downcase.include? search_name.downcase }
          @facebook_paging = response['paging']
          logger.info response['data']      
        end
        # End Facebook ---------        
        
      end
    end
  end
end
