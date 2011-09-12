class FriendshipsController < ApplicationController

  # GET /friendships/1
  # GET /friendships/1.xml
  def show
    #@friendship = Friendship.find(params[:id])
    @user = User.find(params[:id])
    @friends = @user.friends

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @friendship }
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
end
