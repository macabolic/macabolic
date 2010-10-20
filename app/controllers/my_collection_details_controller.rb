class MyCollectionDetailsController < ApplicationController
  # GET /my_collection_details
  # GET /my_collection_details.xml
  def index
#    @my_collection_details = MyCollectionDetail.all;
#   TODO: Join MyCollection with MyCollectionDetail
    logger.info "I am in MyCollectionDetailsController.index."
    @my_collection = MyCollection.find(:first, :conditions => ["user_id = ?", current_user.id])
    logger.info "There are a total of #{@my_collection.size} my_collection(s) to list out."
    @my_collection_details = MyCollectionDetail.find(:all, :conditions => ["my_collection_id = ?", @my_collection.id])

    logger.info "There are a total of #{@my_collection_details.size} my_collection_detail(s) to list out."

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @my_collection_details }
    end
  end

  # GET /my_collection_details/1
  # GET /my_collection_details/1.xml
  def show
    @my_collection_detail = MyCollectionDetail.find(params[:id])
    @products = Product.find(:all)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @my_collection_detail }
    end
  end

  # GET /my_collection_details/new
  # GET /my_collection_details/new.xml
  def new
    @my_collection_detail = MyCollectionDetail.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @my_collection_detail }
    end
  end

  # GET /my_collection_details/1/edit
  def edit
    @my_collection_detail = MyCollectionDetail.find(params[:id])
  end

  # POST /my_collection_details
  # POST /my_collection_details.xml
  def create
    @my_collection_detail = MyCollectionDetail.new(params[:my_collection_detail])

    respond_to do |format|
      if @my_collection_detail.save
        format.html { redirect_to(my_collections_url, :notice => 'MyCollectionDetail was successfully created.') }
        format.xml  { head :ok }
#        format.html { redirect_to(@my_collection_detail, :notice => 'MyCollectionDetail was successfully created.') }
#        format.xml  { render :xml => @my_collection_detail, :status => :created, :location => @my_collection_detail }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @my_collection_detail.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /my_collection_details/1
  # PUT /my_collection_details/1.xml
  def update
    @my_collection_detail = MyCollectionDetail.find(params[:id])

    respond_to do |format|
      if @my_collection_detail.update_attributes(params[:my_collection_detail])
        format.html { redirect_to(@my_collection_detail, :notice => 'MyCollectionDetail was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @my_collection_detail.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /my_collection_details/1
  # DELETE /my_collection_details/1.xml
  def destroy
    @my_collection_detail = MyCollectionDetail.find(params[:id])
    @my_collection_detail.destroy

    respond_to do |format|
      format.html { redirect_to(my_collections_url) }
      format.xml  { head :ok }
    end
  end
end
