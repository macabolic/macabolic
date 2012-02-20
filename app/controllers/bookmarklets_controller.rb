class BookmarkletsController < ApplicationController
  def new
    redirect_to bookmarklet_products_path(:image_url => params[:image_url])
  end
end