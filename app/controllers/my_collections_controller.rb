class MyCollectionsController < ApplicationController
  # GET /my_collections
  # GET /my_collections.xml
  def index
    @my_collection_detail = MyCollectionDetail.new
    @my_collection = MyCollection.find(:first, :conditions => ["user_id = ?", current_user.id])
    if @my_collection.nil?
      logger.info "No my_collection is created yet."
      @my_collection = MyCollection.new
      @my_collection.user_id = current_user.id
      @my_collection.name = "My Collection"
      @my_collection.save
    else
      logger.info "my_collection exists already."
      @my_collection_details = MyCollectionDetail.find(:all, :conditions => ["my_collection_id = ?", @my_collection.id])
      logger.info "there are a total of #{@my_collection_details.size} my_collection_detail(s)."
    end
    @vendor = Vendor.all(:conditions => {:name => 'Apple Inc'})
    @products = Product.all(@vendor)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @my_collection }
    end
  end

  # GET /my_collections/1
  # GET /my_collections/1.xml
  def show
    @my_collection = MyCollection.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @my_collection }
    end
  end

  # GET /my_collections/new
  # GET /my_collections/new.xml
  def new
    @my_collection = MyCollection.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @my_collection }
    end
  end

  # GET /my_collections/1/edit
  def edit
    @my_collection = MyCollection.find(params[:id])
  end

  # POST /my_collections
  # POST /my_collections.xml
  def create
    @my_collection = MyCollection.new(params[:my_collection])

    respond_to do |format|
      if @my_collection.save
        format.html { redirect_to(@my_collection, :notice => 'MyCollection was successfully created.') }
        format.xml  { render :xml => @my_collection, :status => :created, :location => @my_collection }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @my_collection.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /my_collections/1
  # PUT /my_collections/1.xml
  def update
    @my_collection = MyCollection.find(params[:id])

    respond_to do |format|
      if @my_collection.update_attributes(params[:my_collection])
        format.html { redirect_to(@my_collection, :notice => 'MyCollection was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @my_collection.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /my_collections/1
  # DELETE /my_collections/1.xml
  def destroy
    @my_collection = MyCollection.find(params[:id])
    @my_collection.destroy

    respond_to do |format|
      format.html { redirect_to(my_collections_url) }
      format.xml  { head :ok }
    end
  end
end
