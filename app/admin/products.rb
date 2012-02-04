ActiveAdmin.register Product do
  menu    :parent => "Product Maintenance", :priority => 1
  
  filter  :name
  filter  :product_line
  filter  :vendor
  
  index :as => :grid do |product|
    link_to image_tag(product.thumbnail.url(:medium), :width => "200", :class => "preview-image"), products_path(product)
  end  

  index do
    column  "Id" do |product|
      link_to product.id, admin_product_path(product)
    end
    column  :vendor
    column  :product_line
    column  :name
    column  :description
    column  :thumbnail_file_name
    column  :thumbnail_file_size
    column  :thumbnail_content_type
    default_actions
  end
  
    
  #form :partial => "form"  
  form do |f|
      f.inputs "Product" do
        f.input :name
        f.input :vendor
        f.input :product_line
        #f.input :thumbnail
        f.input :description
      end
      f.buttons
  end  
end
