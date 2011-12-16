#require 'openid/store/filesystem'
Rails.application.config.middleware.use OmniAuth::Builder do
#  provider  :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'], :scope => 'email', :display => 'page'
  provider  :facebook, '249685278407440', 'ee1108c10a7b064834152a0959071e06', :scope => 'email, user_birthday, read_stream, offline_access', :display => 'page'
  provider  :twitter, '8WU2gyHJDv65KxiAAMG5ZQ', 'StLrLfygftKgn4kdCEvNzFHZxonCAFhuAi93Apet9Y'
#  provider :open_id, OpenID::Store::Filesystem.new('/tmp')
end
