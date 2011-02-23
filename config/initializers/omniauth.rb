require 'openid/store/filesystem'
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, 'bG7H8OEtc1XFob5MVODcPw', 'QS3SEHTRTLdv4798dV2imogTJvIXgbsQ2V4Q52ftfA'
  provider :open_id, OpenID::Store::Filesystem.new('/tmp')
end
