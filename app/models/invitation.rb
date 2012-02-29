class Invitation < ActiveRecord::Base
  belongs_to  :sender,    :class_name => 'User'
  has_one     :recipient, :class_name => 'User'
  
  validates_presence_of   :recipient_email
  validate                :recipient_is_not_registered
  #validate                :sender_has_invitations, :if => :sender
  #validate                :invitation_token_is_invalid
  
  before_create           :generate_token
  before_create           :decrement_sender_count, :if => :sender
  
  def is_accepted?
    # match if the invitation is existed in User model.
    User.where("invitation_id = ?", self.id).exists?
  end
  
private

  # During the invitation period, user is only allowed to use when he/she is registered + invited
  def recipient_is_not_registered
    errors.add :recipient_email, 'is already registered.' if User.where("email = ? and invitation_id is not null", recipient_email).exists?
  end
  #def recipient_is_not_registered
  #  errors.add :recipient_email, 'is already registered.' if User.find_by_email(recipient_email)
  #end
  
  def sender_has_invitations
    unless sender.invitation_limit > 0
      errors.add_to_base 'You have reached your limit of invitations to send.'
    end
  end
  
  def inviatation_token_is_invalid
    errors.add_to_base 'Your invitation is not valid.' if Invitation.where("token = ?", token).exists?
  end
  
  def generate_token
    self.token = Digest::SHA1.hexdigest([Time.now, rand].join)
  end
  
  def decrement_sender_count
    #sender.decrement! :invitation_limit
  end

end
