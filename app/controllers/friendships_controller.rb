require 'httparty'
class FriendshipsController < ApplicationController
  #before_filter :show_invitation_notice
  before_filter :store_location
  before_filter :authenticate_user!, :except => [:following, :followers]

  # GET /friendships
  # GET /friendships.xml
  def index
    if !params[:user_id].nil?
      if params[:search].length > 2
        @search = Sunspot.search(Friendship) do
          #any_of do
          with :user_id, params[:user_id]
          keywords params[:search]
        end
        @friends = @search.results
        logger.debug "Friends search result: #{@friends.size}."
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
      facebook_authentication = @user.authentications.where(:provider => 'facebook')
      limit = '50'
      if facebook_authentication.exists?
        url = 'https://graph.facebook.com/' + facebook_authentication[0].uid + '/friends?access_token=' + facebook_authentication[0].token
        url = url + '&limit=' + limit
        logger.debug "Generated facebook url is #{url}."
        # https://graph.facebook.com/me/friends?access_token=AAAAAAITEghMBAHAek9yKuw1WyEGUmB15ovKZBeTA2fVm395hTlYxxWWuIA8rTKEBvm5HYh9m59yDC3ZBARqTQFVJ7Y94NPoqf31Ar9FAZDZD
        response = HTTParty.get(url)

        ## The response['data'] is in the format of JSON
        @facebook_friends = response['data']
        @facebook_paging = response['paging']
        logger.debug response['data']
      end
    end
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @friendship }
    end
  end

  def show_more
      @provider = params[:provider]
      url = params[:url]

      logger.debug "showing more friends from #{@provider}."
      
      if @provider == Authentication::FACEBOOK
          logger.debug "Generated facebook url is #{url}."
          response = HTTParty.get(url)

          ## The response['data'] is in the format of JSON
          @facebook_friends = response['data']
          @facebook_paging = response['paging']
          logger.debug response['data']
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
      logger.debug "Friends search result: #{@friends.size}."
      @friends = @friends.select { |f| f.friend.full_name.downcase.include? search_name.downcase } if @friends.size > 0
      logger.debug "Friends: #{@friends.size}."
      
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
          logger.debug "Generated facebook url (with limit) is #{url}."
          response = HTTParty.get(url)

          ## The response['data'] is in the format of JSON
          #@facebook_friends = response['data']
          @facebook_friends = response['data'].select { |f| f['name'].downcase.include? search_name.downcase }
          @facebook_paging = response['paging']
          logger.debug response['data']      
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
          logger.debug "Generated facebook url is #{url}."
          response = HTTParty.get(url)

          ## The response['data'] is in the format of JSON
          #@facebook_friends = response['data']
          @facebook_friends = response['data'].select { |f| f['name'].downcase.include? search_name.downcase }
          @facebook_paging = response['paging']
          logger.debug response['data']      
        end
        # End Facebook ---------        
        
      end
    end
  end
  
  def followers
    @user = User.find(params[:id])
    @followers = @user.followers
  end
  
  def following
    @user = User.find(params[:id])
    @following = @user.followings    
    logger.debug "Number of following: #{@following.size}."
    @shops = @user.following_shops
    logger.debug "Number of shops following: #{@shops.size}."
    
    if @user == current_user
      me_and_my_friends = @following.map(&:id)
      me_and_my_friends << current_user.id
    
      count = User.all.size
      if count < 31
        number_of_suggestions = count
      else
        number_of_suggestions = 31
      end
      
      r = [ ]
      while r.length < number_of_suggestions
        v = rand(User.all.size)
        r << v unless r.include? v
      end
    
      @suggested_from_macabolic_search = Sunspot.search(User) do
        with(:id, r)
        without(:id, me_and_my_friends)
      end
    
      @suggested_from_macabolic = @suggested_from_macabolic_search.results
      logger.debug "Number of suggestions: #{@suggested_from_macabolic.size}."
    end        
  end

  def follow
    following_user = User.find(params[:id])
    member = User.find(params[:member_id])
    
    if member.present? && following_user.present?
      following_user.friendships.build(:friend_id => member.id)
      following_user.save
    end
    
    logger.debug "Friendships.follow. Member #{member.id} is now following user #{following_user.id}"    
    @user = following_user
    @number_of_following = member.followings.size    
  end
  
  def unfollow
    unfollowing_user = User.find(params[:id])
    member = User.find(params[:member_id])
    
    if member.present? && unfollowing_user.present?
      friendships = Friendship.where("user_id = ? and friend_id = ?", unfollowing_user.id, member.id)
      if friendships.exists?
        friendships.first.destroy
      end
    end
    
    logger.debug "Friendships.follow. Member #{member.id} is now unfollowing user #{unfollowing_user.id}"        
    @user = unfollowing_user
    @number_of_following = member.followings.size
  end
  
end
