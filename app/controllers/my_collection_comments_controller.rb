class MyCollectionCommentsController < ApplicationController
  before_filter :store_location
  before_filter :authenticate_user!
  
  # POST /my_collections
  # POST /my_collections.xml
  def create
    logger.info "In MyCollectionCommentsController.create"
    @my_collection_comment = MyCollectionComment.new(params[:my_collection_comment])

    if @my_collection_comment.save
      logger.info "Comment is successfully saved - #{@my_collection_comment.content}."
    end
    
    @my_collection = MyCollection.find(@my_collection_comment.my_collection_id)
    @my_collection_comments = @my_collection.comments.order("created_at DESC")
  end
  
end
