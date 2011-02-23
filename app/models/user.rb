class User < ActiveRecord::Base
  has_many  :authentications
  has_many  :wishlists, :dependent => :destroy
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :remember_me, :birthday
  
  def apply_omniauth(omniauth)
    self.email = omniauth['user_info']['email'] if email.blank?
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
  end
  
  def password_required?
    (authentications.empty? || !password.blank?) && super
  end

  def has_default_wishlist?
    Wishlist.defined_default_wishlist?(self)
  end
  
  def create_default_wishlist_if_not_present
    wishlist = Wishlist.create_default_if_not_present(self)
  end
  
  def default_wishlist
    wishlist = Wishlist.default_wishlist(self)
  end
  
  def already_in_wishlist?(product)
    # Get the wishlist.
    # Search the wishlist with the provided product
  end
  
end
