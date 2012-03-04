class Product < ActiveRecord::Base
  belongs_to              :product_line
  belongs_to              :vendor
  belongs_to              :discoverer,          :class_name => "User",  :foreign_key => "uploader_id"
  belongs_to              :product_target_audience
  has_many                :reviews,             :dependent => :destroy
  has_many                :questions,           :dependent => :destroy  
  has_many                :answers,             :dependent => :destroy
  has_many                :my_collection_items
  has_many                :owners,              :source => :user, :through => :my_collection_items
  #has_many                :wishlist_items,      :dependent => :destroy
  has_many                :responses,           :dependent => :destroy, :class_name => "ProductResponse"
  has_many                :comments,            :dependent => :destroy, :class_name => "ProductComment"
  
  # Right now, we are assuming there is only 1 product_link and thus only 1 price range
  has_one                 :product_link,        :dependent => :destroy
  has_one                 :price_range,         :through => :product_link
  
  has_attached_file       :thumbnail, 
                          :styles => {  :thumb => ["100x100#", :png],
                                        :small => ["160x160#", :png],
                                        :medium => ["300x300>", :png],
                                     },
                          :url => "/assets/products/:attachment/:id/:style/:filename",
                          :path => ":rails_root/public/assets/products/:attachment/:id/:style/:filename"

  validates               :name, 
                          :length => { :minimum => 3, :maximum => 100, :too_short => "must have at least %{count} characters", :too_long => "must have at most %{count} characters" },
                          :uniqueness => { :scope => [:vendor_id, :product_line_id], :case_sensitive => false, :message => "is created in the vendor you specified already."}
  validates               :description, 
                          :length => { :maximum => 1000, :too_long => "must have at most %{count} characters" }
  validates               :vendor, :presence => true
  validates               :product_line, :presence => true
  #validates_associated    :product_line
  #validates_associated    :vendor

  validates_attachment_size         :thumbnail, :less_than => 700000,  :message => "should be less than 700KB."
  validates_attachment_content_type :thumbnail, :content_type => ["image/jpeg", "image/pjpeg", "image/gif", "image/png"], :message => "should be JPG, PNG or GIF."
  
  accepts_nested_attributes_for :vendor, :reject_if => lambda { |a| a[:name].blank? }
  accepts_nested_attributes_for :product_link, :reject_if => lambda { |a| a[:link].blank? }
  attr_accessible         :name, :thumbnail, :vendor_id, :product_line_id, :vendor_attributes, :uploader_id, :description, :image_url, :product_link_attributes, :product_target_audience_id
  
  searchable do
    integer :id
    integer :product_line_id
    integer :response_ids, :multiple => true
    integer :vendor_id
    text  :name, :more_like_this => true
    text  :vendor_name, :more_like_this => true do
      vendor.name
    end
    text  :category_name, :more_like_this => true do
      product_line.name
    end
    time  :updated_at
  end
  
  def to_param
    "#{id}-#{name.parameterize}"
  end
  
  def like?(user)
    return Product.like?(self, user)
  end
  
  def people_who_owned
    @search = Sunspot.search(MyCollectionItem) do
      with(:product_id, self.id)
      with(:interest_indicator, 1)
    end
    @people_who_owned = @search.results.map { |i| i.user }
  end

  def people_who_wished 
    @search = Sunspot.search(MyCollectionItem) do
      with(:product_id, self.id)
      with(:interest_indicator, 2)
    end
    @people_who_wished = @search.results.map { |i| i.user }
  end
  
  def self.like?(product, user)
    @search = Sunspot.search(ProductResponse) do
      with  :product_id, product.id 
      with  :user_id, user.id
    end
    
    if @search.results.size > 0
      return true
    else
      return false
    end
  end
  
  # This is created for Activity.log_activity
  def user
    self.discoverer
  end
  
  #def self.search(search)
  #  if search
  #    where('name LIKE ?', "%#{search}%")
  #  else
  #    scoped
  #  end
  #end
end
