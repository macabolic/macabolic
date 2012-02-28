class VendorFollower < ActiveRecord::Base
  belongs_to  :vendor
  belongs_to  :follower,  :class_name => 'User'
  
  searchable do
    integer :vendor_id
    integer :follower_id
  end
end
