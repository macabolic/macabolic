module MyCollectionItemsHelper
  def thumbnail_image_path(image_path)
    content_for(:thumbnail_image_path) { 
      image_path 
    }
  end
end
