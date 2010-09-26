class Product < ActiveRecord::Base
  has_many                :my_collections, :through => :my_collection_details
  has_many                :users, :through => :my_collections
  has_and_belongs_to_many :product_categories
  belongs_to              :product_line
  belongs_to              :vendor
  
  has_attached_file :photo, :styles => { :small => "150x150>", :thumb => "75x75>" },
                    :url => "/assets/products/:id/:attachment/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/products/:id/:attachment/:style/:basename.:extension"
                    
  #validates_attachment_presence :thumbnail
  #validates_attachment_size     :thumbnail, :less_than => 5.megabytes
  #validates_attachment_content_type :thumbnail, :content_type => ['image/jpeg', 'image/png']
  
end
