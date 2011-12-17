class MembersController < ApplicationController

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
#        format.html { redirect_to(@user, :notice => 'Member was successfully updated.') }
        format.html { redirect_to(edit_member_path(@user), :notice => "Your info was successfully updated.") }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /members/1
  # DELETE /members/1.xml
  def destroy
    @member = Member.find(params[:id])
    @member.destroy

    respond_to do |format|
      format.html { redirect_to(members_url) }
      format.xml  { head :ok }
    end
  end
  
  def profile
    @user = User.find(params[:id])
    @activities = @user.activities
    
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
    @my_collection_items = @user.my_collection_items
    #.paginate	:page => params[:page], 
    #                                                          :per_page => 10,
    #                                                          :order => 'created_at DESC'

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
