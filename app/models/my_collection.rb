class MyCollection < ActiveRecord::Base
  belongs_to  :user
  has_many    :my_collection_items,       :dependent => :destroy
  has_many    :responses,                 :dependent => :destroy, :class_name => "MyCollectionResponse"
  has_many    :comments,                  :dependent => :destroy, :class_name => "MyCollectionComment"
  has_many    :followers,                 :dependent => :destroy, :class_name => "MyCollectionFollower"
  
  accepts_nested_attributes_for :my_collection_items, :reject_if => lambda { |a| a[:product_id].blank? }, :allow_destroy => true
  
  #has_permalink           :name
  has_attached_file       :thumbnail, 
                          :styles => { :thumb => ["50x50>", :png], :small => ["180x180>", :png], :medium => ["300x300>", :png], :large => ["600x600>", :png] },
                          :url => "/assets/members/my_collections/:attachment/:id/:style/:filename",
                          :path => ":rails_root/public/assets/members/my_collections/:attachment/:id/:style/:filename",
                          :default_url => "/images/product/no-image_:style.jpg",
                          :default_style => :thumb
  
  validates_attachment_size :thumbnail,  :less_than => 700000,  :message => "should be less than 700KB."
  
  DEFAULT_COLLECTION_NAME = "My Collection"
  
  scope :featured_collections, limit(3)
  
  def to_param
    "#{id}-#{name.parameterize}"
  end
  
  def like?(user)
    return MyCollection.like?(self, user)
  end
  
  def following?(user)
    return MyCollection.following?(self, user)
  end
      
  def self.add_product_to_collection(user, product)
    # 1. Create default 'My Collection', if necessary
    my_collection = self.create_default_if_not_present(user)
    
    # 2. Initiate MyCollectionItem
    my_collection_item = MyCollectionItem.new(:my_collection_id => my_collection.id, :product_id => product.id)
    my_collection_item.save
    
    return my_collection
  end
  
  def self.create_default_if_not_present(user)
    # First check if that user has a default my_collection
    if self.defined_default_collection?(user)
      my_collection = self.default_collection(user)
    else
      my_collection = MyCollection.create(:name => DEFAULT_COLLECTION_NAME, :user_id => user.id)
    end

    return my_collection
  end

  def self.defined_default_collection?(user)
    where("user_id = ? AND name = ?", user.id, DEFAULT_COLLECTION_NAME).exists?
  end

  def self.default_collection(user)
    where("user_id = ? AND name = ?", user.id, DEFAULT_COLLECTION_NAME).first
  end

  def self.like?(my_collection, user)
    @search = MyCollectionResponse.search do
      with  :my_collection_id, my_collection.id 
      with  :user_id, user.id
    end
    
    if @search.results.size > 0
      return true
    else
      return false
    end
  end
    
  def self.following?(my_collection, user)
    @search = MyCollectionFollower.search do
      with  :my_collection_id, my_collection.id 
      with  :follower_id, user.id
    end
    
    if @search.results.size > 0
      return true
    else
      return false
    end
  end
  
end
