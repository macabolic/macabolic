class PhotoEntriesController < ApplicationController
  
  # POST /photo_entries
  # POST /photo_entries.xml
  def create
    @photo_entry = PhotoEntry.new(params[:photo_entry])
    @photo_contest = PhotoContest.find(@photo_entry.photo_contest_id)
    
    respond_to do |format|
      if @photo_entry.save
        format.html { redirect_to(contest_entry_path(@photo_contest, @photo_entry), :notice => 'My photo entry was successfully submitted.') }
      else 
        format.html { redirect_to(contest_path(@photo_contest), :notice => 'Error in your submission.') }
      end
    end
  end
  
  def show
    @photo_entry = PhotoEntry.find(params[:id])
    @photo_contest = PhotoContest.find(params[:contest_id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @photo_entry }
    end      
  end
end
