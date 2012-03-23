class Authentication < ActiveRecord::Base
  belongs_to :user

  MACABOLIC = "macabolic"
  FACEBOOK  = "facebook"
  GRAVATAR  = "gravatar"
  TWITTER   = "twitter"
  
  def provider_name
    if provider == 'open_id'
      "OpenID"
    else
      provider.titleize
    end
  end
end
