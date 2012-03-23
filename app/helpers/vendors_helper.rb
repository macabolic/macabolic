module VendorsHelper
  def store_product_image(vendor)
    products = vendor.products
    if products.size > 0
  		if products[0].thumbnail.present?
  			return products[0].thumbnail.url(:medium)
  		elsif products[0].image_url.present?
  			return products[0].image_url
  		end
    end
    
    return "/images/default_photo.png"
  end
end
