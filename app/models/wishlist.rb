class Wishlist < ActiveRecord::Base
  has_many    :wishlist_items,   :dependent => :destroy
  belongs_to  :user
  
#  attr_accessible :name, :default_list
  
  def self.create_default_if_not_present(user)
    # First check if that user has a default wishlist
    if self.defined_default_wishlist?(user)
      wishlist = self.default_wishlist(user)
    else
      wishlist = Wishlist.create(:name => "My Wishlist", :user_id => user.id, :default_list => true)
    end
    
    return wishlist
  end
  
  def self.defined_default_wishlist?(user)
    #Wishlist.where(:user_id => user.id, :default_list => true).exists?
    where("user_id = ?", user.id).exists?
  end
  
  def self.default_wishlist(user)
#    where("user_id = ? AND default_lst = ?", user.id, true)
    where("user_id = ?", user.id).first
  end
end
