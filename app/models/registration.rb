class Registration < ActiveRecord::Base
  validate            :first_name,    :presence => true
  validates_length_of :first_name,    :minimum => 2, :too_short => "%{count} characters is the minimum allowed."

  validate            :last_name,     :presence => true
  validates_length_of :last_name,     :minimum => 2, :too_short => "%{count} characters is the minimum allowed."
  
  validate            :email_address, :presence => true
  #validates_format_of :email_address, :with => /[A-Za-z0-9]@[A-Za-z0-9.-].[A-Za-z]/i, :message => "This is not a valid email address."
  validates_format_of :email_address, :with => /[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}/i, :message => "This is not a valid email address."
  validates_uniqueness_of :email_address, :case_sensitive => false, :message => "Thank you for your interest. Your email address is already registered before."
  
  def full_name
    fn = first_name
    fn = fn + ' ' if !first_name.nil?
    fn = fn + last_name

    return fn
  end
  
end
