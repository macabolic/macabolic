class ReviewsController < ApplicationController
  # GET /reviews
  # GET /reviews.xml
  def index
    @my_collection_detail = MyCollectionDetail.find(params[:my_collection_detail_id])
    @product = Product.find(params[:product_id])
    @reviews = @product.reviews

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @reviews }
    end
  end

  # GET /reviews/1
  # GET /reviews/1.xml
  def show
    @product = Product.find(params[:product_id])
    @review = @product.reviews.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @review }
    end
  end

  # GET /reviews/new
  # GET /reviews/new.xml
  def new
    @product = Product.find(params[:product_id])
    @review = @product.reviews.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @review }
    end
  end

  # GET /reviews/1/edit
  def edit
    @product = Product.find(params[:product_id])
    @review = @product.reviews.find(params[:id])
  end

  # POST /reviews
  # POST /reviews.xml
  def create
    @product = Product.find(params[:product_id])
    @review = @product.reviews.build(params[:review])

    respond_to do |format|
      if @review.save
        @review_summary = @review.product.review_summary
        # Create Review_Summary if necessary
        if @review_summary.nil?
          @review_summary = ReviewSummary.new
          @review_summary.product_id = @review.product.id
          @review_summary.number_of_reviews = 0
          @review_summary.avg_ratings = 0
          @review_summary.number_of_rating_one = 0
          @review_summary.number_of_rating_two = 0
          @review_summary.number_of_rating_three = 0
          @review_summary.number_of_rating_four = 0
          @review_summary.number_of_rating_five = 0
          @review_summary.save
        end
        
        # Update Review_Summary
        @review_summary.number_of_reviews += 1
        @review_summary.avg_ratings = (@review_summary.avg_ratings + @review.rating) / @review_summary.number_of_reviews
        if @review.rating == 1
          @review_summary.number_of_rating_one += 1
        elsif @review.rating == 2
          @review_summary.number_of_rating_two += 1
        elsif @review.rating == 3
          @review_summary.number_of_rating_three += 1
        elsif @review.rating == 4
          @review_summary.number_of_rating_four += 1
        elsif @review.rating == 5
          @review_summary.number_of_rating_five += 1
        else
          # something wrong here...
        end
        
        @review_summary.save
        
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
    @product = Product.find(params[:product_id])
    @review = @product.reviews.find(params[:id])

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
    #@product = Product.find(params[:product_id])
    @review = Review.find(params[:id])
## TODO
    # Update Review_Summary
    @review_summary = @review.product.review_summary
    #total_
    @review_summary.avg_ratings = (@review_summary.avg_ratings + @review.rating) / @review_summary.number_of_reviews
    @review_summary.number_of_reviews -= 1
    if @review.rating == 1
      @review_summary.number_of_rating_one += 1
    elsif @review.rating == 2
      @review_summary.number_of_rating_two += 1
    elsif @review.rating == 3
      @review_summary.number_of_rating_three += 1
    elsif @review.rating == 4
      @review_summary.number_of_rating_four += 1
    elsif @review.rating == 5
      @review_summary.number_of_rating_five += 1
    else
      # something wrong here...
    end

    #@review.destroy
    #@review_summary.save


    respond_to do |format|
      format.html { redirect_to(reviews_url) }
      format.xml  { head :ok }
    end
  end
end
