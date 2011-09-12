class User < ActiveRecord::Base
  has_many  :authentications
  has_many  :wishlists, :dependent => :destroy
  has_many  :my_collections, :dependent => :destroy
  has_many  :reviews
  has_many  :questions
  has_many  :activities
  
  has_many  :sent_invitations,  :class_name => 'Invitation', :foreign_key => 'sender_id'
  has_many  :my_collection_items
  has_many  :products, :through => :my_collection_items
  
  has_many  :friendships
  has_many  :friends, :through => :friendships

  #has_many  :inverse_friendships, :class_name => 'Friendship', :foreign_key => 'friend_id'
  #has_many  :inverse_friends, :through => :inverse_friendships, :source => :user
  
  belongs_to :invitation
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :remember_me, :birthday, :gravatar, :invitation_token
  
  validate            :first_name,    :presence => true
  validates_length_of :first_name,    :minimum => 2, :too_short => "%{count} characters is the minimum allowed."

  validate            :last_name,     :presence => true
  validates_length_of :last_name,     :minimum => 2, :too_short => "%{count} characters is the minimum allowed."  
  
  #validate            :email, :presence => true
  validates_format_of :email, :with => /[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}/i, :message => "is not a valid email address."
  
  before_create :set_invitation_limit

  def full_name
    fn = first_name
    fn = fn + ' ' if !first_name.nil?
    fn = fn + last_name

    return fn
  end
  
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
  
  def default_collection
    MyCollection.default_collection(self)
  end
  
  def own_this_product?(product)    
    MyCollection.joins(:my_collection_items).where(:user_id => self.id, :my_collection_items => { :product_id => product.id }).any?
  end
  
  def invitation_token
    invitation.token if invitation
  end

  def invitation_token=(token)
    self.invitation = Invitation.find_by_token(token)
  end

  def all_activities
    result = Activity.user_activities(self).concat(Activity.user_friends_activities(self))
    # to sort multiple fields, it can be done
    # result.sort! { |a, b| [b.performed_at, a.user_id] <=> [a.performed_at, b.user_id] }
    # the above will first order by performed_at desc and user_id asc
    result.sort! { |a, b| b.performed_at <=> a.performed_at }
  end

  
  private
  
  def set_invitation_limit
    self.invitation_limit = 5
  end
    
end
