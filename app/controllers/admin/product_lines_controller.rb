class Admin::ProductLinesController < ApplicationController
  layout 'admin/admin'
  
  # GET /product_lines
  # GET /product_lines.xml
  def index
    @product_lines = ProductLine.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @product_lines }
    end
  end

  # GET /product_lines/1
  # GET /product_lines/1.xml
  def show
    @product_line = ProductLine.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @product_line }
    end
  end

  # GET /product_lines/new
  # GET /product_lines/new.xml
  def new
    @product_line = ProductLine.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @product_line }
    end
  end

  # GET /product_lines/1/edit
  def edit
    @product_line = ProductLine.find(params[:id])
  end

  # POST /product_lines
  # POST /product_lines.xml
  def create
    @product_line = ProductLine.new(params[:product_line])

    respond_to do |format|
      if @product_line.save
        format.html { redirect_to([:admin, @product_line], :notice => 'Product line was successfully created.') }
        format.xml  { render :xml => @product_line, :status => :created, :location => @product_line }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @product_line.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /product_lines/1
  # PUT /product_lines/1.xml
  def update
    @product_line = ProductLine.find(params[:id])

    respond_to do |format|
      if @product_line.update_attributes(params[:product_line])
        format.html { redirect_to([:admin, @product_line], :notice => 'Product line was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @product_line.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /product_lines/1
  # DELETE /product_lines/1.xml
  def destroy
    @product_line = ProductLine.find(params[:id])
    @product_line.destroy

    respond_to do |format|
      format.html { redirect_to(admin_product_lines_url) }
      format.xml  { head :ok }
    end
  end
end
