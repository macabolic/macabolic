class PhotoEntryCommentsController < ApplicationController
  before_filter :store_location
  before_filter :authenticate_user!

  # POST /my_collections
  # POST /my_collections.xml
  def create
    logger.debug "In PhotoEntryCommentsController.create"
    @photo_entry_comment = PhotoEntryComment.new(params[:photo_entry_comment])

    if @photo_entry_comment.save
      logger.debug "Comment is successfully saved - #{@photo_entry_comment.content}."
    end
    
    @photo_entry = PhotoEntry.find(@photo_entry_comment.photo_entry_id)
    @photo_contest = PhotoContest.find(@photo_entry_comment.photo_contest_id)
    @photo_entry_comments = @photo_entry.comments.order("created_at DESC")
  end

end
