class BookmarkletsController < ApplicationController
  before_filter :show_invitation_notice
  before_filter :store_location
  before_filter :authenticate_user!, :except =>  [:index, :search, :show]

  def new
    @product = Product.new(:image_url => params[:image_url])
    @user = current_user
    render "products/bookmarklet", :layout => nil
    #redirect_to bookmarklet_products_path(:image_url => params[:image_url])
  end
end