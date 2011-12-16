class ProfileImage < ActiveRecord::Base
  belongs_to  :user
  
  MACABOLIC = "macabolic"
  FACEBOOK  = "facebook"
  GRAVATAR  = "gravatar"
    
end
