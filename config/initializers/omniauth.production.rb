#require 'openid/store/filesystem'
Rails.application.config.middleware.use OmniAuth::Builder do
  provider  :facebook, '255146254550038', '3e1ee9b4a2653c9a0183860fa3382930', :scope => 'email, user_birthday, read_stream, offline_access', :display => 'page'
  provider  :twitter, '8WU2gyHJDv65KxiAAMG5ZQ', 'StLrLfygftKgn4kdCEvNzFHZxonCAFhuAi93Apet9Y'
end
