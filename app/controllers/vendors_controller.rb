class VendorsController < ApplicationController
  before_filter :store_location
  #layout 'admin/admin'
  
  # GET /vendors
  # GET /vendors.xml
  def index
    @stores = Vendor.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @stores }
    end
  end

  # GET /vendors/1
  # GET /vendors/1.xml
  def show
    @vendor = Vendor.find(params[:id])
    @user = current_user
    @deals = @vendor.deals
    @related_deals = @vendor.related_offerings
    #@products = Product.where(:vendor_id => @vendor.id)
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @vendor }
    end
  end

  # GET /vendors/new
  # GET /vendors/new.xml
  def new
    @vendor = Vendor.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @vendor }
    end
  end

  # GET /vendors/1/edit
  def edit
    @vendor = Vendor.find(params[:id])
  end

  # POST /vendors
  # POST /vendors.xml
  def create
    @vendor = Vendor.new(params[:vendor])

    respond_to do |format|
      if @vendor.save
        format.html { redirect_to([:admin, @vendor], :notice => 'Vendor was successfully created.') }
        format.xml  { render :xml => [:admin, @vendor], :status => :created, :location => @vendor }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @vendor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /vendors/1
  # PUT /vendors/1.xml
  def update
    @vendor = Vendor.find(params[:id])

    respond_to do |format|
      if @vendor.update_attributes(params[:vendor])
        format.html { redirect_to([:admin, @vendor], :notice => 'Vendor was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @vendor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /vendors/1
  # DELETE /vendors/1.xml
  def destroy
    @vendor = Vendor.find(params[:id])
    @vendor.destroy

    respond_to do |format|
      format.html { redirect_to(admin_vendors_url) }
      format.xml  { head :ok }
    end
  end
  
  def like
    @vendor = Vendor.find(params[:id])
    response = VendorResponse.new(:vendor => @vendor, :user => current_user)    
    logger.debug "VendorsController.like."
    if response.save
      logger.debug "#{response.user.full_name} likes #{response.vendor.name}."
    end
    
    @number_of_likes = @vendor.responses.size
  end
  
  def unlike
    @vendor = Vendor.find(params[:id])
    response = VendorResponse.where(:vendor_id => @vendor.id, :user_id => current_user.id)    
    logger.debug "VendorsController.unlike."
    if response.exists?
      response.first.destroy #destroy the first one and always expect only one for each user and collection.
      logger.debug "#{response.first.user.full_name} unlikes #{response.first.vendor.name}."
    end
    
    @number_of_likes = @vendor.responses.size
  end
  
  def follow
    @vendor = Vendor.find(params[:id])
    follower = VendorFollower.new(:vendor => @vendor, :follower => current_user)    
    logger.debug "VendorsController.follow."
    if follower.save
      logger.debug "#{follower.follower.full_name} is following #{follower.vendor.name}."
    end
    
    @number_of_followers = @vendor.followers.size
  end

  def unfollow
    @vendor = Vendor.find(params[:id])
    follower = VendorFollower.where(:vendor_id => @vendor.id, :follower_id => current_user.id)    
    logger.debug "VendorsController.unfollow."
    if follower.exists?
      follower.first.destroy #destroy the first one and always expect only one for each user and collection.
      logger.debug "#{follower.first.follower.full_name} is unfollowing #{follower.first.vendor.name}."
    end
    
    @number_of_followers = @vendor.followers.size    
  end
  
end
