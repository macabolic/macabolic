class QuestionsController < ApplicationController
  before_filter :store_location, :except => :show
  before_filter :authenticate_user!, :except => :show
  
  # GET /questions
  # GET /questions.xml
  #def index
  #  @questions = Question.all

  #  respond_to do |format|
  #    format.html # index.html.erb
  #    format.xml  { render :xml => @questions }
  #  end
  #end

  # GET /questions/1
  # GET /questions/1.xml
  def show
    @question = Question.find(params[:id])
    @user = current_user
    @answers = @question.answers.order("created_at DESC").page params[:answer_page]
    @product = Product.find(params[:product_id])
    @my_collection_item = MyCollectionItem.find(params[:my_collection_item_id])  if params[:my_collection_item_id].present?

  #  respond_to do |format|
  #    format.html # show.html.erb
  #    format.xml  { render :xml => @question }
  #  end
  end

  # GET /questions/new
  # GET /questions/new.xml
  #def new
  #  @question = Question.new

  #  respond_to do |format|
  #    format.html # new.html.erb
  #    format.xml  { render :xml => @question }
  #  end
  #end

  # GET /questions/1/edit
  #def edit
  #  @question = Question.find(params[:id])
  #end

  # POST /questions
  # POST /questions.xml
  def create
    @question = Question.new(params[:question])
    #@question.product_id = params[:product_id]
    @question.user_id = current_user.id
    
    logger.info "========================================="
    logger.info "Question [title]: #{@question.title}"
    logger.info "Question [product_id]: #{@question.product_id}"
    logger.info "Question [user_id]: #{@question.user_id}"
    logger.info "My Collecton Item: #{params[:my_collection_item_id]}"
    logger.info "========================================="
    
    respond_to do |format|
      if @question.save
        #format.html { redirect_to(@question, :notice => 'Question was successfully created.') }
        if params[:page_id] == 'MyCollectionItem'
          product = Product.find(@question.product_id)
          my_collection_item = MyCollectionItem.find(params[:my_collection_item_id])
          format.html { redirect_to(product_my_collection_item_path(product, my_collection_item)) }
        elsif params[:page_id] == 'Home'
          format.html { redirect_to member_path(current_user) }
        else
          format.html { redirect_to(:controller => 'products', :action => 'show', :id => @question.product_id, :notice => 'Questions was successfully created.') }
          format.xml  { render :xml => @question, :status => :created, :location => @question }
        end
      #else
      #  format.html { render :action => "new" }
      #  format.xml  { render :xml => @question.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /questions/1
  # PUT /questions/1.xml
  def update
    @question = Question.find(params[:id])

    respond_to do |format|
      if @question.update_attributes(params[:question])
        format.html { redirect_to(@question, :notice => 'Question was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @question.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.xml
  def destroy
    @question = Question.find(params[:id])
    @question.destroy

    respond_to do |format|
      format.html { redirect_to(questions_url) }
      format.xml  { head :ok }
    end
  end
  
  def back
    @questions = Question.where(:product_id => params[:product_id]).order("created_at DESC").page params[:question_page]
    @product = Product.find(params[:product_id])
    @my_collection_item = MyCollectionItem.find(params[:my_collection_item_id]) if params[:my_collection_item_id].present?
  end
end
