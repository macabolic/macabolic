class User < ActiveRecord::Base
  has_many  :authentications, :dependent => :destroy
#  has_many  :wishlists, :dependent => :destroy
  has_many  :my_collections, :dependent => :destroy
  has_many  :reviews
  has_many  :questions
  has_many  :answers
  has_many  :activities, :dependent => :destroy
  
  has_many  :sent_invitations,  :class_name => 'Invitation', :foreign_key => 'sender_id'

  has_many  :my_collection_items, :dependent => :destroy
  has_many  :products, :through => :my_collection_items

#  has_many  :wishlist_items
  has_many  :owned_products, :through => :my_collection_items, :source => :product, :conditions => { :my_collection_items => {:interest_indicator => 1} }  
  has_many  :wished_products, :through => :my_collection_items, :source => :product, :conditions => { :my_collection_items => {:interest_indicator => 2} }
  
  has_many  :recommendations, :class_name => 'Recommendation', :foreign_key => 'from_user_id'
  has_many  :recommended_products, :through => :recommendations, :source => :product, :foreign_key => 'from_user_id'

  has_many  :discovered_products, :class_name => 'Product', :foreign_key => 'uploader_id'

#  has_many  :received_reommendations, :class_name => 'Recommendation', :foreign_key => 'to_user_id'
#  has_many  :being_recommended_products, :through => :recommendations, :source => :product, :foreign_key => 'to_user_id'
  
  has_many  :friendships
  has_many  :friends, :through => :friendships
  
  has_many  :profile_images, :dependent => :destroy
  
  # There is a problem with #{self.profile_image_id}.
  # The profile_image_id is null initially and running this associations will run into problem.
  has_one   :current_profile_image, :class_name => 'ProfileImage', :foreign_key => 'user_id', :conditions => 'id = #{self.profile_image_id}'

  belongs_to :invitation

  has_attached_file       :avatar, 
                          :styles => { :thumb => ["50x50#", :png], :small => ["180x180#", :png], :medium => ["300x300>", :png], :large => ["600x600>", :png] },
                          :url => "/assets/members/:attachment/:id/:style/member-:id-:filename",
                          :path => ":rails_root/public/assets/members/:attachment/:id/:style/member-:id-:filename",
                          :default_url => "/images/default_photo.png"

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable



  # Setup accessible (or protected) attributes for your model
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :remember_me, :birthday, :invitation_token, :avatar, :profile_image_id
  accepts_nested_attributes_for :my_collections, :reject_if => lambda { |a| a[:name].blank? }, :allow_destroy => true
  
  validate            :first_name,    :presence => true
  validates_length_of :first_name,    :minimum => 2, :too_short => "%{count} characters is the minimum allowed."

  validate            :last_name,     :presence => true
  validates_length_of :last_name,     :minimum => 2, :too_short => "%{count} characters is the minimum allowed."  
  
  #validate            :email, :presence => true
  validates_format_of :email, :with => /[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}/i, :message => "is not a valid email address."
  
  validates_attachment_size         :avatar,  :less_than => 100000,  :message => "should be less than 100KB."
  validates_attachment_content_type :avatar, :content_type => ["image/jpeg", "image/pjpeg", "image/gif", "image/png"], :message => "should be JPG, PNG or GIF."
  
  before_create :set_invitation_limit
  
  # TODO - Still deciding if I should create a default MyCollection. If I should, this should be the best place to do.
  # after_create :add_default_my_collection

  def full_name
    fn = first_name
    fn = fn + ' ' if !first_name.nil?
    fn = fn + last_name

    return fn
  end
  
  def password_required?
    (authentications.empty? || !password.blank?) && super
  end
  
  def default_collection
    MyCollection.default_collection(self)
  end
  
  def own_this_product?(product)    
    MyCollection.joins(:my_collection_items).where(:user_id => self.id, :my_collection_items => { :product_id => product.id, :interest_indicator => 1 }).any?
    #MyCollectionItem.where(:user_id => self.id, :product_id => product.id, :interest_indicator => 1).any?
  end

  def wish_this_product?(product)    
    #wished_products.where("product_id = ?", product.id)
    MyCollection.joins(:my_collection_items).where(:user_id => self.id, :my_collection_items => { :product_id => product.id, :interest_indicator => 2 }).any?
    #Wishlist.joins(:wishlist_items).where(:user_id => self.id, :wishlist_items => { :product_id => product.id }).any?
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
  
  def profile_image_set?
    !(profile_image_id.nil?)
  end
  
  def profile_image(provider)
    provider_image = profile_images.where(:provider => provider)
    if provider_image.size > 0
      provider_image[0]
    else
      nil
    end
  end
  
  # ==> A sample response from omniauth.auth
  #Omniauth.auth: 
  #<OmniAuth::AuthHash 
  #	credentials=#<Hashie::Mash 
  #		expires=true 
  #		expires_at=1323140400 
  #		token="AAADjFmJTOxABAL53CSoAnWZA9IsUezEuzFqe2LMIgw0ooAOyQ7QGJO9odfHKFTmNfIZCxvukpD0faXPZA2rwM6abTI1mTCgP0rJRMZCRZCAZDZD"> 
  #	extra=#<Hashie::Mash 
  #		raw_info=#<Hashie::Mash 
  #			birthday="09/22/1977" 
  #			email="billy.sf.cheng@gmail.com" 
  #			favorite_teams=[#<Hashie::Mash id="7724542745" name="Manchester United">] 
  #			first_name="Billy" 
  #			gender="male" 
  #			id="610814778" 
  #			last_name="Cheng" 
  #			link="http://www.facebook.com/profile.php?id=610814778" 
  #			locale="en_US" 
  #			name="Billy Cheng" 
  #			sports=[#<Hashie::Mash id="105942022769573" name="Golf">, #<Hashie::Mash id="105650876136555" name="Tennis">] 
  #			timezone=8 updated_time="2011-06-18T17:36:23+0000" 
  #			verified=true>> 
  #	info=#<OmniAuth::AuthHash::InfoHash 
  #		email="billy.sf.cheng@gmail.com" 
  #		first_name="Billy" 
  #		image="http://graph.facebook.com/610814778/picture?type=square" 
  #		last_name="Cheng" 
  #		name="Billy Cheng" 
  #		urls=#<Hashie::Mash Facebook="http://www.facebook.com/profile.php?id=610814778">> 
  #	provider="facebook" 
  #	uid="610814778"
  #>
  def apply_omniauth(omniauth)
    self.first_name = omniauth.info.first_name if first_name.blank?
    self.last_name = omniauth.info.last_name if last_name.blank?
    self.email = omniauth.info.email if email.blank?
    self.birthday = omniauth.extra.raw_info.birthday if birthday.blank?
    authentications.build(:provider => omniauth.provider, :uid => omniauth.uid, :token => omniauth.credentials.token)
    profile_images.build(:provider => omniauth.provider, :uid => omniauth.uid)
    profile_images.build(:provider => ProfileImage::MACABOLIC, :uid => omniauth.info.email);
    profile_images.build(:provider => ProfileImage::GRAVATAR, :uid => omniauth.info.email);
  end
  
  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"]
        user.email = data.info.email
        user.first_name = data.info.first_name
        user.last_name = data.info.last_name
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
    #data = access_token['extra']['user_hash']
    data = access_token.extra.raw_info
    logger.info "=============== Facebook login ========================="
    logger.info ":access_token => #{access_token}"
    logger.info "========================================================"
  
    #Omniauth.auth: 
    #<OmniAuth::AuthHash 
    #	credentials=#<Hashie::Mash 
    #		expires=true 
    #		expires_at=1323140400 
    #		token="AAADjFmJTOxABAL53CSoAnWZA9IsUezEuzFqe2LMIgw0ooAOyQ7QGJO9odfHKFTmNfIZCxvukpD0faXPZA2rwM6abTI1mTCgP0rJRMZCRZCAZDZD"> 
    #	extra=#<Hashie::Mash 
    #		raw_info=#<Hashie::Mash 
    #			birthday="09/22/1977" 
    #			email="billy.sf.cheng@gmail.com" 
    #			favorite_teams=[#<Hashie::Mash id="7724542745" name="Manchester United">] 
    #			first_name="Billy" 
    #			gender="male" 
    #			id="610814778" 
    #			last_name="Cheng" 
    #			link="http://www.facebook.com/profile.php?id=610814778" 
    #			locale="en_US" 
    #			name="Billy Cheng" 
    #			sports=[#<Hashie::Mash id="105942022769573" name="Golf">, #<Hashie::Mash id="105650876136555" name="Tennis">] 
    #			timezone=8 updated_time="2011-06-18T17:36:23+0000" 
    #			verified=true>> 
    #	info=#<OmniAuth::AuthHash::InfoHash 
    #		email="billy.sf.cheng@gmail.com" 
    #		first_name="Billy" 
    #		image="http://graph.facebook.com/610814778/picture?type=square" 
    #		last_name="Cheng" 
    #		name="Billy Cheng" 
    #		urls=#<Hashie::Mash Facebook="http://www.facebook.com/profile.php?id=610814778">> 
    #	provider="facebook" 
    #	uid="610814778"
    #>        
    if user = User.find_by_email(data.email)
      logger.info "Found user with email => #{data.email}."
      user
    else # Create a user with a stub password. 
      logger.info "Cound not find a registered user. Go create one now."
      user = User.new(:first_name => data.first_name, :last_name => data.last_name, :email => data.email, :password => Devise.friendly_token[0,20]) 
      #user = User.find_by_email(data["email"])
      user.authentications.build(:provider => access_token.provider, :uid => access_token.uid, :token => access_token.credentials.token)
      user.profile_images.build(:provider => access_token.provider, :uid => access_token.uid)
      user
      #logger.info "Done create one? #{user.persisted?}"
    end
  end  
  
#  def self.find_for_twitter_oauth(access_token, signed_in_resource=nil)
#    logger.info "==> User.find_for_twitter_oauth..."
#    data = access_token['extra']['user_hash']
#    logger.info "twitter authentication..."
#    logger.info "data: #{data}"
#    if user = User.find_by_email(data["email"])
#      logger.info "data email: #{data[:email]}"
#      user
#    else # Create a user with a stub password. 
#      User.create(:email => data["email"], :password => Devise.friendly_token[0,20]) 
#      logger.info "twitter account is created in the database."
#    end
#  end  

#  def self.find_for_google_oauth(access_token, signed_in_resource=nil)
#    data = access_token['extra']['user_hash']
#    logger.info "google authentication..."
#    logger.info "data: #{data}"
#    if user = User.find_by_email(data["email"])
#      logger.info "data email: #{data[:email]}"
#      user
#    else # Create a user with a stub password. 
#      User.create(:email => data["email"], :password => Devise.friendly_token[0,20]) 
#      logger.info "google account is created in the database."
#    end
#  end  

  
  private
  
  def set_invitation_limit
    self.invitation_limit = 5
  end
    
end
