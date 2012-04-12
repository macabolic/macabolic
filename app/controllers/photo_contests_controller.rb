class PhotoContestsController < ApplicationController
  before_filter :store_location
  before_filter :authenticate_user!, :except =>  [:index, :show]

  # GET /photo_contests/1
  # GET /photo_contests/1.xml
  def show
    @photo_contest = PhotoContest.find(params[:id])
    @photo_entries = @photo_contest.entries.order("created_at DESC").page params[:page]
    
    if user_signed_in?
      @photo_entry = PhotoEntry.new(:photo_contest_id => params[:id], :poster_id => current_user.id)
    else
      @photo_entry = PhotoEntry.new(:photo_contest_id => params[:id])
    end
  end

end
