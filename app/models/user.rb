class User < ActiveRecord::Base
  has_many  :authentications, :dependent => :destroy
  has_many  :wishlists, :dependent => :destroy
  has_many  :my_collections, :dependent => :destroy
  has_many  :reviews
  has_many  :questions
  has_many  :activities
  
  has_many  :sent_invitations,  :class_name => 'Invitation', :foreign_key => 'sender_id'

  has_many  :my_collection_items
  has_many  :products, :through => :my_collection_items

  has_many  :wishlist_items
  has_many  :wished_products, :through => :wishlist_items, :source => :product
  
  has_many  :recommendations, :class_name => 'Recommendation', :foreign_key => 'from_user_id'
  has_many  :recommended_products, :through => :recommendations, :source => :product, :foreign_key => 'from_user_id'
  
  has_many  :received_reommendations, :class_name => 'Recommendation', :foreign_key => 'to_user_id'
  has_many  :being_recommended_products, :through => :recommendations, :source => :product, :foreign_key => 'to_user_id'
  
  has_many  :friendships
  has_many  :friends, :through => :friendships

  #has_many  :inverse_friendships, :class_name => 'Friendship', :foreign_key => 'friend_id'
  #has_many  :inverse_friends, :through => :inverse_friendships, :source => :user
  
  belongs_to :invitation
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :remember_me, :birthday, :gravatar, :invitation_token
  accepts_nested_attributes_for :my_collections, :reject_if => lambda { |a| a[:name].blank? }, :allow_destroy => true
  
  validate            :first_name,    :presence => true
  validates_length_of :first_name,    :minimum => 2, :too_short => "%{count} characters is the minimum allowed."

  validate            :last_name,     :presence => true
  validates_length_of :last_name,     :minimum => 2, :too_short => "%{count} characters is the minimum allowed."  
  
  #validate            :email, :presence => true
  validates_format_of :email, :with => /[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}/i, :message => "is not a valid email address."
  
  before_create :set_invitation_limit
  
  # TODO - Still deciding if I should create a default MyCollection. If I should, this should be the best place to do.
  # after_create :add_default_my_collection

  def full_name
    fn = first_name
    fn = fn + ' ' if !first_name.nil?
    fn = fn + last_name

    return fn
  end
  
  def apply_omniauth(omniauth)
    self.first_name = omniauth['user_info']['first_name'] if first_name.blank?
    self.last_name = omniauth['user_info']['last_name'] if last_name.blank?
    self.email = omniauth['user_info']['email'] if email.blank?
    authentications.build(:provider => omniauth['provider'], :uid => omniauth["extra"]["user_hash"]['id'])
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

  def wish_this_product?(product)    
    Wishlist.joins(:wishlist_items).where(:user_id => self.id, :wishlist_items => { :product_id => product.id }).any?
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
  
  def confirmed?
    !(sign_in_count == 0)
  end
  
  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["user_hash"]
        user.email = data["email"]
        user.first_name = data["first_name"]
        user.last_name = data["last_name"]
      end
    end
  end
  
  # user_info name: Billy Cheng
  # urls  Facebook: http://www.facebook.com/profile.php?id=100002983805074
  #       Website
  #       nickname
  #       last_name: Cheng
  #       image: http://graph.facebook.com/100002983805074/picture?type=square
  #       first_name: Billy
  #       email: billy.cheng@macabolic.com
  #       uid: 100002983805074credentialstokenAAADjFmJTOxABAFR4m2zeA980ZCkEm8z5TG6pZCb87BxKCwZAG6sS4XjORYyZCaoJIB92EaqA4PM4lpzgY5X3xsNBDjfdVE9bHvsBu3fVIAZDZD
  #       extrauser_hashnameBilly Chengtimezone8gendermaleid100002983805074last_nameChengupdated_time2011-09-20T16:53:17+0000verifiedtruelocaleen_USlinkhttp://www.facebook.com/profile.php?id=100002983805074emailbilly.cheng@macabolic.comfirst_nameBillyproviderfacebook
    
  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token['extra']['user_hash']
    logger.info "User.find_for_facebook_oauth(:email => #{data['email']})."
    if user = User.find_by_email(data["email"])
      logger.info "Found user with email => #{data['email']}."
      user
    else # Create a user with a stub password. 
      logger.info "Cound not find a registered user. Go create one now."
      logger.info "Data => #{data}"
      logger.info "Extra => #{access_token['extra']}"
      logger.info "Access token => #{access_token}"
      logger.info "Provider => #{access_token['provider']}; UID => #{data['id']}"
      user = User.new(:first_name => data["first_name"], :last_name => data["last_name"], :email => data["email"], :password => Devise.friendly_token[0,20]) 
      #user = User.find_by_email(data["email"])
      user.authentications.build(:provider => access_token['provider'], :uid => data['id'])
      user
      #logger.info "Done create one? #{user.persisted?}"
    end
  end  
  
  def self.find_for_twitter_oauth(access_token, signed_in_resource=nil)
    data = access_token['extra']['user_hash']
    logger.info "twitter authentication..."
    logger.info "data: #{data}"
    if user = User.find_by_email(data["email"])
      logger.info "data email: #{data[:email]}"
      user
    else # Create a user with a stub password. 
      User.create(:email => data["email"], :password => Devise.friendly_token[0,20]) 
      logger.info "twitter account is created in the database."
    end
  end  

  def self.find_for_google_oauth(access_token, signed_in_resource=nil)
    data = access_token['extra']['user_hash']
    logger.info "google authentication..."
    logger.info "data: #{data}"
    if user = User.find_by_email(data["email"])
      logger.info "data email: #{data[:email]}"
      user
    else # Create a user with a stub password. 
      User.create(:email => data["email"], :password => Devise.friendly_token[0,20]) 
      logger.info "google account is created in the database."
    end
  end  

  
  private
  
  def set_invitation_limit
    self.invitation_limit = 5
  end
    
end
