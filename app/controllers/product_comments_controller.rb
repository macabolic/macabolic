class ProductCommentsController < ApplicationController

  # POST /my_collections
  # POST /my_collections.xml
  def create
    logger.info "In ProductCommentsController.create"
    @product_comment = ProductComment.new(params[:product_comment])

    if @product_comment.save
      logger.info "Comment is successfully saved - #{@product_comment.content}."
    end
    
    @product = Product.find(@product_comment.product_id)
    @product_comments = @product.comments.order("created_at DESC")
  end

end
