class RecommendationsController < ApplicationController
  before_filter :store_location
  before_filter :authenticate_user!

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
    @recommendation = Recommendation.new(params[:recommendation])

    user_array.each do |user_id|
      @recommendation.recommended_users.build(:user_id => user_id)
    end
    
    if !@recommendation.save
      logger.error "Unable to save the recommendation: #{@recommendation.to_yaml}."
    end
    
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
