class MyCollectionItemsController < ApplicationController
  # GET /my_collection_items
  # GET /my_collection_items.xml
  def index
    @my_collection_items = MyCollectionItem.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @my_collection_items }
    end
  end

  # GET /my_collection_items/1
  # GET /my_collection_items/1.xml
  def show
    @my_collection_item = MyCollectionItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @my_collection_item }
    end
  end

  # GET /my_collection_items/new
  # GET /my_collection_items/new.xml
  def new
    @my_collection_item = MyCollectionItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @my_collection_item }
    end
  end

  # GET /my_collection_items/1/edit
  def edit
    @my_collection_item = MyCollectionItem.find(params[:id])
  end

  # POST /my_collection_items
  # POST /my_collection_items.xml
  def create
    @my_collection_item = MyCollectionItem.new(params[:my_collection_item])

    respond_to do |format|
      if @my_collection_item.save
        format.html { redirect_to(@my_collection_item, :notice => 'My collection item was successfully created.') }
        format.xml  { render :xml => @my_collection_item, :status => :created, :location => @my_collection_item }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @my_collection_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /my_collection_items/1
  # PUT /my_collection_items/1.xml
  def update
    @my_collection_item = MyCollectionItem.find(params[:id])

    respond_to do |format|
      if @my_collection_item.update_attributes(params[:my_collection_item])
        format.html { redirect_to(@my_collection_item, :notice => 'My collection item was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @my_collection_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /my_collection_items/1
  # DELETE /my_collection_items/1.xml
  def destroy
    @my_collection_item = MyCollectionItem.find(params[:id])
    @my_collection_item.destroy

    respond_to do |format|
      format.html { redirect_to(my_collection_items_url) }
      format.xml  { head :ok }
    end
  end
end
