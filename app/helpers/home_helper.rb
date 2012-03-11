module HomeHelper

  def product_line_thumbnail(product_line_id) 
    default_url = "/images/product/no-image_thumb.jpg"
    first_product = Product.where(:product_line_id => product_line_id).order("updated_at DESC").first
    if first_product.present?      
  		if first_product.thumbnail.present?
  			return first_product.thumbnail.url(:thumb)
  		elsif first_product.image_url.present?
  		  return first_product.image_url
  		else
        return default_url
      end
    end
  end

  def product_line(product_line_id)
    product_line = ProductLine.find(product_line_id)
  end
  
end
