class RecommendationsController < ApplicationController
  # GET /recommendations/1
  # GET /recommendations/1.xml
  def show
    @recommendation = Recommendation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @recommendation }
    end
  end

  # POST /recommendations
  # POST /recommendations.xml
  def create
    logger.info "To user list: #{params[:to_user_id]}."    
    user_ids = params[:to_user_id]
    user_array = user_ids.split(",")
    user_array.each do |user_id|
      @recommendation = Recommendation.new(params[:recommendation])
      @recommendation.to_user_id = user_id
      logger.info "To user: #{@recommendation.to_user.id}."
      if !@recommendation.save
        logger.error "Unable to save the recommendation: #{@recommendation.to_yaml}."
      end
    end
    
    #respond_to do |format|
      #if @recommendation.save
      #  format.html { redirect_to(@recommendation, :notice => 'Recommendation was successfully created.') }
      #  format.xml  { render :xml => @recommendation, :status => :created, :location => @recommendation }
      #else
      #  format.html { render :action => "new" }
      #  format.xml  { render :xml => @recommendation.errors, :status => :unprocessable_entity }
      #end
    #end
  end

  # DELETE /recommendations/1
  # DELETE /recommendations/1.xml
  def destroy
    @recommendation = Recommendation.find(params[:id])
    @recommendation.destroy

    respond_to do |format|
      format.html { redirect_to(recommendations_url) }
      format.xml  { head :ok }
    end
  end
end
