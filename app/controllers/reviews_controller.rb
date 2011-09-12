class ReviewsController < ApplicationController
  # GET /reviews
  # GET /reviews.xml
  def index
    @reviews = Review.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @reviews }
    end
  end

  # GET /reviews/1
  # GET /reviews/1.xml
  def show
    @review = Review.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @review }
    end
  end

  # GET /reviews/new
  # GET /reviews/new.xml
  def new
    @review = Review.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @review }
    end
  end

  # GET /reviews/1/edit
  def edit
    @review = Review.find(params[:id])
  end

  # POST /reviews
  # POST /reviews.xml
  def create
    @review = Review.new(params[:review])
    @review.user = current_user
    
    respond_to do |format|
      if @review.save
        format.html { redirect_to(@review, :notice => 'Review was successfully created.') }
        format.xml  { render :xml => @review, :status => :created, :location => @review }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @review.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /reviews/1
  # PUT /reviews/1.xml
  def update
    @review = Review.find(params[:id])

    respond_to do |format|
      if @review.update_attributes(params[:review])
        format.html { redirect_to(@review, :notice => 'Review was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @review.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /reviews/1
  # DELETE /reviews/1.xml
  def destroy
    @review = Review.find(params[:id])
    @review.destroy

    respond_to do |format|
      format.html { redirect_to(reviews_url) }
      format.xml  { head :ok }
    end
  end
  
  def vote
    logger.info "vote for the review..."
    logger.info "vote value: #{params[:vote]}"
    # 1. Check if the current_user has an entry in the review_response.
    @review_response = ReviewResponse.where("user_id = ? and review_id = ?", current_user.id, params[:id])
    if @review_response.exists?
      logger.info "Review Response exists: #{@review_response.first}." 
      if @review_response.first.update_attributes(:response_for => params[:vote])     
        logger.info "Review response updated: #{params[:vote]}"
      else
        logger.info "Some problem updating the review response: #{@review_response.first.errors}"
      end
    else
      @review_response = ReviewResponse.new
      @review_response.review_id = params[:id]
      @review_response.response_for = params[:vote]
      @review_response.user = current_user
      
      if @review_response.save
        logger.info "Review Response newly created: #{@review_response}."
      else
        logger.info "Sorry, for some reason your vote is not valid!"
      end
    end
    
    @review_id = params[:id]
    @vote_like_count = ReviewResponse.where("review_id = ? and response_for = ?", params[:id], true).size
    @vote = params[:vote]
  end
end
