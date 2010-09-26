class MyFriendsController < ApplicationController
  # GET /my_friends
  # GET /my_friends.xml
  def index
    @my_friends = current_user.my_friends
#    @my_friends = MyFriend.find_all_by_user_id(current_user.id)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @my_friends }
    end
  end

  # GET /my_friends/1
  # GET /my_friends/1.xml
  def show
    @my_friend = MyFriend.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @my_friend }
    end
  end

  # GET /my_friends/new
  # GET /my_friends/new.xml
  def new
    @my_friend = MyFriend.new
    @friends = User.all

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @my_friend }
    end
  end

  # GET /my_friends/1/edit
  def edit
    @my_friend = MyFriend.find(params[:id])
  end

  # POST /my_friends
  # POST /my_friends.xml
  def create
    @my_friend = MyFriend.new(params[:my_friend])

    respond_to do |format|
      if @my_friend.save
        format.html { redirect_to(@my_friend, :notice => 'MyFriend was successfully created.') }
        format.xml  { render :xml => @my_friend, :status => :created, :location => @my_friend }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @my_friend.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /my_friends/1
  # PUT /my_friends/1.xml
  def update
    @my_friend = MyFriend.find(params[:id])

    respond_to do |format|
      if @my_friend.update_attributes(params[:my_friend])
        format.html { redirect_to(@my_friend, :notice => 'MyFriend was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @my_friend.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /my_friends/1
  # DELETE /my_friends/1.xml
  def destroy
    @my_friend = MyFriend.find(params[:id])
    @my_friend.destroy

    respond_to do |format|
      format.html { redirect_to(my_friends_url) }
      format.xml  { head :ok }
    end
  end
end
