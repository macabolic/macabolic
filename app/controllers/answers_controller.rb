class AnswersController < ApplicationController
  # GET /answers
  # GET /answers.xml
  def index
    @answers = Answer.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @answers }
    end
  end

  # GET /answers/1
  # GET /answers/1.xml
  def show
    @answer = Answer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @answer }
    end
  end

  # GET /answers/new
  # GET /answers/new.xml
  def new
    @answer = Answer.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @answer }
    end
  end

  # GET /answers/1/edit
  def edit
    @answer = Answer.find(params[:id])
  end

  # POST /answers
  # POST /answers.xml
  def create
    @answer = Answer.new(params[:answer])
    @answer.question_id = params[:question_id]
    @answer.user_id = current_user.id

    logger.info "========================================="
    logger.info "Answer [content]: #{@answer.content}"
    logger.info "Answer [question_id]: #{@answer.question_id}"
    logger.info "Answer [product_id]: #{params[:product_id]}"
    logger.info "Answer [user_id]: #{@answer.user_id}"
    logger.info "Answer [current_user]: #{current_user.id}"
    logger.info "========================================="

    @answer.save
    
    #respond_to do |format|
    #  if @answer.save
    #    format.html { redirect_to(:controller => 'products', :action => 'show', :id => params[:product_id], :notice => 'Your answer is successfully posted.') }
        #format.html { redirect_to(@answer, :notice => 'Answer was successfully created.') }
    #    format.xml  { render :xml => @answer, :status => :created, :location => @answer }
      #else
      #  format.html { render :action => "new" }
      #  format.xml  { render :xml => @answer.errors, :status => :unprocessable_entity }
    #  end
    #end
    
    @question = Question.find(params[:question_id])
  end

  # PUT /answers/1
  # PUT /answers/1.xml
  def update
    @answer = Answer.find(params[:id])

    respond_to do |format|
      if @answer.update_attributes(params[:answer])
        format.html { redirect_to(@answer, :notice => 'Answer was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @answer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /answers/1
  # DELETE /answers/1.xml
  def destroy
    @answer = Answer.find(params[:id])
    @answer.destroy

    respond_to do |format|
      format.html { redirect_to(answers_url) }
      format.xml  { head :ok }
    end
  end
  
  def vote
    logger.info "vote for the answer..."
    logger.info "vote value: #{params[:vote]}"
    # 1. Check if the current_user has an entry in the answer_response.
    @answer_response = AnswerResponse.where("user_id = ? and answer_id = ?", current_user.id, params[:id])
    if @answer_response.exists?
      logger.info "Answer Response exists: #{@answer_response.first}." 
      if @answer_response.first.update_attributes(:response_for => params[:vote])     
        logger.info "Answer response updated: #{params[:vote]}"
      else
        logger.info "Some problem updating the answer response: #{@answer_response.first.errors}"
      end
    else
      @answer_response = AnswerResponse.new
      @answer_response.answer_id = params[:id]
      @answer_response.response_for = params[:vote]
      @answer_response.user = current_user
      
      if @answer_response.save
        logger.info "Answer Response newly created: #{@answer_response}."
      else
        logger.info "Sorry, for some reason your vote is not valid!"
      end
    end
    
    @answer_id = params[:id]
    @vote = params[:vote]
    @vote_useful_count = AnswerResponse.where("answer_id = ? and response_for = ?", params[:id], true).size
  end
    
end
