class MyProfilesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, :with => :no_my_profile_found
  
  # GET /my_profiles
  # GET /my_profiles.xml
  def index
    @my_profiles = MyProfile.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @my_profiles }
    end
  end

  # GET /my_profiles/1
  # GET /my_profiles/1.xml
  def show
    @my_profile = MyProfile.find(params[:id])
    @my_collection = MyCollection.find(:first, :conditions => ["user_id = ?", current_user.id])    
    @my_collection_details = MyCollectionDetail.find(:all, :conditions => ["my_collection_id = ?", @my_collection.id]) if !@my_collection.nil?

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @my_profile }
    end      
  end

  # GET /my_profiles/new
  # GET /my_profiles/new.xml
  def new
    @my_profile = MyProfile.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @my_profile }
    end
  end

  # GET /my_profiles/1/edit
  def edit
    @my_profile = MyProfile.find(params[:id])
  end

  # POST /my_profiles
  # POST /my_profiles.xml
  def create
    @my_profile = MyProfile.new(params[:my_profile])

    respond_to do |format|
      if @my_profile.save
        format.html { redirect_to(@my_profile, :notice => 'MyProfile was successfully created.') }
        format.xml  { render :xml => @my_profile, :status => :created, :location => @my_profile }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @my_profile.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /my_profiles/1
  # PUT /my_profiles/1.xml
  def update
    @my_profile = MyProfile.find(params[:id])

    respond_to do |format|
      if @my_profile.update_attributes(params[:my_profile])
        format.html { redirect_to(@my_profile, :notice => 'MyProfile was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @my_profile.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /my_profiles/1
  # DELETE /my_profiles/1.xml
  def destroy
    @my_profile = MyProfile.find(params[:id])
    @my_profile.destroy

    respond_to do |format|
      format.html { redirect_to(my_profiles_url) }
      format.xml  { head :ok }
    end
  end
  
  def no_my_profile_found
    @my_profile = MyProfile.new
    render :new    
  end
end
