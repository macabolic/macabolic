class Vendor < ActiveRecord::Base
  has_many    :products
  has_many    :responses,                 :dependent => :destroy, :class_name => "VendorResponse"
  has_many    :followers,                 :dependent => :destroy, :class_name => "VendorFollower"
  
  has_attached_file       :logo, 
                          :styles => { :thumb => ["50x50#", :png], :small => ["180x180#", :png], :medium => ["300x300>", :png], :large => ["600x600>", :png] },
                          :url => "/assets/vendors/:attachment/:id/:style/vendor-:id-:filename",
                          :path => ":rails_root/public/assets/vendors/:attachment/:id/:style/vendor-:id-:filename",
                          :default_url => "/images/default_photo.png"
  
  searchable do
    text  :vendor_name do
      self.name
    end
  end

  def to_s
    return name
  end

  def to_param
    "#{id}-#{name.parameterize}"
  end

  def like?(user)
    return Vendor.like?(self, user)
  end
 
  def following?(user)
    return Vendor.following?(self, user)
  end
  
  def self.like?(vendor, user)
    @search = Sunspot.search(VendorResponse) do
      with  :vendor_id, vendor.id 
      with  :user_id, user.id
    end
    
    if @search.results.size > 0
      return true
    else
      return false
    end
  end

  def self.following?(vendor, user)
    @search = Sunspot.search(VendorFollower) do
      with  :vendor_id, vendor.id 
      with  :follower_id, user.id
    end
    
    if @search.results.size > 0
      return true
    else
      return false
    end
  end  
  
end
