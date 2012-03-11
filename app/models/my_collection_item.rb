class MyCollectionItem < ActiveRecord::Base
  belongs_to  :my_collection
  belongs_to  :product
  belongs_to  :user

  has_attached_file       :thumbnail, 
                          :styles => { :thumb => ["50x50#", :png], :small => ["150x150#", :png], :medium => ["300x300>", :png], :large => ["600x600>", :png] },
                          :url => "/assets/members/my_collections/my_collection_items/:attachment/:id/:style/:filename",
                          :path => ":rails_root/public/assets/members/my_collections/my_collection_items/:attachment/:id/:style/:filename",
                          :default_url => "/images/product/no-image_:style.jpg",
                          :default_style => :thumb
  
  validates_attachment_size         :thumbnail, :less_than => 700000,  :message => "should be less than 700KB."
  validates_attachment_content_type :thumbnail, :content_type => ["image/jpeg", "image/pjpeg", "image/gif", "image/png"], :message => "should be JPG, PNG or GIF."
  #validates_associated    :product    
  
  accepts_nested_attributes_for :product, :reject_if => lambda { |a| a[:name].blank? }  
  attr_accessible         :user_id, :product_id, :my_collection_id, :thumbnail, :interest_indicator, :product_attributes

  OWN = 1
  WISH = 2

  searchable do
    integer :id
    integer :my_collection_id
    integer :user_id
    integer :product_id
    text  :product_name
    integer :interest_indicator # OWN = 1; WISH = 2
    integer :product_line_id
    string  (:my_collection_id_str) { |p| p.my_collection_id.to_s }
    time  :updated_at    
  end
        
  def product_name
    self.product.name
  end
  
  def product_line_id
    self.product.product_line_id
  end
end
